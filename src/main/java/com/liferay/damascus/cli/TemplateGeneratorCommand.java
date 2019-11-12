package com.liferay.damascus.cli;

import com.liferay.damascus.antlr.generator.ReplacementGenerator;
import com.liferay.damascus.antlr.generator.SourceToTemplateEngine;
import com.liferay.damascus.cli.common.CommonUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.common.PropertyContext;
import com.liferay.damascus.cli.common.PropertyContextFactory;
import com.liferay.damascus.cli.exception.DamascusProcessException;
import com.liferay.damascus.cli.json.Application;
import com.liferay.damascus.cli.json.DamascusBase;
import lombok.extern.slf4j.Slf4j;

import java.io.File;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Template Generator command
 * <p>
 * Tools for generating template files for scaffolding
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class TemplateGeneratorCommand extends BaseCommand<TemplateGeneratorArgs> {
    public TemplateGeneratorCommand() {
    }

    public TemplateGeneratorCommand(Damascus damascus) {
        super(damascus, null);
    }

    @Override
    public void execute() throws Exception {
        System.out.println("Generating templates...");

        TemplateGeneratorArgs args = getArgs();

        // Template path
        String processedTemplateDir = CommonUtil.normalizePath(args.getTemplateDirPath());

        if (null == processedTemplateDir) {
            System.out.println("Template file path is invalid. <" + args.getTemplateDirPath() + ">");
            return;
        }

        // Source root directory / base.json path
        String processedSourceRootPath = CommonUtil.normalizePath(args.getSourceRootPath());

        if (null == processedSourceRootPath) {
            System.out.println("Base json directory path is invalid. <" + args.getSourceRootPath() + ">");
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

            PropertyContext propertyContext = PropertyContextFactory.createPropertyContext();
            String checkPattern = propertyContext.getString(DamascusProps.PROP_EXT_WHITE_LIST);
            List<String> extensionPatterns = getWhiteExtentionPatterns(checkPattern);
            LinkedHashMap<String, String> replacementPattern = getReplacementPatternByModel(dmsb, args.getModel());

            if (replacementPattern.isEmpty()) {
                System.out.println("Model name has not been found. Model name <" + args.getModel() + ">");
                return;
            }

            SourceToTemplateEngine
                .builder()
                .sourceRootPath(
                    processedSourceRootPath
                )
                .templateDirPath(
                    processedTemplateDir
                )
                .replacements(
                    replacementPattern
                )
                .extentionPatterns(
                    extensionPatterns
                )
                .insertPathTag (
                    args.getInsertPathTag()
                )
                .build()
                .process();

        } catch (DamascusProcessException e) {
            System.out.println(e.getMessage());

        }

        System.out.println("Done.");
    }

    @Override
    public Class<TemplateGeneratorArgs> getArgsClass() {
        return TemplateGeneratorArgs.class;
    }


    /**
     * Get White Extension Patterns
     *
     * @param extPattern White extension pattern strings
     * @return Extension pattern List
     */
    protected List<String> getWhiteExtentionPatterns(String extPattern) {
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
    protected LinkedHashMap<String, String> getReplacementPatternByModel(DamascusBase dmsb, String modelName) {

        List<Application> applications = dmsb.getApplications();
        for (Application application : applications) {

            if (modelName.equals(application.getModel())) {
                return application.getReplacements();
            }
        }

        return new LinkedHashMap<>();
    }

}
