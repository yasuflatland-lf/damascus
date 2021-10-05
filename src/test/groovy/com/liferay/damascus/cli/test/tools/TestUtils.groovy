package com.liferay.damascus.cli.test.tools

import com.beust.jcommander.internal.Maps
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.common.JsonUtil
import com.liferay.damascus.cli.common.TemplateUtil
import com.liferay.damascus.cli.common.TemplateUtilTest
import com.liferay.damascus.cli.json.DamascusBase
import org.apache.commons.io.FileUtils
import org.apache.commons.lang3.StringUtils

import java.lang.reflect.Field
import java.lang.reflect.Modifier
import java.nio.file.Files
import java.nio.file.Paths

class TestUtils {
    /**
     * XPath get
     *
     * @param filePath
     * @return Root node object.
     */
    static public def getPath(filePath) {
        def sxml = new XmlSlurper()

        //These configurations are necessarily to get rid of error at parsing.
        sxml.setFeature("http://apache.org/xml/features/disallow-doctype-decl", false)
        sxml.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false)

        //Create dom structure object from a xml file
        return sxml.parseText(FileUtils.readFileToString(new File(filePath), "utf-8"))
    }

    /**
     * Set final static value in a class.
     *
     * example:
     * Say CREATE_TARGET_PATH is static private String field in CreateCommand class and you want to
     * replace that to "/path/for/test", then call this method as follows
     *
     * setFinalStatic(CreateCommand.class.getDeclaredField("CREATE_TARGET_PATH"), "/path/for/test");
     *
     * @param field Target field.
     * @param newValue New value to replace the field value
     * @return none
     * @throws Exception
     */
    static public def setFinalStatic(Field field, Object newValue) throws Exception {
        field.setAccessible(true);
        Field modifiersField = Field.class.getDeclaredField("modifiers");
        modifiersField.setAccessible(true);
        modifiersField.setInt(field, field.getModifiers() & ~Modifier.FINAL);
        field.set(null, newValue);
    }

    /**
     * Create object based on base.json
     *
     * @param projectName
     * @param liferayVersion
     * @param packageName
     * @param output_file_path
     * @param outputDelete
     * @return
     */
    static public def createBaseJsonMock(projectName, liferayVersion, packageName, output_file_path, outputDelete = true) {
        Map params = Maps.newHashMap()

        params.put("projectName", projectName)
        params.put("liferayVersion", liferayVersion)
        params.put("packageName", packageName)
        String entityName = projectName.replace("-", "")
        params.put("entityName", entityName)
        params.put("entityNameLower", StringUtils.lowerCase(entityName))
        Map damascus = Maps.newHashMap()
        damascus.put('damascus', params)

        //Output base.json with parameters.
        def templateUtil = new TemplateUtil()
        templateUtil.process(TemplateUtilTest.class, liferayVersion, DamascusProps.BASE_JSON, damascus, output_file_path)

        //Load into object
        def retrivedObj = JsonUtil.getObject(output_file_path, DamascusBase.class)

        if (outputDelete) {
            //Delete temporally file
            Files.deleteIfExists(Paths.get(output_file_path));
        }

        return retrivedObj
    }

    /**
     * Temporally path generator
     *
     * Depending on the environment, the path format is different.
     * This method standardize the end of path ends with delimiter.
     *
     * @return path with delimiter if it's not ended with it.
     */
    static public def getTempPath() {
        def retStr = System.getProperty("java.io.tmpdir");
        if (!retStr.endsWith(DamascusProps.DS)) {
            retStr = retStr + DamascusProps.DS;
        }
        return retStr;
    }

    /**
     * Path Map
     *
     * @param expectedProjectDirName
     * @return
     */
    static public def getPathMap(projectName, expectedProjectDirName) {
        def DS = DamascusProps.DS;
        def workspaceRootDir = TestUtils.getTempPath() + "damascustest";
        def workspaceName = "workspace"
        def workTempDir = workspaceRootDir + DS + workspaceName + DS + "modules";
        return [
                rootPath   : workTempDir + DS + projectName,
                apiPath    : workTempDir + DS + projectName + DS + expectedProjectDirName + "-api",
                servicePath: workTempDir + DS + projectName + DS + expectedProjectDirName + "-service",
                webPath    : workTempDir + DS + projectName + DS + expectedProjectDirName + "-web"
        ];
    }

}
