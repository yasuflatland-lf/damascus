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

    protected final ByteArrayOutputStream outContent = new ByteArrayOutputStream();
    protected final ByteArrayOutputStream errContent = new ByteArrayOutputStream();

    def setup() {
        System.setOut(new PrintStream(outContent));
        System.setErr(new PrintStream(errContent));
        Spy(Damascus)
        FileUtils.deleteDirectory(new File(workTempDir));
        def templateUtil = Spy(TemplateUtil)
        templateUtil.clear();
        TestUtils.setFinalStatic(DamascusProps.class.getDeclaredField("CURRENT_DIR"), workTempDir + DS);
    }

    def cleanup() {
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out)));
        System.setErr(new PrintStream(new FileOutputStream(FileDescriptor.err)));
    }

    //TODO: Write inititialize parameter combination error validation

    @Unroll
    def "Smoke test for Init Command Success Pattern"() {
        when:
        String[] args = garvs
        Damascus dmsc = Spy(Damascus);
        dmsc.run(args);
        InitArgs cargs = dmsc.getCommand().getArgs();

        then:
        result.equals(cargs.getProjectName())

        where:
        garvs                                                                               | result
        ["init", "-c", "Foo", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]     | "Foo"
        ["init", "-c", "Bar", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]     | "Bar"
        ["init", "-c", "Foo", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_71]     | "Foo"
        ["init", "-c", "Bar", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_71]     | "Bar"
        ["init", "-c", "BarFoo", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_71]  | "BarFoo"
        ["init", "-c", "Bar-Foo", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_71] | "Bar-Foo"
    }

    @Unroll
    def "Smoke test for Init Command Error Pattern"() {
        when:
        String[] args = garvs
        Damascus dmsc = Spy(Damascus);
        dmsc.run(args);

        then:
        errContent.toString().contains("Parameter -c should only use alphabetic")

        where:
        garvs                                                                               | _
        ["init", "-c", "foo@", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
        ["init", "-c", "foo^", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
        ["init", "-c", "^foo", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
        ["init", "-c", "foo%", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
        ["init", "-c", "fooあ", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
        ["init", "-c", "foo_Bar", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72] | _
        ["init", "-c", "_Bar", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
        ["init", "-c", "Bar_", "-p", "com.liferay.test", "-v", DamascusProps.VERSION_72]    | _
    }

    @Unroll
    def "Package name test for Error Pattern"() {
        when:
        String[] args = garvs
        Damascus dmsc = Spy(Damascus);
        dmsc.run(args);

        then:
        errContent.toString().contains("Parameter -p should be appropriate package name")

        where:
        garvs                                                                  | _
        ["init", "-c", "Foo", "-p", "999.aaa", "-v", DamascusProps.VERSION_72] | _
        ["init", "-c", "Foo", "-p", "9.aaa", "-v", DamascusProps.VERSION_72]   | _
        ["init", "-c", "Foo", "-p", "aaa.9aa", "-v", DamascusProps.VERSION_72] | _
        ["init", "-c", "Foo", "-p", "999.aaa", "-v", DamascusProps.VERSION_72] | _
        ["init", "-c", "Foo", "-p", "9.aaa", "-v", DamascusProps.VERSION_72]   | _
        ["init", "-c", "Foo", "-p", "aaa.9aa", "-v", DamascusProps.VERSION_72] | _

    }

    @Unroll("Init run from main method test")
    def "Init run from main method test"() {
        when:
        String[] args = garvs
        Damascus.main(args);
        def f = new File(workTempDir + DS + expectedProjectDirName + DS + DamascusProps.BASE_JSON)

        then:
        f.exists()
        //Other detailed test to confirm if the json is parsed correctly has been done in JsonUtilTest

        where:
        garvs                                                                       | expectedProjectDirName
        ["init", "-c", "ToDo", "-p", "com.liferay", "-v", DamascusProps.VERSION_70] | "to-do"
        ["init", "-c", "ToDo", "-p", "com.liferay", "-v", DamascusProps.VERSION_71] | "to-do"
        ["init", "-c", "ToDo", "-p", "com.liferay", "-v", DamascusProps.VERSION_72] | "to-do"
    }
}
