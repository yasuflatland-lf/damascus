package com.liferay.damascus.cli

import com.beust.jcommander.JCommander
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.common.TemplateUtil
import com.liferay.damascus.cli.test.tools.AntlrTestBase
import com.liferay.damascus.cli.test.tools.FileEnvUtils
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import spock.lang.Specification
import spock.lang.Unroll

import java.nio.charset.StandardCharsets

class TemplateGeneratorCommandTest extends AntlrTestBase {
    def initCommand;

    def setup() {
        FileUtils.deleteDirectory(new File(SRC_DIR));
        TemplateUtil.getInstance().clear();
        TestUtils.setFinalStatic(DamascusProps.class.getDeclaredField("CURRENT_DIR"), SRC_DIR + DS);

        initCommand = Spy(InitCommand)
    }

    @Unroll("TemplateGeneratorCommand smoke test")
    def "TemplateGeneratorCommand smoke test"() {
        when:
        //
        //Generate base.json
        //

        String[] initArgs = ["-init", "SampleSB", "-p", "com.liferay.test"]
        new JCommander(initCommand, initArgs)
        def dms = Spy(Damascus)
        dms.setLiferayVersion(DamascusProps.VERSION_70)
        initCommand.run(dms, initArgs)

        def SRC_PROJECT_DIR = SRC_DIR + DS + 'sample-sb' + DS

        //
        // Generate file / directory hierarchy
        //
        final FileTreeBuilder tf = new FileTreeBuilder(new File(SRC_DIR))
        tf.dir('sample-sb') {
            dir('Bar') {
                file('FooTest.java') {
                    withWriter('UTF-8') { writer ->
                        writer.write 'test'
                    }
                }
                file('Bar-service.java') {
                    withWriter('UTF-8') { writer ->
                        writer.write 'test'
                    }
                }
                file('Bar-api.java') {
                    withWriter('UTF-8') { writer ->
                        writer.write 'test'
                    }
                }
            }
            dir('dir3') {
                file('DarTest-service.java') {
                    withWriter('UTF-8') { writer ->
                        writer.write 'test'
                    }
                }
            }
        }

        //
        // Generate convert target files
        //

        def targetName2 = "SampleSBLocalServiceImpl.java"
        def targetTemplateName2 = "Portlet_XXXXROOT_LocalServiceImpl.java.ftl"
        def targetSrcDir = SRC_PROJECT_DIR + 'dir1' + DS + 'dir4' + DS + 'fuga' + DS
        def targetTemplateDir = TMPLATE_DIR + DS + 'Foo'

        FileEnvUtils.createJavaSource(targetSrcDir, targetName2, targetTemplateName2)
        File createdFile2 = new File(targetSrcDir + DS + targetName2)

        FileEnvUtils.createJavaTemplate(targetTemplateDir, targetTemplateName2, targetTemplateName2)
        File createdTemplate2 = new File(targetTemplateDir + DS + targetTemplateName2)

        String[] genArgs = ["-generate", "template", "-model", "SampleSB", "-sourcerootdir", SRC_PROJECT_DIR, "-templatedir", targetTemplateDir]
        Damascus.main(genArgs)

        def error_output = errContent.toString();

        then:
        createdFile2.exists()
        createdTemplate2.exists()
        error_output.isEmpty()
    }

    @Unroll("TemplateGeneratorCommand pickup erased test")
    def "TemplateGeneratorCommand pickup erased test"() {
        when:
        //
        //Generate base.json
        //

        String[] initArgs = ["-init", "SampleSB", "-p", "com.liferay.test"]
        new JCommander(initCommand, initArgs)
        def dms = Spy(Damascus)
        dms.setLiferayVersion(DamascusProps.VERSION_70)
        initCommand.run(dms, initArgs)

        def SRC_PROJECT_DIR = SRC_DIR + DS + 'sample-sb' + DS

        //
        // Generate convert target files
        //

        def targetName2 = "SampleSBLocalServiceImpl.java"
        def targetTemplateName2 = "Portlet_XXXXROOT_LocalServiceImpl.java.ftl"
        def targetSrcDir = SRC_PROJECT_DIR + 'dir1' + DS + 'dir4' + DS + 'fuga' + DS
        def targetTemplateDir = TMPLATE_DIR + DS

        FileEnvUtils.createJavaSource(targetSrcDir, targetName2, targetTemplateName2)
        File createdFile2 = new File(targetSrcDir + DS + targetName2)


        String[] genArgs = ["-generate", "template", "-model", "SampleSB", "-v", "Foo", "-sourcerootdir", SRC_PROJECT_DIR, "-templatedir", targetTemplateDir]
        Damascus.main(genArgs)

        File createdTemplate2 = new File(targetTemplateDir + DS + "Foo" + DS + targetTemplateName2)
        def output_contents = FileUtils.readFileToString(createdTemplate2,StandardCharsets.UTF_8)
        def error_output = errContent.toString();

        then:
        createdFile2.exists()
        createdTemplate2.exists()
        !output_contents.contains("pickup=")
        error_output.isEmpty()
    }
}