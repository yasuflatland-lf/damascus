package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.liferay.damascus.antlr.generator.ReplacementGenerator;
import com.liferay.damascus.antlr.generator.SourceToTemplateEngine;
import com.liferay.damascus.cli.common.CommonUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.common.PropertyContext;
import com.liferay.damascus.cli.common.PropertyContextFactory;
import com.liferay.damascus.cli.exception.DamascusProcessException;
import com.liferay.damascus.cli.json.Application;
import com.liferay.damascus.cli.json.DamascusBase;
import com.liferay.damascus.cli.validators.ProjectNameValidator;
import lombok.Data;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.configuration2.ex.ConfigurationException;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Template Generator command
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
@Data
public class TemplateGeneratorCommand implements ICommand {

    /**
     * Judge if Init is runnable
     *
     * @return true if it's runnable or false
     */
    @Override
    public boolean isRunnable(Damascus damascus) {

        if (!damascus.getGenerate().equals(GEN_COMMAND_TEMPLATE)) {
            return false;
        }

        if (getModel().isEmpty()) {
            System.out.println("Model need to be configured for generating templates.");
            return false;
        }

        return true;
    }

    @Override
    public void run(Damascus damascus, String... args) {
        System.out.println("Generating templates...");

        // Template path
        String processedTemplateDir = CommonUtil.normalizePath(this.getTemplateDirPath());

        if (null == processedTemplateDir) {
            System.out.println("Template file path is invalid. <" + this.getTemplateDirPath() + ">");
            return;
        }

        // Source root directory / base.json path
        String processedSourceRootPath = CommonUtil.normalizePath(this.getSourceRootPath());

        if (null == processedSourceRootPath) {
            System.out.println("Base json directory path is invalid. <" + this.getSourceRootPath() + ">");
            return;
        }

        //
        // Process
        //
        try {

            DamascusBase dmsb =
                ReplacementGenerator
                    .writeToFile(
                        new File(processedSourceRootPath + DamascusProps.BASE_JSON),
                        null
                    );

            PropertyContext     propertyContext    = PropertyContextFactory.createPropertyContext();
            String              checkPattern       = propertyContext.getString(DamascusProps.PROP_EXT_WHITE_LIST);
            List<String>        extensionPatterns  = getWhiteExtentionPatterns(checkPattern);
            Map<String, String> replacementPattern = getReplacementPatternByModel(dmsb, this.getModel());

            if (replacementPattern.isEmpty()) {
                System.out.println("Model name has not been found. Model name <" + this.getModel() + ">");
                return;
            }

            SourceToTemplateEngine
                .builder()
                .sourceRootPath(
                    processedSourceRootPath
                )
                .templateDirPath(
                    processedTemplateDir + damascus.getLiferayVersion()
                )
                .replacements(
                    replacementPattern
                )
                .extentionPatterns(
                    extensionPatterns
                )
                .build()
                .process();

        } catch (DamascusProcessException e) {
            System.out.println(e.getMessage());

        } catch (IOException e) {
            e.printStackTrace();

        } catch (ConfigurationException e) {
            e.printStackTrace();

        }

        System.out.println("Done.");

    }

    /**
     * Get White Extension Patterns
     *
     * @param extPattern White extension pattern strings
     * @return Extension pattern List
     */
    private List<String> getWhiteExtentionPatterns(String extPattern) {
        List<String> extPatternList = new ArrayList<>();

        if (null == extPattern) {
            return extPatternList;
        }

        extPatternList = CommonUtil.stringToList(extPattern);

        return extPatternList;
    }

    /**
     * Get replacement patterns by Model
     * <p>
     * Fetching replacement patterns for generating template
     *
     * @param dmsb      DamascusBase instance
     * @param modelName
     * @return
     */
    private Map<String, String> getReplacementPatternByModel(DamascusBase dmsb, String modelName) {

        List<Application> applications = dmsb.getApplications();
        for (Application application : applications) {

            if (modelName.equals(application.getModel())) {
                return application.getReplacements();
            }
        }

        return new ConcurrentHashMap<>();
    }

    @Parameter(names = "-model", description = "Model to convert. -model (target model name, \"SampleSB\" e.g.) ", validateWith = ProjectNameValidator.class)
    private String model = "";

    @Parameter(names = "-pickup", description = "Only processing pickup flag is on. Default is false.")
    private boolean pickup = false;

    /**
     * Template files' root directory.
     * <p>
     * REQUIRED
     * The path must be end with '/'
     */
    @NonNull
    @Parameter(names = "-templatedir", description = "Template root directory. If this is not configured, the default directory will be used. Default is ${user_home}/.damascus")
    private String templateDirPath = DamascusProps.TEMPLATE_FILE_PATH;

    /**
     * Source files' root directory also where base.json exists.
     * <p>
     * REQUIRED
     * (this method will process directories under the root recursively)
     */
    @NonNull
    @Parameter(names = "-sourcerootdir", description = "The base directory where base.json exists. The default directory will be used if this value is not configured. Default is current directory.")
    private String sourceRootPath = DamascusProps.CURRENT_DIR;


    static private final String GEN_COMMAND_TEMPLATE = "template";
}
