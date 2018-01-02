package com.liferay.damascus.antlr.common;

import com.liferay.damascus.antlr.template.DmscSrcParser;
import com.liferay.damascus.antlr.template.DmscSrcParserBaseListener;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * Common Listener class base
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class DmscSrcParserExListener extends DmscSrcParserBaseListener {

    /**
     * Strip Quotations
     *
     * @param str strings single / double quotations
     * @return stripped strings
     */
    protected String stripQuotations(String str) {
        String str1 = StringUtils.strip(str, "\"");
        return StringUtils.strip(str1, "'");
    }

    /**
     * Set errors
     *
     * @param errors
     */
    public void setErrors(List<String> errors) {
        for (String error : errors) {
            log.error(error);
        }
        errors.addAll(errors);
    }

    /**
     * Set a error
     *
     * @param error
     */
    public void setError(String error) {
        log.error(error);
        errors.add(error);
    }

    /**
     * Get AttributeContext
     * <p>
     * Fine AttributeContext from a key
     *
     * @param attributes target AttributeContext
     * @param key        Key string to search
     * @return AttributeContext object if it found or null
     */
    protected DmscSrcParser.AttributeContext getAttributeContext(
        List<DmscSrcParser.AttributeContext> attributes, String key) {

        return attributes.stream()
            .filter(atr -> atr.Name().getText().equals(key))
            .findFirst()
            .orElse(null);
    }

    /**
     * Get Attribute Context Value
     *
     * @param attributes
     * @param key
     * @return
     */
    protected String getAttributeValue(List<DmscSrcParser.AttributeContext> attributes, String key) {
        DmscSrcParser.AttributeContext attributeContext
            = getAttributeContext(attributes, key);

        if (null == attributeContext) {
            return "";
        }

        return stripQuotations(attributeContext.STRING().getText());
    }

    @Getter
    protected List<String> errors = new ArrayList<>();
}
