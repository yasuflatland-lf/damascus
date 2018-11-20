package com.liferay.damascus.antlr.generator

import com.beust.jcommander.JCommander
import com.liferay.damascus.cli.Damascus
import com.liferay.damascus.cli.InitCommand
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.common.JsonUtil
import com.liferay.damascus.cli.common.TemplateUtil
import com.liferay.damascus.cli.json.Application
import com.liferay.damascus.cli.json.DamascusBase
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import spock.lang.Specification
import spock.lang.Unroll

class ReplacementGeneratorTest extends Specification {
    def DS = DamascusProps.DS;
    def workTempDir = TestUtils.getTempPath() + "ReplacementGeneratorTest";
    def initCommand;
    static def checkpattern = [
            '${packageName}',
            '${capFirstModel}',
            '${uncapFirstModel}',
            '${lowercaseModel}',
            '${uppercaseModel}',
            '${snakecaseModel}'
    ]

    def setup() {
        Spy(Damascus)
        FileUtils.deleteDirectory(new File(workTempDir));
        TemplateUtil.getInstance().clear();
        TestUtils.setFinalStatic(DamascusProps.class.getDeclaredField("CURRENT_DIR"), workTempDir + DS);

        initCommand = Spy(InitCommand)
    }

    @Unroll("ReplacementGenerator smoke test")
    def "ReplacementGenerator smoke test"() {
        when:
        String[] args = [argv1, argv2, argv3, argv4]
        new JCommander(initCommand, args)
        def dms = Spy(Damascus)
        dms.setLiferayVersion(argv6)
        initCommand.run(dms, args)

        def tmpBaseJsonDir = workTempDir + DS + expectedProjectDirName + DS + DamascusProps.BASE_JSON
        def f = new File(tmpBaseJsonDir)

        DamascusBase dmsb =
                JsonUtil.getObject(
                        tmpBaseJsonDir,
                        DamascusBase.class
                );

        List<Application> applications = dmsb.getApplications();

        def result = ReplacementGenerator.initializeReplacement(dmsb, applications.get(0))

        then:
        f.exists()
        !result.isEmpty()
        def cnt = 0
        result.each { k, v ->
            // Check order of replacements. need to be certain order
            assert v == checkpattern[cnt].toString()
            cnt++
        }

        where:
        argv1   | argv2  | argv3 | argv4              | argv5 | argv6                    | expectedProjectDirName
        "-init" | "ToDo" | "-p"  | "com.liferay.test" | "-v"  | DamascusProps.VERSION_70 | "to-do"

    }

    @Unroll("ReplacementGenerator do not override test")
    def "ReplacementGenerator do not override test"() {
        when:
        String[] args = [argv1, argv2, argv3, argv4]
        new JCommander(initCommand, args)
        def dms = Spy(Damascus)
        dms.setLiferayVersion(argv6)
        initCommand.run(dms, args)

        def tmpBaseJsonDir = workTempDir + DS + expectedProjectDirName + DS + DamascusProps.BASE_JSON
        def f = new File(tmpBaseJsonDir)


        DamascusBase dmsb =
                JsonUtil.getObject(
                        tmpBaseJsonDir,
                        DamascusBase.class
                );

        // Adding dummy
        Map<String, String> dummyReplacement = new LinkedHashMap<>();
        dummyReplacement.put("dummy", "foo")
        dmsb.applications.get(0).setReplacements(dummyReplacement)

        JsonUtil.writer(tmpBaseJsonDir, dmsb)
        def result = ReplacementGenerator.writeToString(f)

        then:
        f.exists()
        !result.isEmpty()

        def cnt = 0
        checkpattern.each { v ->
            assert !result.contains(v)
        }

        where:
        argv1   | argv2  | argv3 | argv4              | argv5 | argv6                    | expectedProjectDirName
        "-init" | "ToDo" | "-p"  | "com.liferay.test" | "-v"  | DamascusProps.VERSION_70 | "to-do"

    }

    @Unroll("writeToString smoke test")
    def "writeToString smoke test"() {
        when:
        String[] args = [argv1, argv2, argv3, argv4]
        new JCommander(initCommand, args)
        def dms = Spy(Damascus)
        dms.setLiferayVersion(argv6)
        initCommand.run(dms, args)

        def tmpBaseJsonDir = workTempDir + DS + expectedProjectDirName + DS + DamascusProps.BASE_JSON
        def f = new File(tmpBaseJsonDir)

        def result = ReplacementGenerator.writeToString(new File(tmpBaseJsonDir));

        then:
        f.exists()
        !result.isEmpty()
        checkpattern.each { v ->
            assert result.contains(v)
        }

        where:
        argv1   | argv2  | argv3 | argv4              | argv5 | argv6                    | expectedProjectDirName
        "-init" | "ToDo" | "-p"  | "com.liferay.test" | "-v"  | DamascusProps.VERSION_70 | "to-do"

    }
}