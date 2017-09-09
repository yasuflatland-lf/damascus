package com.liferay.damascus.cli.common

import com.liferay.damascus.cli.CreateCommand
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import org.apache.commons.io.filefilter.RegexFileFilter
import org.apache.commons.io.filefilter.TrueFileFilter
import spock.lang.Specification
import spock.lang.Unroll

import java.nio.file.InvalidPathException
import java.util.stream.Collectors

class CommonUtilTest extends Specification {
    static def DS = DamascusProps.DS;
    static def SEP = "/";
    static def workTempDir = TestUtils.getTempPath() + "damascustest";
    static def template_path = DamascusProps.TEMPLATE_FOLDER_NAME;

    def setup() {
        FileUtils.deleteDirectory(new File(workTempDir));
    }

    /**
     * Write dummy file for testing
     *
     * @param path
     * @return
     */
    def fileCreate(path) {
        File file = new File(workTempDir + DS + path);
        FileUtils.writeStringToFile(file, "test", "utf-8")
    }

    @Unroll("Worng path given")
    def "Wrong path given"() {
        when:
        def file_path = DS + "9999" + DS + template_path;
        CommonUtil.readResource(CommonUtilTest.class, file_path);

        then:
        thrown(IllegalArgumentException)
    }

    @Unroll("Correct path given")
    def "Correct path given"() {
        when:
        def file_path = SEP + template_path + SEP + DamascusProps.VERSION_70 + SEP + DamascusProps.BASE_JSON;
        def result = CommonUtil.readResource(CommonUtilTest.class, file_path);

        then:
        result != null
        result.length() > 0
    }

    @Unroll("Search file recursive Test")
    def "Search file recursive Test"() {
        when:
        fileCreate("hoge" + DS + "fuga" + DS + targetTextFile)
        fileCreate("hoge" + DS + "aaa" + DS + anotherTextFile)
        def rootDir = new File(TestUtils.getTempPath());
        def result = CommonUtil.getPathFromName(rootDir, targetTextFile)

        then:
        null != result.getAbsoluteFile()

        where:
        targetTextFile | anotherTextFile
        "target.txt"   | "hogetarget.txt"
    }

    @Unroll("Same files found case")
    def "Same files found case"() {
        when:
        fileCreate("hoge" + DS + "fuga" + DS + targetTextFile)
        fileCreate("hoge" + DS + "aaa" + DS + anotherTextFile)
        def rootDir = new File(TestUtils.getTempPath());
        def result = CommonUtil.getPathFromName(rootDir, targetTextFile)

        then:
        thrown(InvalidPathException.class)

        where:
        targetTextFile | anotherTextFile
        "target.txt"   | "target.txt"
    }

    @Unroll("Gradle Run Test")
    def "Gradle Run Test"() {
        setup:
        def createCommand = new CreateCommand();

        when:
        CommonUtil.createServiceBuilderProject(name, packageName, workTempDir)
        def projectNameCommon = workTempDir + DS + name + DS + name;
        def servicePath = new File(projectNameCommon + "-service");

        //Run gradle buildService
        CommonUtil.runGradle(servicePath.getAbsolutePath(), "buildService")

        File implFile = CommonUtil.getPathFromName(new File(workTempDir), "FooModelImpl.java")
        File tablesSql = CommonUtil.getPathFromName(new File(workTempDir), "tables.sql")
        File f = new File(workTempDir + DS + name);

        then:
        true == f.exists()
        true == f.isDirectory()
        true == tablesSql.exists()
        true == servicePath.exists()
        true == implFile.exists()

        where:
        name   | packageName
        "Todo" | "com.liferay.test"
        "Task" | "jp.co.liferay.test"
        "Task" | "jp.co.liferay.test.longpackage.namehere"
    }

    @Unroll("Gradlew getDirFromPath test for a file")
    def "Gradlew getDirFromPath test for a file"() {
        when:
        fileCreate(dir1)
        def resultFile = CommonUtil.getDirFromPath(new File(workTempDir + DS + dir1))
        def expectedFile = new File(dir2);

        then:
        expectedFile == resultFile

        where:
        dir1                     | dir2
        "foo" + DS + "dummy.txt" | workTempDir + DS + "foo" + DS
    }

    @Unroll("Gradlew getDirFromPath test for a directory")
    def "Gradlew getDirFromPath test for a directory"() {
        when:
        FileUtils.forceMkdir(new File(dir1))
        def resultFile = CommonUtil.getDirFromPath(new File(dir1))
        def expectedFile = new File(dir2);

        then:
        expectedFile == resultFile

        where:
        dir1                          | dir2
        workTempDir + DS + "foo" + DS | workTempDir + DS + "foo" + DS
        workTempDir + DS + "bar"      | workTempDir + DS + "bar" + DS
    }

    @Unroll("Gradlew search Success test")
    def "Gradlew search Success test"() {
        when:
        def targetFile = (CommonUtil.isWindows()) ? "gradlew.bat" : "gradlew";
        FileUtils.forceMkdir(new File(dir1))
        fileCreate(whereToCreateFile + DS + targetFile)
        def file = CommonUtil.getPathFromNameInParents(new File(dir1 + dir3), targetFile)
        def expectedFile = new File(workTempDir + DS + whereToCreateFile + DS + targetFile);

        then:
        expectedFile == file

        where:
        dir1                                                       | whereToCreateFile  | dir3
        workTempDir + DS + "foo" + DS + "modules" + DS + "bar"     | "foo"              | ""
        workTempDir + DS + "foo" + DS + "modules" + DS + "modules" | "foo"              | ""
        workTempDir + DS + "foo" + DS + "bar"                      | "foo"              | ""
        workTempDir + DS + "foo" + DS + "bar"                      | "foo" + DS + "bar" | ""
    }

    @Unroll("Gradlew search Fail test")
    def "Gradlew search Fail test"() {
        when:
        def targetFile = (CommonUtil.isWindows()) ? "gradlew.bat" : "gradlew";
        FileUtils.forceMkdir(new File(dir1))
        fileCreate(whereToCreateFile + DS + targetFile)
        def file = CommonUtil.getPathFromNameInParents(new File(dir1 + dir3), targetFile)

        then:
        null == file

        where:
        dir1                                                       | whereToCreateFile  | dir3
        workTempDir + DS + "foo" + DS + "modules" + DS + "bar"     | "bar"              | ""
        workTempDir + DS + "foo" + DS + "modules" + DS + "modules" | "foo" + DS + "bar" | ""
    }


    @Unroll("Smoke test for Create Service Builder project name <#name> package <#packageName>")
    def "Smoke test for Create Service Builder project"() {
        when:
        CommonUtil.createServiceBuilderProject(name, packageName, workTempDir)
        def projectNameCommon = workTempDir + DS + name + DS + name;
        def service_path = new File(projectNameCommon + "-service");
        def api_path = new File(projectNameCommon + "-api");
        def buildGradle = new File(workTempDir + DS + name + DS + "build.gradle")
        def serviceXml = new File(projectNameCommon + "-service" + DS + "service.xml");
        File f = new File(workTempDir + DS + name);

        then:
        true == f.exists()
        true == f.isDirectory()
        true == service_path.exists()
        true == api_path.exists()
        true == buildGradle.exists()
        true == serviceXml.exists()

        where:
        name        | packageName
        "Todo"      | "com.liferay.test"
        "Todo_Dada" | "c.aaa"
    }

    @Unroll("Smoke test for Create MVC Portlet project. Project name <#name> package <#packageName>")
    def "Smoke test for Create MVC Portlet project"() {
        when:
        CommonUtil.createMVCPortletProject(name, packageName, workTempDir + DS + name)

        def projectName = name;
        if (!name.endsWith("-web")) {
            projectName = name.concat("-web");
        }
        def projectNameCommon = workTempDir + DS + name + DS + projectName
        def portlet_path = new File(projectNameCommon);
        def srcDir = new File(projectNameCommon + DS + "src")
        def buildGradle = new File(projectNameCommon + DS + "gradlew")
        def buildGradleBat = new File(projectNameCommon + DS + "gradlew.bat")
        File f = new File(projectNameCommon);

        then:
        true == f.exists()
        true == f.isDirectory()
        true == portlet_path.exists()
        true == srcDir.exists()
        false == buildGradle.exists()
        false == buildGradleBat.exists()

        where:
        name       | packageName
        "Hoge"     | "com.liferay.test"
        "Hoge-web" | "com.liferay"
    }

    @Unroll("Smoke test for Create workspace name<#name>")
    def "Smoke test for Create workspace"() {
        when:
        CommonUtil.createWorkspace(workTempDir, name)

        def projectNameCommon = workTempDir + DS + name
        def portlet_path = new File(projectNameCommon);
        def buildGradle = new File(projectNameCommon + DS + "gradlew")
        def modulesDir = new File(projectNameCommon + DS + "modules")
        File f = new File(projectNameCommon);

        then:
        true == f.exists()
        true == f.isDirectory()
        true == portlet_path.exists()
        true == buildGradle.exists()
        true == modulesDir.exists()

        where:
        name      | _
        "Foo"     | _
        "Foo-web" | _
        "Bar_web" | _
    }

    void dummyWriter(file, dummy_text) {
        file(dummy_text) {
            file.withWriter('UTF-8') { writer ->
                writer.write 'test'
            }
        }
    }

    @Unroll("getTargetFiles Test <#file_names> result num<#result_num>")
    def "getTargetFiles Test"() {
        when:
        def targetDir = workTempDir + DS + 'tmpfolder';
        final FileTreeBuilder tf = new FileTreeBuilder(new File(targetDir))
        tf.dir('Foo') {
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

        List<String> tgt = new ArrayList<>();

        file_names.each { target_path ->
            tgt.push(target_path);
        }

        def result = CommonUtil.getTargetFiles(targetDir, tgt)

        then:
        result_num == result.size();

        where:
        file_names                   | result_num
        ["Bar.*"]                    | 2
        ["Bar.*", "Foo.*"]           | 3
        [".*-service.java"]          | 2
        [".*-service.*", ".*-api.*"] | 3
    }

    @Unroll("replaceContents Test <#check_pattern> <#replace_patterns>")
    def "replaceContents Test"() {
        when:
        def targetDir = workTempDir + DS + 'tmpfolder';
        final FileTreeBuilder tf = new FileTreeBuilder(new File(targetDir))
        tf.dir('Foo') {
            dir('Foo-api') {
                file('build.gradle') {
                    withWriter('UTF-8') { writer ->
                        writer.write 'apply plugin: "com.liferay.portal.tools.service.builder"\n' +
                            '\n' +
                            '//Need for Windows\n' +
                            'def defaultEncoding = \'UTF-8\'\n' +
                            '\n' +
                            'dependencies {\n' +
                            '    compile group: "javax.portlet", name: "portlet-api", version: "2.0"\n' +
                            '    compile group: "javax.servlet", name: "javax.servlet-api", version: "3.0.1"\n' +
                            '    compile group: "org.osgi", name: "org.osgi.service.component.annotations", version: "1.3.0"\n' +
                            '    compile project(":First-api")\n' +
                            '    compileOnly project(":First-api")\n' +
                            '    compileOnly project(":First-service")    \n' +
                            '}\n' +
                            '\n' +
                            'buildService {\n' +
                            '    apiDir = "../First-api/src/main/java"\n' +
                            '}\n' +
                            '\n' +
                            'group = "com.liferay.first"'
                    }
                }
            }
        }

        //Get File list
        List<File> files = FileUtils.listFiles(
            new File(targetDir),
            new RegexFileFilter(".*"),
            TrueFileFilter.INSTANCE
        ).stream().collect(Collectors.toList());

        //Set replace patterns into a Map
        Map<String, String> patterns = new HashMap<>();

        replace_patterns.each { k, v ->
            patterns.put(k, v)
        }

        //Test
        CommonUtil.replaceContents(files, patterns)

        then:
        for (File file : files) {
            check_pattern.each { k, v ->
                if (k == "null") {
                    assert null == file.text.find(v)
                } else {
                    assert k == file.text.find(v)
                }
            }
        }

        where:
        check_pattern                                                          | replace_patterns
        ["null": "apply plugin: \"com.liferay.portal.tools.service.builder\""] | ["apply plugin: \"com.liferay.portal.tools.service.builder\".*\\n": ""]
        [":modules:First:First-api": ":modules:First:First-api"]               | [/project.*":First-api".*/: "project(\":modules:First:First-api\")"]
        [":modules:First:First-service": ":modules:First:First-service"]       | [/project.*":First-service".*/: "project(\":modules:First:First-service\")"]
        ["null": "apply plugin: \"com.liferay.portal.tools.service.builder\""] | ["apply plugin: \"com.liferay.portal.tools.service.builder\".*\\n": "", /project.*":First-api\".*/: "project" +
            "(\":modules:First:First-api\")", /project.*":First-service".*/ : "project(\":modules:First:First-service\")"]

    }

    @Unroll("invertPathToList Test <#path> <#result1> <#result2>")
    def "invertPathToList Test"() {
        when:
        when:
        def targetDir = workTempDir + DS + 'tmpfolder';
        final FileTreeBuilder tf = new FileTreeBuilder(new File(targetDir))
        tf.dir('dummy') {
            dir('temp') {
                dir('sample-sb') {
                    dir('sample-sb-api') {
                        file('build.gradle') {
                            withWriter('UTF-8') { writer ->
                                writer.write 'test';
                            }
                        }
                    }
                }
            }
        }
        List<String> result = CommonUtil.invertPathToList(targetDir + path)

        then:
        result[0] == result1
        result[1] == result2

        where:
        path                                               | result1         | result2
        "/dummy/temp/sample-sb/sample-sb-api/build.gradle" | "sample-sb-api" | "sample-sb"
        "/dummy/temp/sample-sb/sample-sb-api/"             | "sample-sb-api" | "sample-sb"
        "/dummy/temp/sample-sb/sample-sb-api"              | "sample-sb-api" | "sample-sb"

    }
}
