package com.liferay.damascus.cli.common;

import lombok.Data;
import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.FileBasedConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.ex.ConfigurationException;

@Data
public class PropertyContext {

    /**
     * Get String property
     *
     * @param key PropertyContext key
     * @return property if it exist. Null if no property found
     */
    public String getString(String key) {

        return getConfig().getString(key);
    }

    /**
     * Set PropertyContext
     * <p>
     * After setting properties, you need to call {@link #save() save} to store property persistently.
     *
     * @param key   property key
     * @param value property value
     */
    public void setProperty(String key, String value) {
        getConfig().setProperty(key, value);
    }

    /**
     * Save property to persistent
     * <p>
     * This method need to be called to store properties persistently.
     *
     * @throws ConfigurationException Error at saving properties.
     */
    public void save() throws ConfigurationException {
        getBuilder().save();
    }

    protected Configuration config;

    protected FileBasedConfigurationBuilder<FileBasedConfiguration> builder;

}
