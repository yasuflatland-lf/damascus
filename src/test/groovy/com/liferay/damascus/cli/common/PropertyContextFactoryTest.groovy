package com.liferay.damascus.cli.common

import com.google.common.collect.Lists
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.configuration2.Configuration
import org.apache.commons.configuration2.FileBasedConfiguration
import org.apache.commons.configuration2.PropertiesConfiguration
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder
import org.apache.commons.configuration2.builder.fluent.Parameters
import org.apache.commons.configuration2.ex.ConfigurationException
import org.apache.commons.io.FileUtils
import org.apache.commons.lang3.tuple.Pair
import org.junit.Test
import org.junit.runner.RunWith
import org.powermock.api.mockito.PowerMockito
import org.powermock.core.classloader.annotations.PrepareForTest
import org.powermock.modules.junit4.PowerMockRunner
import spock.lang.Specification
import spock.lang.Unroll
import org.mockito.Mockito;

@RunWith(PowerMockRunner.class)
@PrepareForTest(PropertyContextFactory.class)
class PropertyContextFactoryTest extends Specification {
    static def DS = DamascusProps.DS;
    static def workTempDir = TestUtils.getTempPath() + "damascustest";
    static def tempPropFile = "test.property";
    static public String PROP_FILE_PATH = workTempDir + tempPropFile;

    /**
     * Create dummy properties file
     *
     * @param path
     * @param properties
     * @return
     */
    def createProperties(path, List<Pair> properties) {
        Parameters params = new Parameters();

        File propertiesFile = new File(path);
        FileUtils.writeStringToFile(propertiesFile, "test", "utf-8")

        FileBasedConfigurationBuilder<FileBasedConfiguration> builder =
                new FileBasedConfigurationBuilder<FileBasedConfiguration>(PropertiesConfiguration.class)
                        .configure(params.fileBased()
                        .setFile(propertiesFile));
        try {
            Configuration config = builder.getConfiguration();
            // config contains all properties read from the file
            for (def prop : properties) {
                config.setProperty((String) prop.getKey(), (String) prop.getValue())
            }
            builder.save();
        }
        catch (ConfigurationException cex) {
            // loading of the configuration file failed
            cex.printStackTrace();
        }
    }

    //With PowerMockito, it doesn't accept parameters from "where:", so this is kind of workaround
    //Also, Singleton is initialized only once. If you want to have multiple tests, need to test all at one place,
    //within def setupSpec() (@BeforeClass for JUnit) and verify at each features.
    @Unroll("Property write Success test")
    @Test
    def "Property write Success test"() {
        when:
        List<Pair> params = Lists.newArrayList();
        String key1 = DamascusProps.PROP_AUTHOR;
        String val1 = "John Doe";
        String key2 = "foo.bar";
        String val2 = "some parameter";

        params.add(Pair.of(key1, val1));
        params.add(Pair.of(key2, val2));

        //Create a test property file
        createProperties(PROP_FILE_PATH, params);

        PowerMockito.spy(PropertyContextFactory.class);
        PowerMockito.doReturn(PROP_FILE_PATH).when(PropertyContextFactory.class, "getPropertyFilePath");
        PropertyContext pc = PropertyContextFactory.createPropertyContext();

        def result1 = pc.getString(key1)
        def result2 = pc.getString(key2)
        def result3 = pc.getString("doesnt.exist.key")

        then:
        true != result1.isEmpty()
        null == result2

//        true == result1.equals(val1)
//        true == result2.equals(val2)
        null == result3
    }
}
