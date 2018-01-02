package com.liferay.damascus.antlr.common;

import com.liferay.damascus.antlr.generator.TemplateContext;
import com.liferay.damascus.antlr.generator.TemplateContextImpl;
import com.liferay.damascus.cli.common.DamascusProps;
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
        if (!rootAttributes.containsKey(DamascusProps.ATTR_TEMPLATE_NAME)) {
            errors.add(DamascusProps.ATTR_TEMPLATE_NAME + " is missing");
        } else {
            String templateName = rootAttributes.get(DamascusProps.ATTR_TEMPLATE_NAME);

            if (templateName.equals("")) {
                errors.add(DamascusProps.ATTR_TEMPLATE_NAME + " is empty. must be configured");
            }
        }

        return errors;
    }

    /**
     * Sync Attributes validator
     *
     * @param sourceContext
     * @return String List if there are errors. Empty List if it's valid
     */
    static public List<String> syncValidator(TemplateContextImpl sourceContext) {

        Map<String, String> syncAttributes = sourceContext.getSyncAttributes();
        List<String>        errors         = new ArrayList<>();

        if (!syncAttributes.containsKey(DamascusProps.ATTR_ID)) {
            errors.add(DamascusProps.ATTR_ID + " is missing");
        } else {
            String attrId = syncAttributes.get(DamascusProps.ATTR_ID);

            if (attrId.equals("")) {
                errors.add(DamascusProps.ATTR_ID + " is empty. must be configured");
            }
        }

        return errors;
    }
}