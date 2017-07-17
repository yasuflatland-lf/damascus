package com.liferay.damascus.cli.common

import com.beust.jcommander.internal.Maps
import com.google.common.io.Resources
import com.liferay.damascus.cli.json.DamascusBase
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import org.apache.commons.io.filefilter.IOFileFilter
import org.apache.commons.io.filefilter.WildcardFileFilter
import org.apache.commons.lang3.StringUtils
import org.apache.commons.lang3.Validate
import org.joda.time.DateTime
import spock.lang.Specification
import spock.lang.Unroll

class TemplateUtilTest extends Specification {
    static def DS = DamascusProps.DS;
	static def SEP = "/";
    static def workTempDir = TestUtils.getTempPath() + "damascustest";
    static def targetTempDir = TestUtils.getTempPath() + "target" + DS + DamascusProps.TEMPLATE_FOLDER_NAME;
    static def CDIR = DamascusProps.TARGET_TEMPLATE_PREFIX;

    def setup() {
        FileUtils.deleteDirectory(new File(workTempDir));
        FileUtils.deleteDirectory(new File(targetTempDir));
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

    @Unroll("Smoke test for replacing place holder (project <#projectName> : version <#liferayVersion> : package <#packageName>")
    def "Smoke test for replacing place holder"() {

        when:
        def OUTPUT_FILE = "output.json"
        def output_file_path = TestUtils.getTempPath() + OUTPUT_FILE
        Map params = Maps.newHashMap();

        //Set parameters
        params.put("projectName", projectName)
        params.put("liferayVersion", liferayVersion)
        params.put("packageName", packageName)
        params.put("projectNameLower", StringUtils.lowerCase(projectName))
        Map damascus = Maps.newHashMap();
        damascus.put('damascus', params);

        //Output base.json with parameters.
        TemplateUtil.getInstance().process(TemplateUtilTest.class, liferayVersion, DamascusProps.BASE_JSON, damascus, output_file_path)

        //Load into object
        def retrivedObj = JsonUtil.getObject(output_file_path, DamascusBase.class)

        File f = new File(output_file_path);

        then:
        true == f.exists()
        false == f.isDirectory()
        true == (retrivedObj.getProjectName().equals(projectName))
        true == (retrivedObj.getLiferayVersion().equals(liferayVersion))
        true == (retrivedObj.applications.get(0).getPackageName().equals(packageName))
        true == (retrivedObj.applications.get(0).asset.getAssetTitleFieldName().equals(StringUtils.lowerCase(projectName) + "TitleName"))
        true == (retrivedObj.applications.get(0).asset.getAssetSummaryFieldName().equals(StringUtils.lowerCase(projectName) + "SummaryName"))
        true == (retrivedObj.applications.get(0).asset.getFullContentFieldName().equals(StringUtils.lowerCase(projectName) + "fullContent"))
        true == (retrivedObj.applications.get(0).fields.get(0).getName().equals(StringUtils.lowerCase(projectName) + "Id"))
        true == (retrivedObj.applications.get(0).fields.get(0).getTitle().equals(projectName + " Id"))
        true == retrivedObj.applications.get(0).fields.get(0).getClass().equals(com.liferay.damascus.cli.json.fields.Long.class)

        where:
        projectName | liferayVersion | packageName
        "ToDo"      | "70"           | "com.liferay.test"
    }

    @Unroll("process test fetching output file path from a template pj<#projectName> version<#liferayVersion> package<#packageName> filepath<#filepath>")
    def "process test fetching output file path from a template"() {

        when:
        def targetFile = "Portlet_XXXXSVC_Validator.java.ftl";
        def paramFilePath = TestUtils.getTempPath() + filepath + DS + TemplateUtil.getInstance().getOutputFilename(targetFile)

        //Set parameters
        Map params = Maps.newHashMap();
        DamascusBase dmsb = TestUtils.createBaseJsonMock(projectName, liferayVersion, packageName, paramFilePath)
        params.put(DamascusProps.BASE_DAMASCUS_OBJ, dmsb);
        params.put(DamascusProps.BASE_TEMPLATE_UTIL_OBJ, TemplateUtil.getInstance());
        params.put(DamascusProps.BASE_CASE_UTIL_OBJ, CaseUtil.getInstance());
        params.put(DamascusProps.BASE_CURRENT_APPLICATION, dmsb.applications[0]);
        params.put(DamascusProps.TEMPVALUE_FILEPATH, paramFilePath);
        params.put(DamascusProps.PROP_AUTHOR.replace(".","_"),"TEST");

        //Output base.json with parameters.
        TemplateUtil.getInstance().process(TemplateUtilTest.class, DamascusProps.VERSION_70, targetFile, params, paramFilePath)

        File f = new File(paramFilePath);

        then:
        true == f.exists()
        false == f.isDirectory()

        where:
        projectName | liferayVersion | packageName                | filepath
        "Todo"      | "70"           | "com.liferay.test.foo.bar" | "foo" + DS + "bar"
        "Todo"      | "70"           | "com.liferay.test.foo.bar" | ""
    }

    @Unroll("Search template files Success Test file1<#file1> file2<#file2> file3<#file3> file4<#file4>")
    def "Search template files Success Test"() {

        when:
        fileCreate(file1)
        fileCreate(file2)
        fileCreate(file3)
        fileCreate(file4)
        def resultFiles = TemplateUtil.getInstance().getTargetTemplates(CDIR, new File(workTempDir));

        then:
        totalCount == resultFiles.size()

        where:
        file1                    | file2                     | file3               | file4              | totalCount
        CDIR + "File1.java"      | CDIR + "File2.ftl"        | CDIR + "File3.json" | CDIR + "File1.txt" | 4
        "File1.java" + CDIR      | CDIR + "File2.ftl"        | CDIR + "File3.json" | CDIR + "File1.txt" | 3
        "File1" + CDIR + ".java" | CDIR + CDIR + "File2.ftl" | CDIR + "File3.json" | CDIR + "File1.txt" | 3
        "File1" + CDIR + ".java" | "File2.ftl"               | "File3.json"        | CDIR + "File1.txt" | 1
    }

    @Unroll("Search template files from Resource Test")
    def "Search template files from Resource Test"() {

        when:
        // Resource root path and initialize Freemarker configration with the path
        String resourceRootPath = DamascusProps.DS + DamascusProps.TEMPLATE_FOLDER_NAME + DamascusProps.DS + DamascusProps.VERSION_70
        URL url = CommonUtil.getResource(TemplateUtilTest.class, resourceRootPath);
        def resultFiles = TemplateUtil.getInstance().getTargetTemplates(target_fetch_file, new File(url.toURI()));

        then:
        0 <= resultFiles.size()

        where:
        target_fetch_file                    | _
        DamascusProps.TARGET_TEMPLATE_PREFIX | _
    }

    @Unroll("Search template files Fail Test")
    def "Search template files Fail Test"() {

        when:
        fileCreate("File1.java")
        def resultFiles = TemplateUtil.getInstance().getTargetTemplates(CDIR, new File(workTempDir));

        then:
        null == resultFiles
        thrown(IOException.class)
    }

    @Unroll("GetOutputFilename Test filename<#filename> result<#resulttype>")
    def "GetOutputFilename Test"() {
        when:
        def tempName = DamascusProps.TARGET_TEMPLATE_PREFIX + filename + DamascusProps.TARGET_TEMPLATE_SUFFIX;
        def result = TemplateUtil.getInstance().getOutputFilename(tempName)

        then:
        if (resulttype.equals("SUCCESS")) {
            assert true == result.equals(filename)
        } else {
            assert true != result.equals(filename)
        }

        where:
        filename                                     | resulttype
        "Foo"                                        | "SUCCESS"
        DamascusProps.TARGET_TEMPLATE_PREFIX + "Bar" | "SUCCESS"
        "Bar" + DamascusProps.TARGET_TEMPLATE_PREFIX | "SUCCESS"
        "Bar.xml"                                    | "SUCCESS"
        "Foo.java"                                   | "SUCCESS"
        "Bar.json"                                   | "SUCCESS"
        "Bar.jsp"                                    | "SUCCESS"
        "Bar_jsp"                                    | "SUCCESS"
        "Bar" + DamascusProps.TARGET_TEMPLATE_SUFFIX | "FAIL"
    }

    @Unroll("is this inside jar test")
    def "is this inside jar test"() {
        when:
        def result = TemplateUtil.getInstance().isInsideJar(TemplateUtilTest.class)

        then:
        //While test, this should be false
        false == result
    }

    @Unroll("copy templates into cache test")
    def "copy templates into cache test"() {
        when:
        def resourceDir = DS + DamascusProps.TEMPLATE_FOLDER_NAME;
        def outputDir = targetTempDir + DS + DamascusProps.TEMPLATE_FOLDER_NAME
        TemplateUtil.getInstance().copyTemplatesToCache(TemplateUtilTest.class, resourceDir, outputDir)

        File f = new File(outputDir + DS + DamascusProps.VERSION_70 + DS + DamascusProps.BASE_JSON )

        then:
        true == f.exists()
    }

    @Unroll("copy templates into cache test for Jar")
    def "copy templates into cache test for Jar"() {
        when:
        def resourceDir = DS + DamascusProps.TEMPLATE_FOLDER_NAME;
        def outputDir = targetTempDir;
        URL url = CommonUtil.getResource(TemplateUtilTest.class, resourceDir);
        def cf = FileUtils.listFiles(new File(url.toURI()),new WildcardFileFilter("*"),new WildcardFileFilter("*"))
        List<String> fl = new ArrayList<String>()
        cf.collect { 
			def pathc = it.toURI().toString().substring(it.toURI().toString().lastIndexOf(SEP + DamascusProps.TEMPLATE_FOLDER_NAME))
			fl.add(pathc.replace(SEP+SEP, SEP)) 
		}

        TemplateUtil.getInstance().copyTemplatesToCache(
            TemplateUtilTest.class,
            fl,
            outputDir)

        File f = new File(outputDir + DS + DamascusProps.TEMPLATE_FOLDER_NAME + DS + DamascusProps.VERSION_70 + DS + DamascusProps.BASE_JSON )

        then:
        true == f.exists()
    }
}
