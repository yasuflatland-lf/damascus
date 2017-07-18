package com.liferay.damascus.cli.common;

/**
 * Properties class
 *
 * @author Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
public class DamascusProps {
    public static final String EOL = System.getProperty("line.separator");

    public static final String DS = System.getProperty("file.separator");

    public static final String OS = System.getProperty("os.name").toLowerCase();

    public static final String USER_HOME = System.getProperty("user.home");

    public static final String CURRENT_DIR = System.getProperty("user.dir");

    public static final String TMP_PATH = System.getProperty("java.io.tmpdir");

    public static final String FILE_ENCODING = "UTF-8";

    public static final String USER_NAME = System.getProperty("user.name");
    
    public static final String SEP = "/";

    public static final String TEMPLATE_FOLDER_NAME = "templates";

    public static final String BASE_JSON = "base.json";

    public static final String BASE_XML = "base.xml";

    public static final String BASE_XSD = "damascus.xsd";

    public static final String SERVICE_XML = "service.xml";

    /**
     * Base json parse parameters
     */
    public static final String BASE_DAMASCUS_OBJ = "damascus";

    public static final String BASE_TEMPLATE_UTIL_OBJ = "templateUtil";
    
    public static final String BASE_CASE_UTIL_OBJ = "caseUtil";

    public static final String BASE_CURRENT_APPLICATION = "application";

    public static final String BASE_PROJECT_NAME = "projectName";

    public static final String BASE_LIFERAY_VERSION = "liferayVersion";

    public static final String BASE_PACKAGE_NAME = "packageName";

    public static final String BASE_PROJECT_NAME_LOWER = "projectNameLower";

    /**
     * Property file configuration
     */
    public static final String CACHE_DIR_PATH = DamascusProps.USER_HOME + DamascusProps.DS + ".damascus";

    public static final String PROPERTY_FILE_NAME = "settings.properties";

    public static final String PROPERTY_FILE_PATH = CACHE_DIR_PATH + DamascusProps.DS + PROPERTY_FILE_NAME;

	public static final String TEMPLATE_FILE_PATH = CACHE_DIR_PATH + DamascusProps.DS + TEMPLATE_FOLDER_NAME;

    /**
     * Liferay Version
     */
    public static final String VERSION_70 = "70";

    /**
     * Service Builder command
     */
    public static final String SERVICE_BUILDER_CMD = "service-builder";

    public static final String MVC_PORTLET_CMD = "mvc-portlet";

    public static final String WORKSPACE_CMD = "workspace";

    /**
     * Template prefix and Suffix
     */
    public static final String TARGET_TEMPLATE_PREFIX = "Portlet_";

    public static final String TARGET_TEMPLATE_SUFFIX = ".ftl";

    /**
     * Target path for a output file.
     */
    public static final String TEMPKEY_FILEPATH = "createPath";

    public static final String TEMPKEY_SKIP_TEMPLATE = "skipTemplate";
    
    public static final String TEMPVALUE_FILEPATH = "createPath_val";

    public static final String TEMPVALUE_BOOLEAN = "boolean";

    public static final String TEMPVALUE_DATE = "Date";

    public static final String TEMPVALUE_DATETIME = "Date";

    public static final String TEMPVALUE_DOCUMENT = "long";

    public static final String TEMPVALUE_DOCUMENT_LIBRARY = "String";

    public static final String TEMPVALUE_DOUBLE = "double";

    public static final String TEMPVALUE_INTEGER = "int";

    public static final String TEMPVALUE_LONG = "long";

    public static final String TEMPVALUE_RICHTEXT = "String";

    public static final String TEMPVALUE_TEXT = "String";

    public static final String TEMPVALUE_VARCHR = "String";

    /**
     * Functions in templates
     */
    public static final String TEMPFUNC_TRANSLATE_FIELD_TYPE = "TranslateFieldType";

    /**
     * Properties
     */
    public static final String PROP_AUTHOR = "damascus.author";

    public static final String PROP_RESOURCE_ROOT_PATH = "damascus.resource.root.path";

    public static final String PROP_BUILD_NUMBER = "damascus.build.number";
    
    /**
     * Service Builder directory structure suffix
     */
    public static final String DIR_SERVICE_SUFFIX = "-service";

    public static final String DIR_API_SUFFIX = "-api";

    public static final String DIR_WEB_SUFFIX = "-web";

    public static final String _GRADLEW_UNIX_FILE_NAME = "gradlew";

    public static final String _GRADLEW_WINDOWS_FILE_NAME = "gradlew.bat";

}
