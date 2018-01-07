package com.liferay.damascus.antlr.generator;

import com.liferay.damascus.antlr.common.TemplateGenerateValidator;
import com.liferay.damascus.cli.common.CommonUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Source to Template convert engine
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
@Builder
public class SourceToTemplateEngine {

    /**
     * Process source files to convert to template files
     *
     * @throws IOException
     */
    public void process()
        throws IOException {

        // Normalize path
        templateDirPath = CommonUtil.normalizePath(templateDirPath);

        if (null == templateDirPath) {
            log.error("Template file path is invalid. <" + templateDirPath + ">");
            return;
        }

        // Get target file list
        List<File> targetFiles = CommonUtil.getTargetFiles(sourceRootPath, extentionPatterns);

        for (File target : targetFiles) {

            // Scan the source file if it includes dmsc root tag
            TemplateContext sourceTemplateContext =
                TemplateGenerator
                    .builder()
                    .contentsFile(target)
                    .build()
                    .getSourceContext();

            if (!validateSourceContext(sourceTemplateContext, target)) {
                continue;
            }

            System.out.println("processing file : " + target.getAbsolutePath());

            List<String> errors = TemplateGenerateValidator.rootValidator(sourceTemplateContext);

            if (!errors.isEmpty()) {
                for (String error : errors) {
                    System.out.println(error);
                }
                System.out.println("Error occurs at parameter validation of root tag. Skip this file.");
                continue;
            }

            // Scan the template file and fetch contents to replace
            String templateName     = sourceTemplateContext.getRootAttribute(DamascusProps.ATTR_TEMPLATE_NAME);
            File   templateFullPath = new File(templateDirPath + templateName);

            TemplateContext targetTemplateContext = null;
            if (templateFullPath.exists()) {

                targetTemplateContext
                    = TemplateScanner
                    .builder()
                    .contentsFile(templateFullPath)
                    .build()
                    .getTargetTemplateContext();
            }

            // Rescan the source file and replace contents if the template file has already exist.
            // Or simply copy the source to the template.
            String processedContents =
                TemplateGenerator.builder()
                    .contentsFile(target)
                    .targetTemplateContext(targetTemplateContext)
                    .build()
                    .process();

            // Replace keywords
            processedContents =
                CommonUtil.replaceKeywords(
                    processedContents,
                    replacements);

            // Output template file
            FileUtils.writeStringToFile(
                templateFullPath,
                processedContents,
                StandardCharsets.UTF_8);

        }
    }

    /**
     * Validate source context
     *
     * @param sourceTemplateContext source template context of the target file
     * @param target                target file object
     * @return true to process or skip to process this file.
     */
    private boolean validateSourceContext(TemplateContext sourceTemplateContext, File target) {

        if (!sourceTemplateContext.isRootTagExist()) {
            System.out.println("A root tag does not exist.  Skip. <" + target.getName() + ">");
            return false;
        }

        if (pickup) {
            if (!sourceTemplateContext.isPickup()) {
                System.out.println("Pickup flag is not on.      Skip. <" + target.getName() + ">");
                return false;
            }
        }

        return true;
    }

    /**
     * REQUIRED
     * <p>
     * Source files' root directory.
     * (this method will process directories under the root recursively)
     */
    @NonNull
    private String sourceRootPath;

    /**
     * REQUIRED
     * <p>
     * Template files' root directory.
     * The path must be end with '/'
     */
    @NonNull
    private String templateDirPath;

    /**
     * White list of process target file extensions.
     */
    @Builder.Default
    private List<String> extentionPatterns = EXT_WHITE_LIST;

    // White list of searching directory.
    // TODO: This value must be configured in settings.properties under .damascus
    static public final List<String> EXT_WHITE_LIST =
        Arrays.asList(
            ".*.java",
            ".*.jsp",
            ".*.xml",
            ".*.bnd",
            ".*.gradle",
            ".*.properties",
            ".*.json",
            ".*.jspf"
        );

    /**
     * Replacement keywords map from base.json
     */
    @Builder.Default
    private Map<String, String> replacements = new ConcurrentHashMap<>();

    /**
     * Pick up flag
     * <p>
     * If this is true, processing only files that
     * pickup attribute is configured true in the target source files.
     */
    @Builder.Default
    private boolean pickup = false;
}
