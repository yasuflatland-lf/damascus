package com.liferay.damascus.cli.common;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.FileBasedConfiguration;
import org.apache.commons.configuration2.PropertiesConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.builder.fluent.Parameters;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.tuple.Pair;

import com.beust.jcommander.internal.Lists;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/**
 * Property file utility
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class PropertyUtil {
    /**
     * Constructor
     */
    protected PropertyUtil() {

    }

    /**
     * Get Instance
     *
     * @return this instance
     */
    static public PropertyUtil getInstance() {

        return SingletonHolder.INSTANCE;
    }

    /**
     * Singleton Holder
     */
    static private class SingletonHolder {
        private static final PropertyUtil INSTANCE = new PropertyUtil().initialize();
    }

    /**
     * Initializer
     * <p>
     * If property file has not been created, create a property file with default values.
     *
     * @return <code>PropertyUtil</code> instance
     */
    private PropertyUtil initialize() {
        synchronized (this) {
            try {
                File propertiesFile = new File(getPropertyFilePath());

                if (!propertiesFile.exists()) {
                    //If property file doesn't exist, initialize the base file.
                    initializeProperties(propertiesFile, getInitializePropertyLists());
                }

                load(propertiesFile);

            } catch (IOException e) {
                log.error(e.getMessage());
            }
        }
        return this;
    }

    /**
     * Property file path
     *
     * @return property file path
     */
    static private String getPropertyFilePath() {
        return DamascusProps.PROPERTY_FILE_PATH;
    }

    /**
     * Load property
     *
     * @param propertiesFile File path to the property file
     * @throws IOException if property file couldn't be created.
     */
    private void load(File propertiesFile) throws IOException {
        Parameters params = new Parameters();

        setBuilder(new FileBasedConfigurationBuilder<FileBasedConfiguration>(PropertiesConfiguration.class)
            .configure(params.fileBased()
                .setFile(propertiesFile)));
        try {
            setConfig(getBuilder().getConfiguration());

        } catch (ConfigurationException cex) {
            // loading of the configuration file failed
            log.error(cex.getMessage());
        }
    }

    /**
     * Initialize Properties
     *
     * @return property list
     */
    private List<Pair> getInitializePropertyLists() {
        return Lists.newArrayList(
            //User name for author in Javadoc
            Pair.of(DamascusProps.PROP_AUTHOR, DamascusProps.USER_NAME),
            Pair.of(DamascusProps.PROP_RESOURCE_ROOT_PATH, "")
        );
    }

    /**
     * Initialize property file
     *
     * @param propertiesFile File path to the property file
     * @param initProps
     * @throws IOException if property file couldn't be created.
     */
    private void initializeProperties(File propertiesFile, List<Pair> initProps) throws IOException {

        //Convert tuples into properties.
        //This method might be called before FileBasedConfigurationBuilder is initialized,
        //so generate properties without relying on that.
        String strProps =
            initProps.stream()
                .map(p -> String.format("%s=%s", p.getKey(), p.getValue()))
                .collect(Collectors.joining(DamascusProps.EOL));

        FileUtils.writeStringToFile(propertiesFile, strProps.toString(), DamascusProps.FILE_ENCODING);
    }

    /**
     * Get Property
     *
     * @param key Property key
     * @return property if it exist. Null if no property found
     */
    public String getProperty(String key) {

        return (String) (getConfig().getProperty(key));
    }

    /**
     * Set Property
     * <p>
     * After setting properties, you need to call {@link #save() save} to store property persistently.
     *
     * @param key   property key
     * @param value property value
     * @return this
     */
    public PropertyUtil setProperty(String key, String value) {
        getConfig().setProperty(key, value);
        return this;
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

    @Setter(AccessLevel.PRIVATE)
    @Getter(AccessLevel.PRIVATE)
    static private Configuration config = null;

    @Setter(AccessLevel.PRIVATE)
    @Getter(AccessLevel.PRIVATE)
    static private FileBasedConfigurationBuilder<FileBasedConfiguration> builder = null;

}
