package com.liferay.damascus.antlr.generator;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Template Context
 *
 * @author Yasuyuki Takeo
 */
@ToString(includeFieldNames = false)
public class TemplateContextImpl implements TemplateContext {

    public TemplateContextImpl() {
        rootAttributes = new ConcurrentHashMap<>();
        syncAttributes = new ConcurrentHashMap<>();
        contentsIdMap = new ConcurrentHashMap<>();
        rootTagExist = false;
        pickup = false;
    }

    /**
     * Set Root Attribute
     *
     * @param key
     * @param value
     */
    public void setRootAttribute(String key, String value) {
        rootAttributes.put(key, value);
    }

    /**
     * Get Root Attribute
     *
     * @param key
     * @return
     */
    public String getRootAttribute(String key) {
        return rootAttributes.get(key);
    }

    /**
     * Set Sync Attribute
     *
     * @param key
     * @param value
     */
    public void setSyncAttribute(String key, String value) {
        syncAttributes.put(key, value);
    }

    /**
     * Get Attribute value
     *
     * @param key
     * @return Attribute value string
     */
    public String getSyncAttribute(String key) {
        return syncAttributes.get(key);
    }

    /**
     * Check Sync ID exist
     *
     * @param syncId
     * @return
     */
    public boolean isSyncIdExist(String syncId) {
        return syncAttributes.containsKey(syncId);
    }

    @Getter
    protected Map<String, String> rootAttributes;

    @Getter
    protected Map<String, String> syncAttributes;

    @Getter
    @Setter
    protected Map<String, String> contentsIdMap;

    @Getter
    @Setter
    protected boolean rootTagExist;

    @Getter
    @Setter
    protected boolean pickup;

}
