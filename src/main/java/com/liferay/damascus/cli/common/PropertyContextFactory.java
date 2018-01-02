package com.liferay.damascus.cli.common;

import com.beust.jcommander.internal.Lists;
import com.liferay.damascus.antlr.generator.SourceToTemplateEngine;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.configuration2.FileBasedConfiguration;
import org.apache.commons.configuration2.PropertiesConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.builder.fluent.Parameters;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.tuple.Pair;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * PropertyContext factory
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public final class PropertyContextFactory {

    /**
     * Create PropertyContext object
     *
     * @return Configuration of settings.properties under .damascus directory
     * @throws IOException
     * @throws ConfigurationException
     */
    static public PropertyContext createPropertyContext()
        throws IOException, ConfigurationException {

        Parameters params         = new Parameters();
        File       propertiesFile = new File(getPropertyFilePath());

        if (!propertiesFile.exists()) {

            if(log.isDebugEnabled()) {
                log.debug("PropertyContext file did not exist");
            }

            //If propertyContext file doesn't exist, initialize the base file.
            initializeProperties(
                propertiesFile,
                getInitializePropertyLists()
            );
        }

        FileBasedConfigurationBuilder<FileBasedConfiguration> builder =
            new FileBasedConfigurationBuilder<FileBasedConfiguration>(PropertiesConfiguration.class)
                .configure(params.fileBased()
                    .setFile(propertiesFile));

        PropertyContext propertyContext = new PropertyContext();
        propertyContext.setBuilder(builder);
        propertyContext.setConfig(builder.getConfiguration());

        return propertyContext;
    }

    /**
     * PropertyContext file path
     *
     * @return property file path
     */
    static protected String getPropertyFilePath() {

        return DamascusProps.PROPERTY_FILE_PATH;
    }

    /**
     * Initialize Properties
     *
     * @return property list
     */
    static protected List<Pair> getInitializePropertyLists() {
        return Lists.newArrayList(
            //User name for author in Javadoc
            Pair.of(DamascusProps.PROP_AUTHOR, DamascusProps.USER_NAME),
            Pair.of(DamascusProps.PROP_RESOURCE_ROOT_PATH, ""),
            Pair.of(DamascusProps.PROP_BUILD_NUMBER, ""),
            Pair.of(DamascusProps.PROP_EXT_WHITE_LIST, String.join(",", SourceToTemplateEngine.EXT_WHITE_LIST))
        );
    }

    /**
     * Initialize property file
     *
     * @param propertiesFile File path to the property file
     * @param initProps      Initialize Properties
     * @throws IOException if property file couldn't be created.
     */
    static protected void initializeProperties(File propertiesFile, List<Pair> initProps) throws IOException {

        //Convert tuples into properties.
        String strProps =
            initProps.stream()
                .map(p -> String.format("%s=%s", p.getKey(), p.getValue()))
                .collect(Collectors.joining(DamascusProps.EOL));

        FileUtils.writeStringToFile(propertiesFile, strProps.toString(), DamascusProps.FILE_ENCODING);
    }

}
