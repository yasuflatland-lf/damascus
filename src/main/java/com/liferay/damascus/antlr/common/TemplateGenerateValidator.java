package com.liferay.damascus.antlr.common;

import com.liferay.damascus.antlr.generator.TemplateContext;
import org.apache.commons.io.FilenameUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Template Generator Validator class
 *
 * @author Yasuyuki Takeo
 */
public class TemplateGenerateValidator {

    /**
     * Root Attributes validator
     *
     * @param sourceContext
     * @return String List if there are errors. Empty List if it's valid
     */
    static public List<String> rootValidator(TemplateContext sourceContext) {

        Map<String, String> rootAttributes = sourceContext.getRootAttributes();
        List<String>        errors         = new ArrayList<String>();

        // Template Name is required
        if (!rootAttributes.containsKey(TemplateContext.ATTR_TEMPLATE_NAME)) {
            errors.add(TemplateContext.ATTR_TEMPLATE_NAME + " is missing");
        } else {
            String templateName = rootAttributes.get(TemplateContext.ATTR_TEMPLATE_NAME);

            if (templateName.equals("")) {
                errors.add(TemplateContext.ATTR_TEMPLATE_NAME + " is empty. must be configured");
            }
        }

        return errors;
    }

    /**
     * Template file path validator
     *
     * @param templateFilePath
     * @return Empty string when it's true or error message.
     */
    static public String templateFilePathValidator(String templateFilePath) {

        String error = "";

        if (null == FilenameUtils.normalize(templateFilePath)) {
            error = "Template file path is invalid. <" + templateFilePath + ">";
        }

        return error;
    }

    /**
     * Sync Attributes validator
     *
     * @param sourceContext
     * @return String List if there are errors. Empty List if it's valid
     */
    static public List<String> syncValidator(TemplateContext sourceContext) {

        Map<String, String> syncAttributes = sourceContext.getSyncAttributes();
        List<String>        errors         = new ArrayList<>();

        if (!syncAttributes.containsKey(TemplateContext.ATTR_ID)) {
            errors.add(TemplateContext.ATTR_ID + " is missing");
        } else {
            String attrId = syncAttributes.get(TemplateContext.ATTR_ID);

            if (attrId.equals("")) {
                errors.add(TemplateContext.ATTR_ID + " is empty. must be configured");
            }
        }

        return errors;
    }
}