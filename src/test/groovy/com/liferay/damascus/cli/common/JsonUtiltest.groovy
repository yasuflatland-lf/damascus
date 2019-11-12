package com.liferay.damascus.cli.common

import com.beust.jcommander.ParameterException
import com.fasterxml.jackson.databind.JsonMappingException
import com.liferay.damascus.cli.json.DamascusBase
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import spock.lang.Ignore
import spock.lang.Specification
import spock.lang.Unroll

class JsonUtilTest extends Specification {
    static def DS = DamascusProps.DS;
    static def SEP = "/";
    static def workTempDir = TestUtils.getTempPath() + "damascustest";

    def template_path = DamascusProps.TEMPLATE_FOLDER_NAME;
    def resource_path = SEP + template_path + SEP + DamascusProps.VERSION_72 + SEP
    def base_json_path = resource_path + DamascusProps.BASE_JSON;

    def setup() {
        TestUtils.setFinalStatic(DamascusProps.class.getDeclaredField("CACHE_DIR_PATH"), TestUtils.getTempPath() + ".damascus");
        FileUtils.deleteDirectory(new File(workTempDir));
        FileUtils.forceMkdir(new File(workTempDir))
        FileUtils.deleteDirectory(new File(DamascusProps.CACHE_DIR_PATH));
        FileUtils.forceMkdir(new File(DamascusProps.CACHE_DIR_PATH))
    }

    @Unroll("JSON Read Smoke test")
    def "JSON Read Smoke test"() {
        when:
        def retrivedObj = JsonUtil.getObjectFromResource(base_json_path, DamascusBase.class, JsonUtilTest.class)

        //TODO:need to add more fields validation, especialy placeholders where need to be replaced later.
        then:
        true == (retrivedObj.getProjectName().equals("\${damascus.projectName}"))
        true == (retrivedObj.getLiferayVersion().equals("\${damascus.liferayVersion}"))
        true == (retrivedObj.getPackageName().equals("\${damascus.packageName}"))
        true == (retrivedObj.applications.get(0).asset.getAssetTitleFieldName().equals("\${damascus.entityNameLower}TitleName"))
        true == (retrivedObj.applications.get(0).asset.getAssetSummaryFieldName().equals("\${damascus.entityNameLower}SummaryName"))
        true == (retrivedObj.applications.get(0).asset.getFullContentFieldName().equals("\${damascus.entityNameLower}fullContent"))
        true == (retrivedObj.applications.get(0).fields.get(0).getName().equals("\${damascus.entityNameLower}Id"))
        true == (retrivedObj.applications.get(0).fields.get(0).getTitle().equals("\${damascus.projectName} Id"))
        true == (retrivedObj.applications.get(0).fields.get(0).getType().equals(com.liferay.damascus.cli.json.fields.Long.class.getName()))
        true == retrivedObj.applications.get(0).fields.get(0).getClass().equals(com.liferay.damascus.cli.json.fields.Long.class)
    }

    @Unroll("JSON Write Smoke test")
    def "JSON Write Smoke test"() {
        when:
        def retrivedObj = JsonUtil.getObjectFromResource(base_json_path, DamascusBase.class, JsonUtilTest.class)

        def target_file_path = workTempDir + DS + "test.json"
        JsonUtil.writer(target_file_path, retrivedObj)
        File f = new File(target_file_path);

        then:
        true == f.exists()
        false == f.isDirectory()

    }

    @Unroll("JSON Read from given path")
    def "JSON Read from given path"() {
        when:
        def retrivedObj = JsonUtil.getObjectFromResource(base_json_path, DamascusBase.class, JsonUtilTest.class)

        def target_file_path = workTempDir + DS + "test.json"
        JsonUtil.writer(target_file_path, retrivedObj)

        def serializedObj = JsonUtil.getObject(target_file_path, DamascusBase.class)

        File f = new File(target_file_path);

        then:
        true == f.exists()
        false == f.isDirectory()
        null != serializedObj;
        true == (serializedObj.getProjectName().equals("\${damascus.projectName}"))
        true == (serializedObj.getLiferayVersion().equals("\${damascus.liferayVersion}"))
        true == (serializedObj.getPackageName().equals("\${damascus.packageName}"))
        true == (serializedObj.applications.get(0).asset.getAssetTitleFieldName().equals("\${damascus.entityNameLower}TitleName"))
        true == (serializedObj.applications.get(0).asset.getAssetSummaryFieldName().equals("\${damascus.entityNameLower}SummaryName"))
        true == (serializedObj.applications.get(0).asset.getFullContentFieldName().equals("\${damascus.entityNameLower}fullContent"))
        true == (serializedObj.applications.get(0).fields.get(0).getName().equals("\${damascus.entityNameLower}Id"))
        true == (serializedObj.applications.get(0).fields.get(0).getTitle().equals("\${damascus.projectName} Id"))
        true == (serializedObj.applications.get(0).fields.get(0).getType().equals(com.liferay.damascus.cli.json.fields.Long.class.getName()))
        true == serializedObj.applications.get(0).fields.get(0).getClass().equals(com.liferay.damascus.cli.json.fields.Long.class)

    }

    @Ignore("Skip this test due to JsonProperty required only valid for constructor's parameter and currently doesn't work properly for List somehow.")
    @Unroll("No asset fields Test")
    def "No asset fields Test"() {
        when:
        def target_file_path = workTempDir + DS + DamascusProps.BASE_JSON
        def out_file_path = workTempDir + DS + "output.server.xml"
        def dmsb = TestUtils.createBaseJsonMock(projectName, liferayVersion, packageName, target_file_path)
        dmsb.applications.get(0).asset = null
        JsonUtil.writer(out_file_path, dmsb)
        def serializedObj = JsonUtil.getObject(out_file_path, DamascusBase.class)

        then:
        thrown(JsonMappingException.class)

        where:
        projectName | liferayVersion           | packageName
        "Todo"      | DamascusProps.VERSION_71 | "com.liferay.test.foo.bar"
    }
}