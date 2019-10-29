package com.liferay.damascus.antlr.generator;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.liferay.damascus.cli.common.CaseUtil;
import com.liferay.damascus.cli.common.JsonUtil;
import com.liferay.damascus.cli.exception.DamascusProcessException;
import com.liferay.damascus.cli.json.Application;
import com.liferay.damascus.cli.json.DamascusBase;
import org.codehaus.plexus.util.StringUtils;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Replacement Generator
 *
 * @author Yasuyuki Takeo
 */
public class ReplacementGenerator {

    /**
     * Processing base.json
     * <p>
     * Adding replacement mapping list into each application model of json in base.json
     *
     * @param baseJsonPath
     * @return JSON String
     * @throws DamascusProcessException
     */
    static public String writeToString(File baseJsonPath) throws DamascusProcessException {

        try {
            DamascusBase dmsb = addReplacementToDamascusBase(baseJsonPath);

            return JsonUtil.writeValueAsString(dmsb);

        } catch (JsonProcessingException e) {
            throw new DamascusProcessException("Failed to writeToFile base.json <" + baseJsonPath.getAbsolutePath() + ">", e.getCause());

        } catch (IOException e) {
            throw new DamascusProcessException("Base.json doesn't exist in this path <" + baseJsonPath.getAbsolutePath() + ">", e.getCause());
        }
    }

    /**
     * Processing base.json
     * <p>
     * Adding replacement mapping list into each application model of json in base.json
     * and writing / overwriting base.json
     *
     * @param baseJsonPath   full path to base.json
     * @param outputJsonPath output directory path for base.json
     * @throws DamascusProcessException
     */
    static public DamascusBase writeToFile(File baseJsonPath, File outputJsonPath) throws DamascusProcessException {

        try {
            DamascusBase dmsb = addReplacementToDamascusBase(baseJsonPath);

            if (null == outputJsonPath) {
                outputJsonPath = baseJsonPath;
            }

            JsonUtil.writer(outputJsonPath.getPath(), dmsb);

            return dmsb;

        } catch (URISyntaxException e) {
            throw new DamascusProcessException("Failed to overrite base.json path <" + baseJsonPath.getAbsolutePath() + ">", e.getCause());

        } catch (IOException e) {
            throw new DamascusProcessException("Base.json doesn't exist in this path <" + baseJsonPath.getAbsolutePath() + ">", e.getCause());
        }
    }

    /**
     * Process DamasucsBase object
     * <p>
     * Adding replacement mapping to DamascusBase class object.
     *
     * @param baseJsonPath full path to base.json
     * @return DamascusBase object with replacement mappings.
     * @throws IOException
     */
    static public DamascusBase addReplacementToDamascusBase(File baseJsonPath) throws IOException {

        DamascusBase dmsb = JsonUtil.getObject(
            baseJsonPath.getAbsolutePath(),
            DamascusBase.class
        );

        List<Application> applications = dmsb.getApplications();

        dmsb.getApplications().replaceAll(
            application -> {
                if (null != application.getReplacements()) {
                    if (!application.getReplacements().isEmpty()) {
                        return application;
                    }
                }

                application.setReplacements(
                    initializeReplacement(dmsb, application)
                );
                return application;
            }
        );

        return dmsb;
    }

    /**
     * Initialize replacement based on valuable.ftl
     * <p>
     * This method returns replacement map for template generation.
     * The replace target strings are based on valuables in valuable.ftl.
     *
     * @param dmsb        DamascusBase object
     * @param application Application object
     * @return
     */
    static private LinkedHashMap<String, String> initializeReplacement(DamascusBase dmsb, Application application) {
        LinkedHashMap<String, String> replacement = new LinkedHashMap<>();

        // The order of replacements below is important.
        // When you add default replacements,
        // please confirm that the new mappings won't mess up
        // the replacements of target files.

        replacement.put(
            dmsb.getPackageName(),
            "${packageName}"
        );

        replacement.put(
            StringUtils.capitalizeFirstLetter(application.getModel()),
            "${capFirstModel}"
        );

        replacement.put(
            StringUtils.lowercaseFirstLetter(application.getModel()),
            "${uncapFirstModel}"
        );

        replacement.put(
            StringUtils.lowerCase(application.getModel()),
            "${lowercaseModel}"
        );

        replacement.put(
            StringUtils.upperCase(application.getModel()),
            "${uppercaseModel}"
        );

        replacement.put(
            CaseUtil.camelCaseToSnakeCase(application.getModel()),
            "${snakecaseModel}"
        );

        return replacement;
    }

}
