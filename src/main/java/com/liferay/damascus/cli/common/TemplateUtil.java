package com.liferay.damascus.cli.common;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.InvalidParameterException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.io.filefilter.IOFileFilter;
import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Maps;
import com.google.common.io.Resources;
import com.liferay.damascus.antlr.generator.TagsCleanup;
import com.liferay.damascus.cli.Damascus;

import freemarker.core.Configurable;
import freemarker.core.Environment;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateBooleanModel;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.TemplateModel;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;

/**
 * Freemarker Template Utility
 *
 * @author Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
@Slf4j
public class TemplateUtil {

    private Configuration _cfg = null;

    private Map<String, String> _typeParams = null;

    private PropertyContext _propertyContext = null;

    /**
     * Constructor
     */
    public TemplateUtil() {
    }

    /**
     * Get Property Contest
     *
     * @return PropertyContext
     * @throws IOException
     * @throws ConfigurationException
     */
    protected PropertyContext getPropertyContext()
        throws IOException, ConfigurationException {

        if (null != _propertyContext) {
            return _propertyContext;
        }

        _propertyContext = PropertyContextFactory.createPropertyContext();

        return _propertyContext;
    }

    /**
     * Get Configuration for template.
     *
     * @param classContext class context where it's called. Set a class where this method is called
     * @param version      Liferay version.
     * @return Configuration object for freemarker template
     * @throws IOException            When the directory where templates couldn't be created
     * @throws URISyntaxException     When the directory where templates couldn't be created
     * @throws ConfigurationException settings.properties file manipulation error
     */
    protected Configuration getConfiguration(Class<?> classContext, String version)
        throws IOException, URISyntaxException, TemplateException, ConfigurationException {

        if (_cfg != null) {
            return _cfg;
        }

        // Caching templates under the cache directory.
        cacheTemplates(
            classContext,
            DamascusProps.TEMPLATE_FOLDER_NAME,
            DamascusProps.CACHE_DIR_PATH + DamascusProps.DS,
            version
        );

        // You should do this ONLY ONCE in the whole application lifecycle:
        // Create and adjust the configuration singleton
        _cfg = new Configuration(Configuration.VERSION_2_3_30);

        // Resource root path and initialize Freemarker configuration with the path
        File resourceRootPath = getResourceRootPath(version);
        _cfg.setDirectoryForTemplateLoading(resourceRootPath);
        log.debug("resourceRootPath : " + resourceRootPath.toString());

        _cfg.setDefaultEncoding("UTF-8");
        _cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        _cfg.setLogTemplateExceptions(false);

        //This is required to enable call user custom methods in a template.
        _cfg.setSetting(Configurable.API_BUILTIN_ENABLED_KEY_CAMEL_CASE, "true");

        return _cfg;
    }

    /**
     * Get Resource root path
     * <p>
     * If a path outside of jar is configured, use the path instead of the resource path pointing inside of jar
     *
     * @param version Liferay version (e.g. 7.0)
     * @return File object pointing the resource location
     * @throws IOException            most likely when it can't access to the resource folder for some reasons.
     * @throws ConfigurationException settings.properties file manipulation error
     */
    public File getResourceRootPath(String version) throws IOException, ConfigurationException {

        PropertyContext propertyContext = getPropertyContext();

        //Fetch root path for resources from .damascus first.
        //Damascus uses resource in this jar if no configuration is found in .damascus.
        String rootPath = propertyContext.getString(DamascusProps.PROP_RESOURCE_ROOT_PATH);
        String defaultTemplatePath = DamascusProps.TEMPLATE_FILE_PATH + DamascusProps.SEP + version;

        if(log.isDebugEnabled()) {
            log.debug("getResourceRootPath : rootPath            : " + rootPath);
            log.debug("getResourceRootPath : defaultTemplatePath : " + defaultTemplatePath);
        }

        if (rootPath.equals("")) {

            propertyContext.setProperty(DamascusProps.PROP_RESOURCE_ROOT_PATH, defaultTemplatePath);
            propertyContext.save();

            System.out.println(DamascusProps.PROP_RESOURCE_ROOT_PATH + " is initilized with <" + defaultTemplatePath + ">");
        }

        return new File(defaultTemplatePath);
    }

    /**
     * Get file list of target templates
     *
     * @param prefix prefix of the target files.
     * @param root   directory path to find files at
     * @return A list of files if find some or returns empty list.
     * @throws IOException
     */
    public Collection<File> getTargetTemplates(String prefix, File root) throws IOException {
        //Get Directory
        File targetDir = CommonUtil.getDirFromPath(root);

        //Set the prefix pattern
        IOFileFilter prefixFilter = FileFilterUtils.prefixFileFilter(prefix);

        Collection<File> files = FileUtils.listFiles(targetDir, prefixFilter, null);

        if (0 == files.size()) {
            throw new FileNotFoundException("There no files found for prefix <" + prefix + ">");
        }

        return files;
    }

    /**
     * Get Output filename from Template name
     *
     * @param templateFileName Original template name
     * @return Output filename
     */
    public String getOutputFilename(String templateFileName) {
        return StringUtils.substringBetween(
            templateFileName,
            DamascusProps.TARGET_TEMPLATE_PREFIX,
            DamascusProps.TARGET_TEMPLATE_SUFFIX
        );
    }

    /**
     * Process Template
     * <p>
     * This method will fetch templates from resources and
     * create output file according to the value in the template file.
     *
     * @param classContext     Class Context of where to fetch resources.
     * @param liferayVersion   Liferay version. (e.g. 70)
     * @param templateFileName Template file name (e.g. base.json)
     * @param params           Parameters to parse template.
     * @throws IOException        Any causes while processing files
     * @throws TemplateException  Template processing error
     * @throws URISyntaxException Freemarker configuration initialize error
     */
    public void process(Class<?> classContext, String liferayVersion, String templateFileName, Map params)
        throws IOException, TemplateException, URISyntaxException, ConfigurationException {

        Configuration cfg = getConfiguration(classContext, liferayVersion);
        process(cfg, templateFileName, params, null);
    }

    /**
     * Process Template
     * <p>
     * This method will fetch templates from resources and
     * create output file according to given output filepath (outputFilePath)
     *
     * @param classContext     Class Context of where to fetch resources.
     * @param liferayVersion   Liferay version. (e.g. 70)
     * @param templateFileName Template file name (e.g. base.json)
     * @param params           Parameters to parse template.
     * @param outputFilePath   Output file path. if it's null, refers output file path from createPath in the template
     * @throws IOException            Any causes while processing files
     * @throws TemplateException      Template processing error
     * @throws URISyntaxException     Freemarker configuration initialize error
     * @throws ConfigurationException settings.properties file manipulation error
     */
    public void process(Class<?> classContext, String liferayVersion, String templateFileName, Map params, String outputFilePath)
        throws IOException, TemplateException, URISyntaxException, ConfigurationException {

        Configuration cfg = getConfiguration(classContext, liferayVersion);
        process(cfg, templateFileName, params, outputFilePath);
    }

    /**
     * Process Template
     *
     * @param cfg              Configuration for Freemarker
     * @param templateFileName Template file name (e.g. base.json)
     * @param params           Parameters to parse template.
     * @param outputFilePath   Output file path. if it's null, refers output file path from createPath in the template
     * @throws IOException        Any causes while processing files
     * @throws TemplateException  Template processing error
     * @throws URISyntaxException Freemarker configuration initialize error
     */
    protected void process(Configuration cfg, String templateFileName, Map params, String outputFilePath)
        throws IOException, TemplateException, URISyntaxException {

        /* Get the template (uses cache internally) */
        Template template = cfg.getTemplate(templateFileName);

        StringWriter sw = new StringWriter();
        Environment env = template.createProcessingEnvironment(params, sw);

        // Process a template
        env.process();

        //Write processed template into the output file.
        String targetFilePath = outputFilePath;

        if (null == outputFilePath) {

            //Fetch output path and filename from the processed template file.
            TemplateModel filePath = env.getVariable(DamascusProps.TEMPKEY_FILEPATH);

            if (null == filePath) {

                //filePath is required if outputFilePath is null.
                String errorMessage = "Required values are missing in the target template <" + templateFileName + ">" + DamascusProps.EOL;

                throw new InvalidParameterException(errorMessage);
            }

            targetFilePath = filePath.toString();
        }

        TemplateBooleanModel skipTemplate = (TemplateBooleanModel) env.getVariable(DamascusProps.TEMPKEY_SKIP_TEMPLATE);

        if (skipTemplate != null && skipTemplate.getAsBoolean()) {

            log.debug("skip file path <" + targetFilePath + ">");

            return;
        }

        log.debug("output file path <" + targetFilePath + ">");

        FileUtils.writeStringToFile(new File(targetFilePath), sw.toString(), DamascusProps.FILE_ENCODING);

    }

    /**
     * Get service.xml directory under *-service directory
     *
     * @param rootPath            the root directory of the project
     * @param dashCaseProjectName project name
     * @return relative path to the service.xml from the root directory
     */
    public String getServiceXmlPath(String rootPath, String dashCaseProjectName) {
        String DS = DamascusProps.DS;
        String returnStr = rootPath;

        if (rootPath.endsWith(DamascusProps.DS)) {
            returnStr = StringUtils.removeEndIgnoreCase(rootPath, DamascusProps.DS);
        }

        return returnStr + DS + dashCaseProjectName + DS + dashCaseProjectName + DamascusProps.DIR_SERVICE_SUFFIX + DS + DamascusProps.SERVICE_XML;
    }

    /**
     * Type parameter
     *
     * @return type parameter list
     */
    public Map<String, String> getTypeParameter() {

        if (null != _typeParams) {
            //Return cache if it's already initialized.
            return _typeParams;
        }

        _typeParams = Maps.newHashMap();

        _typeParams.put(com.liferay.damascus.cli.json.fields.Boolean.class.getName(), DamascusProps.TEMPVALUE_BOOLEAN);
        _typeParams.put(com.liferay.damascus.cli.json.fields.Date.class.getName(), DamascusProps.TEMPVALUE_DATE);
        _typeParams.put(com.liferay.damascus.cli.json.fields.DateTime.class.getName(), DamascusProps.TEMPVALUE_DATETIME);
        _typeParams.put(com.liferay.damascus.cli.json.fields.DocumentLibrary.class.getName(), DamascusProps.TEMPVALUE_DOCUMENT_LIBRARY);
        _typeParams.put(com.liferay.damascus.cli.json.fields.Double.class.getName(), DamascusProps.TEMPVALUE_DOUBLE);
        _typeParams.put(com.liferay.damascus.cli.json.fields.Integer.class.getName(), DamascusProps.TEMPVALUE_INTEGER);
        _typeParams.put(com.liferay.damascus.cli.json.fields.Long.class.getName(), DamascusProps.TEMPVALUE_LONG);
        _typeParams.put(com.liferay.damascus.cli.json.fields.RichText.class.getName(), DamascusProps.TEMPVALUE_RICHTEXT);
        _typeParams.put(com.liferay.damascus.cli.json.fields.Text.class.getName(), DamascusProps.TEMPVALUE_TEXT);
        _typeParams.put(com.liferay.damascus.cli.json.fields.Varchar.class.getName(), DamascusProps.TEMPVALUE_VARCHR);

        return _typeParams;
    }

    /**
     * Type parameter
     *
     * @param key Key for a type class
     * @return Class name (e.g. com.liferay.damascus.cli.json.fields.Long)
     */
    public String getTypeParameter(@NonNull String key) {
        if (!getTypeParameter().containsKey(key)) {
            throw new IndexOutOfBoundsException("No corresponding key was found <" + key + ">");
        }

        return getTypeParameter().get(key);
    }

    /**
     * Get Template file list
     *
     * @param templateRootPath
     * @return template file lists
     */
    public List<String> getTemplateFileLists(String templateRootPath) {
        File jarFile = new File(getClass().getProtectionDomain().getCodeSource().getLocation().getPath());
        List<String> files = new ArrayList<>();

        if (!jarFile.isFile()) {
            return files;
        }

        try (JarFile jarObj = new JarFile(jarFile);) {

            final Enumeration<JarEntry> entries = jarObj.entries(); //gives ALL entries in jarObj
            while (entries.hasMoreElements()) {
                final String name = entries.nextElement().getName();
                if (name.startsWith(templateRootPath + DamascusProps.SEP)) {
                    //filter according to the path
                    files.add(name);
                }
            }

        } catch (IOException e) {
            log.error(e.getLocalizedMessage());
        }

        return files;
    }

    /**
     * Validate if this method called inside of a jar
     *
     * @param clazz Target class
     * @return true if it's in a jar or false
     */
    public boolean isInsideJar(Class<?> clazz) {
        File path = new File(clazz.getProtectionDomain().getCodeSource().getLocation().getPath());
        return path.isFile();
    }

    /**
     * Copy Templates to Cache
     * <p>
     * This method copy the template directory to the cache directory including all files underneath.
     *
     * @param clazz            target class
     * @param templateRootPath Template root path. e.g. /templates
     * @param distinationRoot  Destination root path to output templates. e.g. /outputs
     * @throws URISyntaxException
     * @throws IOException
     */
    public void copyTemplatesToCache(Class<?> clazz, String templateRootPath, String distinationRoot)
        throws URISyntaxException, IOException {

        String resourcePath = templateRootPath;
        if (!templateRootPath.startsWith(DamascusProps.DS)) {
            resourcePath = DamascusProps.DS + templateRootPath;
        }

        log.debug("copy from <" + resourcePath + "> to <" + distinationRoot + ">");

        URL url = CommonUtil.getResource(clazz, resourcePath);
        FileUtils.copyDirectory(new File(url.toURI()), new File(distinationRoot));
    }

    /**
     * Validate strip tags switch
     *
     * @return boolean
     */
    public boolean isStripTags() {
        try {
            PropertyContext propertyContext = getPropertyContext();
            String stripTags = propertyContext.getString(DamascusProps.PROP_DAMASCUS_OUTPUT_TEMPLATE_STRIP_TAGS);
            Boolean isStripTags = Boolean.valueOf(stripTags);

            return isStripTags;

        } catch (ConfigurationException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Copy Templates to Cache (In a jar)
     * <p>
     * This method copy the template files to the cache directory.
     *
     * @param clazz           target class
     * @param files           template file path list
     * @param distinationRoot Destination root path to output templates. e.g. /outputs
     * @throws IOException
     */
    public void copyTemplatesToCache(Class<?> clazz, List<String> files, String distinationRoot)
        throws IOException, URISyntaxException {

        for (String file : files) {

            if (file.endsWith(DamascusProps.SEP)) {
                //This is directory
                continue;
            }

            // Generalize file path
            String resourcePath = file;
            if (!file.startsWith(DamascusProps.SEP)) {
                resourcePath = DamascusProps.SEP + file;
            }

            URL url = CommonUtil.getResource(clazz, resourcePath);

            //If it's directory, skip to next.
            if (url.getProtocol().equals("file")) {
                if ((new File(url.getPath()).isDirectory())) {
                    continue;
                }
            }

            log.debug("copy file : " + url.toURI().toString());

            String contents = Resources.toString(url, StandardCharsets.UTF_8);

            if (isStripTags()) {
                contents = TagsCleanup.process(contents);
            }

            InputStream is = new ByteArrayInputStream(contents.getBytes(StandardCharsets.UTF_8));
            FileUtils.copyInputStreamToFile(is, new File(distinationRoot + file));
        }
    }

    /**
     * Initialize Template files
     * <p>
     * If no templates are found in a cache directory, store all templates in the cache directory.
     *
     * @param clazz            target class
     * @param templateRootPath template root path
     * @param distinationRoot  Destination root path to output templates. e.g. /outputs
     * @throws URISyntaxException
     * @throws IOException
     * @throws ConfigurationException
     */
    public void cacheTemplates(Class<?> clazz, String templateRootPath, String distinationRoot, String version)
        throws URISyntaxException, IOException, ConfigurationException {

        if (log.isDebugEnabled()) {
            log.debug("templateRootPath<" + templateRootPath + ">");
            log.debug("distinationRoot <" + distinationRoot + ">");
            log.debug("version         <" + version + ">");
            log.debug("isInsideJar     <" + String.valueOf(isInsideJar(clazz)) + ">");
        }

        File distFile = new File(distinationRoot);
        PropertyContext propertyContext = getPropertyContext();
        String rootPath = propertyContext.getString(DamascusProps.PROP_RESOURCE_ROOT_PATH);

        boolean insideJar = isInsideJar(clazz);

        String buildNumber = getBuildNumber(clazz, insideJar);
        String cacheBuildNumber = propertyContext.getString(DamascusProps.PROP_BUILD_NUMBER);

        if (distFile.exists() &&
            !rootPath.equals("") &&
            buildNumber.equals(cacheBuildNumber)) {

            log.debug("Template folder is already up-to-date. Skip initializing templates.");
            return;
        }

        if (insideJar) {
            log.debug("PRODUCTION environment template initialization");

            //Production environment
            List<String> files = getTemplateFileLists(templateRootPath);
            copyTemplatesToCache(clazz, files, distinationRoot);
        } else {

            log.debug("TEST environment template initialization");

            //Test environment (non-zipped environment)
            //The way of processing directory is different from contents in a jar
            //modifying path appropriately
            String modifiedDistRoot = CommonUtil.normalizePath(distinationRoot);

            if (!modifiedDistRoot.endsWith(DamascusProps.TEMPLATE_FOLDER_NAME + DamascusProps.DS)) {
                modifiedDistRoot += DamascusProps.TEMPLATE_FOLDER_NAME + DamascusProps.DS;
            }

            log.debug("templateRootPath : " + templateRootPath);
            log.debug("modifiedDistRoot : " + modifiedDistRoot);
            copyTemplatesToCache(clazz, templateRootPath, modifiedDistRoot);
        }

        //Build destination path
        String targetPath = distinationRoot
            + (distinationRoot.endsWith(DamascusProps.DS) ? "" : DamascusProps.DS)
            + DamascusProps.TEMPLATE_FOLDER_NAME + DamascusProps.DS + version;

        //Store the path into cache
        propertyContext.setProperty(
            DamascusProps.PROP_RESOURCE_ROOT_PATH,
            targetPath
        );

        //Store the build number into cache
        propertyContext.setProperty(
            DamascusProps.PROP_BUILD_NUMBER,
            buildNumber
        );

        propertyContext.save();

        System.out.println("Templates have been initialized.");

    }

    /**
     * Get Build number
     *
     * @param clazz     Class context
     * @param insideJar true if it's inside of a jar or false
     * @return Build number
     */
    protected String getBuildNumber(Class<?> clazz, boolean insideJar) {

        StringBuilder buildNumber = new StringBuilder(25);

        // Add version part of build number

        buildNumber.append("V").append(Damascus.VERSION);

        // Add timestamp part of build number

        Date timestamp;

        if (insideJar) {
            File jarFile = new File(clazz.getProtectionDomain().getCodeSource().getLocation().getPath());
            timestamp = new Date(jarFile.lastModified());
        } else {
            timestamp = new Date();
        }

        SimpleDateFormat timestampDateFormat = new SimpleDateFormat("yyyyMMddhhmmss");

        buildNumber.append("TS").append(timestampDateFormat.format(timestamp));

        return buildNumber.toString();
    }

    /**
     * Clear Template instances
     */
    public void clear() {
        _cfg = null;
        _typeParams = null;
        _propertyContext = null;
    }
}
