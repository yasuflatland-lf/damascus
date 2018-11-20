package com.liferay.damascus.cli

import com.beust.jcommander.JCommander
import com.beust.jcommander.ParameterException
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.common.TemplateUtil
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import spock.lang.Specification
import spock.lang.Unroll

class InitCommandTest extends Specification {
    def DS = DamascusProps.DS;
    def workTempDir = TestUtils.getTempPath() + "damascustest";
    def initCommand;

    def setup() {
        Spy(Damascus)
        FileUtils.deleteDirectory(new File(workTempDir));
        TemplateUtil.getInstance().clear();
        TestUtils.setFinalStatic(DamascusProps.class.getDeclaredField("CURRENT_DIR"), workTempDir + DS);

        initCommand = Spy(InitCommand)
    }

    //TODO: Write inititialize parameter combination error vailidation

    @Unroll("Smoke test for -init Success Pattern(#argv1 #argv2)")
    def "Smoke test for Init Command Success Pattern"() {
        when:
        String[] args = [argv1, argv2]
        new JCommander(initCommand, args);

        then:
        result == initCommand.getProjectName()

        where:
        argv1   | argv2     | result
        "-init" | "Foo"     | "Foo"
        "-init" | "Bar"     | "Bar"
        "-init" | "BarFoo"  | "BarFoo"
        "-init" | "Bar-Foo" | "Bar-Foo"
    }

    @Unroll("Smoke test for -init Error Pattern(#argv1 #argv2)")
    def "Smoke test for Init Command Error Pattern"() {
        when:
        String[] args = [argv1, argv2]
        new JCommander(initCommand, args)

        then:
        thrown(ParameterException.class)

        where:
        argv1   | argv2
        "-init" | "foo@"
        "-init" | "foo^"
        "-init" | "^foo"
        "-init" | "foo%"
        "-init" | "fooあ"
        "-init" | "foo_Bar"
        "-init" | "_Bar"
        "-init" | "Bar_"
    }

    @Unroll("Smoke test for -p Success Pattern(#argv1 #argv2)")
    def "Package name test for Success Pattern"() {
        when:
        String[] args = [argv1, argv2]
        new JCommander(initCommand, args)

        then:
        null != initCommand.getPackageName()

        where:
        argv1 | argv2
        "-p"  | "com.liferay"
        "-p"  | "com.liferay.damascus.cli"
        "-p"  | "com.a"
        "-p"  | "com"
    }

    @Unroll("Smoke test for -init Error Pattern(#argv1 #argv2)")
    def "Package name test for Error Pattern"() {
        when:
        String[] args = [argv1, argv2]
        new JCommander(initCommand, args)

        then:
        thrown(ParameterException.class)

        where:
        argv1 | argv2
        "-p"  | "999.aaa"
        "-p"  | "9.aaa"
        "-p"  | "aaa.9aa"
    }

    @Unroll("Init run from main method test")
    def "Init run from main method test"() {
        when:
        String[] args = [argv1, argv2, argv3, argv4]
        new JCommander(initCommand, args)
        def dms = Spy(Damascus)
        dms.setLiferayVersion(argv6)
        initCommand.run(dms, args)
        def f = new File(workTempDir + DS + expectedProjectDirName + DS + DamascusProps.BASE_JSON)

        then:
        f.exists()
        //Other detailed test to confirm if the json is parsed correctly has been done in JsonUtilTest

        where:
        argv1   | argv2  | argv3 | argv4         | argv5 | argv6                    | expectedProjectDirName
        "-init" | "ToDo" | "-p"  | "com.liferay" | "-v"  | DamascusProps.VERSION_70 | "to-do"
    }
}
