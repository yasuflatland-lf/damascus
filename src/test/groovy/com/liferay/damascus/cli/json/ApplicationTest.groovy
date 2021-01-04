package com.liferay.damascus.cli.json

import com.beust.jcommander.ParameterException
import com.beust.jcommander.internal.Lists
import com.liferay.damascus.cli.CreateCommand
import com.liferay.damascus.cli.Damascus
import com.liferay.damascus.cli.common.CommonUtil
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.common.JsonUtil
import com.liferay.damascus.cli.common.TemplateUtil
import com.liferay.damascus.cli.test.tools.TestUtils
import groovy.json.JsonSlurper
import org.apache.commons.io.FileUtils
import org.apache.commons.io.filefilter.RegexFileFilter
import org.apache.commons.io.filefilter.TrueFileFilter
import spock.lang.Specification
import spock.lang.Unroll

import java.security.InvalidParameterException

class ApplicationTest extends Specification {
    static def DS = DamascusProps.DS;
    static def workspaceRootDir = TestUtils.getTempPath() + "damascustest";
    static def workspaceName = "workspace"
    static def workTempDir = "";
    static def createCommand;

    def setupEx(version) {
        //Cleanup enviroment
        FileUtils.deleteDirectory(new File(workspaceRootDir));
        def templateUtil = Spy(TemplateUtil)
        templateUtil.clear();

        //Create Workspace
        CommonUtil.createWorkspace(version, workspaceRootDir, workspaceName);

        //Execute all tests under modules
        workTempDir = workspaceRootDir + DS + workspaceName + DS + "modules";

        // Set base.json directory
        TestUtils.setFinalStatic(DamascusProps.class.getDeclaredField("CURRENT_DIR"), workTempDir + DS);

        createCommand = new CreateCommand();
    }

    @Unroll("Applications has hasPrimary Success test var1<#var1> var2<#var2> var3<#var3> ")
    def "Application has hasPrimary Success test"() {
        when:
        //Initialize
        setupEx(liferayVersion)

        def app = new Application()
        app.fields = Lists.newArrayList()
        def field1 = new com.liferay.damascus.cli.json.fields.Long();
        field1.setPrimary(var1);
        def field2 = new com.liferay.damascus.cli.json.fields.Double();
        field2.setPrimary(var2);
        def field3 = new com.liferay.damascus.cli.json.fields.Text();
        field3.setPrimary(var3);

        app.setTitle("This test") // for test
        app.fields.add(field1)
        app.fields.add(field2)
        app.fields.add(field3)

        def retVal = app.hasPrimary()

        then:
        true == app.hasPrimary()

        where:
        var1  | var2  | var3  | liferayVersion
        true  | false | false | DamascusProps.VERSION_71
        false | true  | false | DamascusProps.VERSION_71
        false | false | true  | DamascusProps.VERSION_71
        true  | false | false | DamascusProps.VERSION_72
        false | true  | false | DamascusProps.VERSION_72
        false | false | true  | DamascusProps.VERSION_72
    }

    @Unroll("Applications has hasPrimary Fail test var1<#var1> var2<#var2> var3<#var3>")
    def "Application has hasPrimary Fail test"() {
        when:
        //Initialize
        setupEx(liferayVersion)

        def app = new Application()
        app.fields = Lists.newArrayList()
        def field1 = new com.liferay.damascus.cli.json.fields.Long();
        field1.setPrimary(var1);
        def field2 = new com.liferay.damascus.cli.json.fields.Double();
        field2.setPrimary(var2);
        def field3 = new com.liferay.damascus.cli.json.fields.Text();
        field3.setPrimary(var3);

        app.setTitle("This test") // for test
        app.fields.add(field1)
        app.fields.add(field2)
        app.fields.add(field3)

        app.hasPrimary()

        then:
        thrown(InvalidParameterException)

        where:
        var1  | var2  | var3  | liferayVersion
        true  | true  | false | DamascusProps.VERSION_71
        false | true  | true  | DamascusProps.VERSION_71
        true  | true  | true  | DamascusProps.VERSION_71
        false | false | false | DamascusProps.VERSION_71
        true  | true  | false | DamascusProps.VERSION_72
        false | true  | true  | DamascusProps.VERSION_72
        true  | true  | true  | DamascusProps.VERSION_72
        false | false | false | DamascusProps.VERSION_72
    }

}
