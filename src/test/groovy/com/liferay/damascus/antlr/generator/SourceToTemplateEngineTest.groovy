package com.liferay.damascus.antlr.generator

import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.test.tools.AntlrTestBase
import com.liferay.damascus.cli.test.tools.FileEnvUtils
import org.apache.commons.io.FileUtils
import spock.lang.Unroll

import java.nio.charset.StandardCharsets

class SourceToTemplateEngineTest extends AntlrTestBase {
    static def checkpattern = [
            'com.liferay.test': '${packageName}',
            'SampleSB'        : '${capFirstModel}',
            'sampleSB'        : '${uncapFirstModel}',
            'samplesb'        : '${lowercaseModel}',
            'SAMPLESB'        : '${uppercaseModel}',
            'sample-sb'       : '${snakecaseModel}'
    ]

    @Unroll("Smoke test of generator (No template exists pattern)")
    def "Smoke test of generator (No template exists pattern)"() {
        when:
        def targetName = "service.xml"
        def targetTemplateName = "Portlet_XXXXROOT_service.xml.ftl"

        FileEnvUtils.createXmlSource(SRC_DIR, targetName, targetTemplateName)
        File createdFile = new File(SRC_DIR + DamascusProps.DS + targetName)

        SourceToTemplateEngine.builder()
                .sourceRootPath(SRC_DIR)
                .templateDirPath(TMPLATE_DIR)
                .replacements(checkpattern)
                .build()
                .process()

        File createdTemplate = new File(TMPLATE_DIR + DamascusProps.DS + targetTemplateName)

        then:
        true == createdFile.exists()
        true == createdTemplate.exists()
    }

    @Unroll("Multiple test")
    def "Multiple test"() {
        when:
        //---------------------
        def targetName1 = "service.xml"
        def targetTemplateName1 = "Portlet_XXXXROOT_service.xml.ftl"

        FileEnvUtils.createXmlSource(SRC_DIR, targetName1, targetTemplateName1)
        File createdFile1 = new File(SRC_DIR + DamascusProps.DS + targetName1)

        FileEnvUtils.createXmlTemplate(TMPLATE_DIR, targetTemplateName1, targetTemplateName1)
        File createdTemplate1 = new File(TMPLATE_DIR + DamascusProps.DS + targetTemplateName1)

        //---------------------

        def targetName2 = "SampleSBLocalServiceImpl.java"
        def targetTemplateName2 = "Portlet_XXXXROOT_LocalServiceImpl.java.ftl"

        FileEnvUtils.createJavaSource(SRC_DIR, targetName2, targetTemplateName2)
        File createdFile2 = new File(SRC_DIR + DamascusProps.DS + targetName2)

        FileEnvUtils.createJavaTemplate(TMPLATE_DIR, targetTemplateName2, targetTemplateName2)
        File createdTemplate2 = new File(TMPLATE_DIR + DamascusProps.DS + targetTemplateName2)

        //---------------------

        def targetName3 = "test.properties"
        def targetTemplateName3 = "Portlet_XXXXROOT_test.properties.ftl"

        FileEnvUtils.createPropertiesSource(SRC_DIR, targetName3, targetTemplateName3)
        File createdFile3 = new File(SRC_DIR + DamascusProps.DS + targetName3)

        FileEnvUtils.createPropertiesTemplate(TMPLATE_DIR, targetTemplateName3, targetTemplateName3)
        File createdTemplate3 = new File(TMPLATE_DIR + DamascusProps.DS + targetTemplateName3)

        //---------------------

        SourceToTemplateEngine.builder()
                .sourceRootPath(SRC_DIR)
                .templateDirPath(TMPLATE_DIR + DamascusProps.DS)
                .replacements(checkpattern)
                .build()
                .process()

        //---------------------
        def processedContents1 = FileUtils.readFileToString(createdTemplate1, StandardCharsets.UTF_8);
        def replacedContents11 = '''<!-- <dmsc:sync id="foo1"> -->
    <!-- REPLACED BY FOO1 FIRST TAG -->
<!-- </dmsc:sync >'''
        def replacedContens12 = '''<!-- <dmsc:sync id="barfoo"> -->
        <!-- REPLACED BY BARFOO SECOND TAG -->
<!-- </dmsc:sync> -->'''

        //---------------------
        def processedContents21 = FileUtils.readFileToString(createdTemplate2, StandardCharsets.UTF_8);
        def replacedContents22 = '''/* <dmsc:sync id="bar123foo"> */
    <!-- REPLACED BY BAR123FOO FIRST TAG -->
/* </dmsc:sync> */'''
        def replacedContens2 = '''/* <dmsc:sync id="asdf"> */
        <!-- REPLACED BY ASDF SECOND TAG -->
/* </dmsc:sync> */'''

        //---------------------

        def processedContents3 = FileUtils.readFileToString(createdTemplate3, StandardCharsets.UTF_8);
        def replacedContents31 = '''# <dmsc:sync id="propstat1"><!-- REPLACED BY PROPSTAT1 FIRST TAG -->
# </dmsc:sync>'''
        def replacedContens32 = '''# <dmsc:sync id="propstat2"><!-- REPLACED BY PROPSTAT2 SECOND TAG -->
# </dmsc:sync>'''

        then:
        true == createdFile1.exists()
        true == createdTemplate1.exists()
        true == processedContents1.contains(replacedContents11)
        true == processedContents1.contains(replacedContens12)

        //---------------------

        true == createdFile2.exists()
        true == createdTemplate2.exists()
        true == processedContents21.contains(replacedContents22)
        true == processedContents21.contains(replacedContens2)

        //---------------------

        true == createdFile3.exists()
        true == createdTemplate3.exists()
        true == processedContents3.contains(replacedContents31)
        true == processedContents3.contains(replacedContens32)
    }

}