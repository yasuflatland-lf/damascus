package com.liferay.damascus.cli

import com.beust.jcommander.internal.Maps
import com.liferay.damascus.cli.common.CommonUtil
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.common.JsonUtil
import com.liferay.damascus.cli.common.TemplateUtil
import com.liferay.damascus.cli.common.TemplateUtilTest
import com.liferay.damascus.cli.json.DamascusBase
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import org.apache.commons.io.filefilter.RegexFileFilter
import org.apache.commons.io.filefilter.TrueFileFilter
import org.apache.commons.lang3.StringUtils
import spock.lang.Specification
import spock.lang.Unroll

class CreateCommandTest extends Specification {
    static def DS = DamascusProps.DS;
    static def workspaceRootDir = TestUtils.getTempPath() + "damascustest";
    static def workspaceName = "workspace"
    static def workTempDir = "";
    static def createCommand;

    def setup() {
        //Cleanup enviroment
        FileUtils.deleteDirectory(new File(workspaceRootDir));

        //Create Workspace
        CommonUtil.createWorkspace(workspaceRootDir, workspaceName);

        //Execute all tests under modules
        workTempDir = workspaceRootDir + DS + workspaceName + DS + "modules";

        TestUtils.setFinalStatic(CreateCommand.class.getDeclaredField("CREATE_TARGET_PATH"), workTempDir + DS);
        createCommand = new CreateCommand();
    }

    @Unroll("Smoke test for service.xml generate ProjectName<#projectName> version <#liferayVersion> Package <#packageName>")
    def "Smoke test for service.xml generate"() {

        when:
        Map params = Maps.newHashMap();

        //Set parameters
        params.put("projectName", projectName)
        params.put("liferayVersion", liferayVersion)
        params.put("packageName", packageName)
        params.put("projectNameLower", StringUtils.lowerCase(projectName))
        Map damascus = Maps.newHashMap();
        damascus.put('damascus', params);

        //Output base.json with parameters.
        TemplateUtil.getInstance().process(TemplateUtilTest.class, liferayVersion, DamascusProps.BASE_JSON, damascus, workTempDir + DS + DamascusProps.BASE_JSON)

        //Load base.json into object
        DamascusBase retrievedObj = JsonUtil.getObject(workTempDir + DS + DamascusProps.BASE_JSON, DamascusBase.class)

        //Setup output files
        def outputFile = workTempDir + DS + DamascusProps.SERVICE_XML

        //Generate Service XML
        createCommand.generateScaffolding(
            retrievedObj,
            DamascusProps.SERVICE_XML,
            outputFile,
            retrievedObj.applications[0])

        def f = new File(outputFile)

        //Testing nodes
        def rootNode = TestUtils.getPath(outputFile)
        def ret1 = rootNode.entity[0].column[0].@name

        then:
        true == f.exists()
        false == f.isDirectory()
        false == ret1.equals("")

        where:
        projectName | liferayVersion | packageName
        "ToDo"      | "70"           | "com.liferay.test"
    }

    @Unroll("Smoke test for generating Project Project<#projectName> Package<#packageName>")
    def "Smoke test for generating Project"() {

        when:
        def projectNameCommon = workTempDir + DS + projectName + DS + projectName;
        def service_path = new File(projectNameCommon + "-service");
        def api_path = new File(projectNameCommon + "-api");
        def buildGradle = new File(workTempDir + DS + projectName + DS + "build.gradle")
        def serviceXml = new File(projectNameCommon + "-service" + DS + "service.xml");

        def webName = projectName;
        if (!projectName.endsWith("-web")) {
            webName = projectName.concat("-web");
        }
        def webNameDir = workTempDir + DS + projectName + DS + webName
        def srcDir_web = new File(webNameDir + DS + "src")
        def gradlewFile = new File(webNameDir + DS + "gradlew")
        def gradlewBatFile = new File(webNameDir + DS + "gradlew.bat")

        //Generate project skeleton
        createCommand.generateProjectSkeleton(
            projectName,
            packageName,
            workTempDir)

        //Setup output files
        def outputFile = workTempDir + DS + projectName
        def f = new File(outputFile)
        def fweb = new File(webNameDir);

        then:
        //*-service / *-api
        true == f.exists()
        true == f.isDirectory()
        true == service_path.exists()
        true == api_path.exists()
        true == buildGradle.exists()
        true == serviceXml.exists()

        //*-web
        true == fweb.exists()
        true == fweb.isDirectory()
        true == srcDir_web.exists()
        false == gradlewFile.exists()
        false == gradlewBatFile.exists()

        where:
        projectName | packageName
        "ToDo"      | "com.liferay.test"
        "Tasks"     | "com.foo"
        "To-Do"     | "com.bar.foo.packeage.long"
        "T_Ask"     | "com.foo.bar"
    }

    @Unroll("Create Test from Main ProjectName<#projectName> version <#liferayVersion> Package <#packageName>")
    def "Create Test from Main"() {
        when:
        Map params = Maps.newHashMap();
        def workTempDirAPI = workTempDir + DS + projectName + DS + projectName + "-api";

        //Set parameters
        params.put("projectName", projectName)
        params.put("liferayVersion", liferayVersion)
        params.put("packageName", packageName)
        params.put("projectNameLower", StringUtils.lowerCase(projectName))
        Map damascus = Maps.newHashMap();
        damascus.put('damascus', params);

        //Output base.json with parameters.
        TemplateUtil.getInstance().process(
            TemplateUtilTest.class,
            liferayVersion,
            DamascusProps.BASE_JSON,
            damascus,
            workTempDir + DS + DamascusProps.BASE_JSON)

        //Run damascus -create
        String[] args = ["-create"]
        Damascus.main(args)

        //Test files / directories are property generated
        def projectNameCommon = workTempDir + DS + projectName + DS + projectName;
        def service_path = new File(projectNameCommon + "-service");
        def api_path = new File(projectNameCommon + "-api");
        def buildGradle = new File(workspaceRootDir + DS + workspaceName + DS + "build.gradle")
        def serviceXml = new File(projectNameCommon + "-service" + DS + "service.xml");
        def implFile = FileUtils.listFiles(service_path, new RegexFileFilter(".*LocalServiceImpl.java"), TrueFileFilter.INSTANCE)
        def validatorFile = FileUtils.listFiles(new File(workTempDir + DS + projectName), new RegexFileFilter(".*Validator.java"), TrueFileFilter.INSTANCE)
        def portletKeysFile = FileUtils.listFiles(new File(workTempDirAPI), new RegexFileFilter(".*PortletKeys.java"), TrueFileFilter.INSTANCE)

        def f = new File(workTempDir + DS + projectName)

        then:
        //*-service / *-api
        true == f.exists()
        true == f.isDirectory()
        true == service_path.exists()
        true == api_path.exists()
        true == buildGradle.exists()
        true == serviceXml.exists()
        0 != implFile.size()
        0 != validatorFile.size()
        0 != portletKeysFile.size()

        where:
        projectName | liferayVersion | packageName
        "SampleSB"  | "70"           | "com.liferay.test"

    }

    def "Template creation tests"() {
        setup:
        Map params = Maps.newHashMap();

        //Set parameters
        params.put("projectName", projectName)
        params.put("liferayVersion", liferayVersion)
        params.put("packageName", packageName)
        params.put("projectNameLower", StringUtils.lowerCase(projectName))
        Map damascus = Maps.newHashMap();
        damascus.put('damascus', params);

        //Output base.json with parameters.
        TemplateUtil.getInstance().process(
            TemplateUtilTest.class,
            liferayVersion,
            DamascusProps.BASE_JSON,
            damascus,
            workTempDir + DS + DamascusProps.BASE_JSON)

        //Run damascus -create
        String[] args = ["-create"]
        Damascus.main(args)

        when:
        //Target path map of a project
        def pathMap = [
            rootPath   : workTempDir + DS + projectName,
            apiPath    : workTempDir + DS + projectName + DS + projectName + "-api",
            servicePath: workTempDir + DS + projectName + DS + projectName + "-service",
            webPath    : workTempDir + DS + projectName + DS + projectName + "-web"
        ];

        //Spock can't setup block to run for one time for a method, so list up all tests as below.

        def targetFile1 = FileUtils.listFiles(new File(pathMap["apiPath"]), new RegexFileFilter(".*ActivityKeys.java"), TrueFileFilter.INSTANCE)
        def targetFile2 = FileUtils.listFiles(new File(pathMap["apiPath"]), new RegexFileFilter(".*bnd.bnd"), TrueFileFilter.INSTANCE)
        def targetFile3 = FileUtils.listFiles(new File(pathMap["apiPath"]), new RegexFileFilter(".*build.gradle"), TrueFileFilter.INSTANCE)
        def targetFile4 = FileUtils.listFiles(new File(pathMap["apiPath"]), new RegexFileFilter(".*PortletKeys.java"), TrueFileFilter.INSTANCE)
        def targetFile5 = FileUtils.listFiles(new File(pathMap["apiPath"]), new RegexFileFilter(".*ValidateException.java"), TrueFileFilter.INSTANCE)
        def targetFile6 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*bnd.bnd"), TrueFileFilter.INSTANCE)
        def targetFile7 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*build.gradle"), TrueFileFilter.INSTANCE)
        def targetFile8 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*default.xml"), TrueFileFilter.INSTANCE)
        def targetFile9 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*Indexer.java"), TrueFileFilter.INSTANCE)
        def targetFile10 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*LocalServiceImpl.java"), TrueFileFilter.INSTANCE)
        def targetFile11 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*PermissionChecker.java"), TrueFileFilter.INSTANCE)
        def targetFile12 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*portlet.properties"), TrueFileFilter.INSTANCE)
        def targetFile13 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*portlet-model-hints.xml"), TrueFileFilter.INSTANCE)
        def targetFile14 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*ResourcePermissionChecker.java"), TrueFileFilter.INSTANCE)
        def targetFile15 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*TrashHandler.java"), TrueFileFilter.INSTANCE)
        def targetFile16 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*Validator.java"), TrueFileFilter.INSTANCE)
        def targetFile17 = FileUtils.listFiles(new File(pathMap["servicePath"]), new RegexFileFilter(".*WorkflowHandler.java"), TrueFileFilter.INSTANCE)
        def targetFile18 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*abstract.jsp"), TrueFileFilter.INSTANCE)
        def targetFile19 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*ActivityInterpreter.java"), TrueFileFilter.INSTANCE)
        def targetFile20 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*AssetRenderer.java"), TrueFileFilter.INSTANCE)
        def targetFile21 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*AssetRendererFactory.java"), TrueFileFilter.INSTANCE)
        def targetFile22 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*bnd.bnd"), TrueFileFilter.INSTANCE)
        def targetFile23 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*build.gradle"), TrueFileFilter.INSTANCE)
        def targetFile24 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*ConfigrationAction.java"), TrueFileFilter.INSTANCE)
        def targetFile25 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*Configuration.java"), TrueFileFilter.INSTANCE)
        def targetFile26 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*configuration.jsp"), TrueFileFilter.INSTANCE)
        def targetFile27 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*CrudMVCActionCommand.java"), TrueFileFilter.INSTANCE)
        def targetFile28 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*CurdMVCRenderCommand.java"), TrueFileFilter.INSTANCE)
        def targetFile29 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*default.xml"), TrueFileFilter.INSTANCE)
        def targetFile30 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*edit.jsp"), TrueFileFilter.INSTANCE)
        def targetFile31 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*edit_actions.jsp"), TrueFileFilter.INSTANCE)
        def targetFile32 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*full_content.jsp"), TrueFileFilter.INSTANCE)
        def targetFile33 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*init.jsp"), TrueFileFilter.INSTANCE)
        def targetFile34 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*ItemSelectorHelper.java"), TrueFileFilter.INSTANCE)
        def targetFile35 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*portlet.properties"), TrueFileFilter.INSTANCE)
        def targetFile36 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*search_results.jspf"), TrueFileFilter.INSTANCE)
        def targetFile37 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*view.jsp"), TrueFileFilter.INSTANCE)
        def targetFile38 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*ViewHelper.java"), TrueFileFilter.INSTANCE)
        def targetFile39 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*ViewMVCRenderCommand.java"), TrueFileFilter.INSTANCE)
        def targetFile40 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*view_record.jsp"), TrueFileFilter.INSTANCE)
        def targetFile41 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*WebKeys.java"), TrueFileFilter.INSTANCE)
        def targetFile42 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*WebPortlet.java"), TrueFileFilter.INSTANCE)
        def targetFile43 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*portlet.properties"), TrueFileFilter.INSTANCE)
        def targetFile44 = FileUtils.listFiles(new File(pathMap["rootPath"]), new RegexFileFilter(".*build.gradle"), TrueFileFilter.INSTANCE)
        def targetFile45 = FileUtils.listFiles(new File(pathMap["rootPath"]), new RegexFileFilter(".*settings.gradle"), TrueFileFilter.INSTANCE)
        def targetFile46 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*FindEntryAction.java"), TrueFileFilter.INSTANCE)
        def targetFile47 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*FindEntryHelper.java"), TrueFileFilter.INSTANCE)
        def targetFile48 = FileUtils.listFiles(new File(pathMap["webPath"]), new RegexFileFilter(".*PortletLayoutFinder.java"), TrueFileFilter.INSTANCE)

        then:
        1 == targetFile1.size();
        1 == targetFile2.size();
        1 == targetFile3.size();
        1 == targetFile4.size();
        1 == targetFile5.size();
        1 == targetFile6.size();
        1 == targetFile7.size();
        1 == targetFile8.size();
        1 == targetFile9.size();
        1 == targetFile10.size();
        2 == targetFile11.size();
        1 == targetFile12.size();
        1 == targetFile13.size();
        1 == targetFile14.size();
        1 == targetFile15.size();
        1 == targetFile16.size();
        1 == targetFile17.size();
        1 == targetFile18.size();
        1 == targetFile19.size();
        1 == targetFile20.size();
        1 == targetFile21.size();
        1 == targetFile22.size();
        1 == targetFile23.size();
        1 == targetFile24.size();
        1 == targetFile25.size();
        1 == targetFile26.size();
        1 == targetFile27.size();
        1 == targetFile28.size();
        1 == targetFile29.size();
        1 == targetFile30.size();
        1 == targetFile31.size();
        1 == targetFile32.size();
        1 == targetFile33.size();
        1 == targetFile34.size();
        1 == targetFile35.size();
        1 == targetFile36.size();
        1 == targetFile37.size();
        1 == targetFile38.size();
        1 == targetFile39.size();
        1 == targetFile40.size();
        1 == targetFile41.size();
        1 == targetFile42.size();
        1 == targetFile43.size();
        4 == targetFile44.size();
        1 == targetFile45.size();
        1 == targetFile46.size();
        1 == targetFile47.size();
        1 == targetFile48.size();

        where:
        projectName | liferayVersion | packageName
        "SampleSB"  | "70"           | "com.liferay.test"
    }
}
