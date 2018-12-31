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
        TemplateUtil.getInstance().clear();

        //Create Workspace
        CommonUtil.createWorkspace(version, workspaceRootDir, workspaceName);

        //Execute all tests under modules
        workTempDir = workspaceRootDir + DS + workspaceName + DS + "modules";

        TestUtils.setFinalStatic(CreateCommand.class.getDeclaredField("CREATE_TARGET_PATH"), workTempDir + DS);
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
    }

    @Unroll("Smoke Test for customValue <#key1>:<#value1> | <#key2><#value2>")
    def "Smoke Test for customValue"() {
        when:
        //Initialize
        setupEx(liferayVersion)

        def paramFilePath = workTempDir + DS + "temp.json"
        def projectName = "Todo"
        def packageName = "com.liferay.test.foo.bar"
        DamascusBase dmsb = TestUtils.createBaseJsonMock(projectName, liferayVersion, packageName, paramFilePath)

        dmsb.applications[0].customValue = new HashMap<>();
        dmsb.applications[0].customValue.put(key1, value1)
        dmsb.applications[0].customValue.put(key2, value2)
        JsonUtil.writer(paramFilePath, dmsb);

        def baseJsonContents = new File(paramFilePath).text;
        def parsedJson = new JsonSlurper().parseText(baseJsonContents)

        then:
        value1 == parsedJson.applications[0].get("customValue").get(key1)
        value2 == parsedJson.applications[0].get("customValue").get(key2)

        cleanup:
        FileUtils.deleteQuietly(new File(paramFilePath))

        where:
        key1      | value1     | key2   | value2   | liferayVersion
        "keytest" | "valutest" | "key2" | "value2" | DamascusProps.VERSION_71
    }

    @Unroll("Smoke Test for customValue value convert <#key1>:<#value1> | <#key2><#value2>")
    def "Smoke Test for customValue value convert"() {
        when:
        //Initialize
        setupEx(liferayVersion)

        //
        // Generate custom value base.json
        //
        def paramFilePath = workTempDir + DS + DamascusProps.BASE_JSON
        def projectName = "Todo"
        def expectedProjectDirName = "todo"
        def packageName = "com.liferay.test.foo.bar"

        // Once clear _cfg to initialize with an actual test target template directory
        TemplateUtil.getInstance().clear()

        DamascusBase dmsb = TestUtils.createBaseJsonMock(projectName, liferayVersion, packageName, paramFilePath, false)

        dmsb.applications[0].customValue = new HashMap<>();
        dmsb.applications[0].customValue.put(key1, value1)
        dmsb.applications[0].customValue.put(key2, value2)
        JsonUtil.writer(paramFilePath, dmsb);

        //
        // Test template
        //
        def targetDir = DamascusProps.TEMPLATE_FILE_PATH;
        def testFileName = "Portlet_testfile.jsp.ftl"
        final FileTreeBuilder tf = new FileTreeBuilder(new File(targetDir))
        tf.dir(liferayVersion) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
                        <#include "./valuables.ftl">
                        <#assign createPath = "${entityWebResourcesPath}/testfile.jsp">
                        
                        <#if application.customValue?exists>
                        <h2>${application.customValue["key1"]}</h2>
                        <h2>${application.customValue["key2"]}</h2>
                        </#if>
'''.stripIndent()
                }
            }
        }

        //Run damascus -create
        String[] args = ["-create"]
        Damascus.main(args)

        //Target path map of a project
        def pathMap = TestUtils.getPathMap(expectedProjectDirName)
        def targetFile1 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*testfile.jsp"), TrueFileFilter.INSTANCE)

        then:
        targetFile1.each {
            def m1 = (it.text ==~ /.*FOOFOO.*/)
            def m2 = (it.text ==~ /.*BARBAR.*/)
            assert m1 instanceof Boolean
            assert m2 instanceof Boolean
        }

        cleanup:
        // Delete test file
        FileUtils.deleteQuietly(new File(targetDir + DS + liferayVersion + DS + testFileName))

        where:
        key1   | value1   | key2   | value2   | liferayVersion
        "key1" | "FOOFOO" | "key2" | "BARBAR" | DamascusProps.VERSION_71
    }

}
