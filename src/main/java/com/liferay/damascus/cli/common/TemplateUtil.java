package com.liferay.damascus.cli.common;

import com.google.common.collect.*;
import com.google.common.io.*;
import freemarker.core.*;
import freemarker.template.*;
import lombok.*;
import lombok.extern.slf4j.*;
import org.apache.commons.configuration2.ex.*;
import org.apache.commons.io.*;
import org.apache.commons.io.filefilter.*;
import org.apache.commons.lang3.*;
import org.joda.time.*;

import java.io.*;
import java.net.*;
import java.nio.charset.*;
import java.security.*;
import java.util.*;
import java.util.jar.*;

/**
 * Freemarker Template Utility
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class TemplateUtil {

    private static Configuration _cfg = null;

    private static Map<String, String> _typeParams = null;

    /**
     * Constructor
     */
    protected TemplateUtil() {
    }

    /**
     * Get Instance
     *
     * @return this instance
     */
    public static TemplateUtil getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        private static final TemplateUtil INSTANCE = new TemplateUtil();
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
    private Configuration getConfiguration(Class<?> classContext, String version)
        throws IOException, URISyntaxException, TemplateException, ConfigurationException {
        //Lazy loading
        if (_cfg == null) {
            // Thread Safe. Might be costly operation in some case
            synchronized (this) {
                if (_cfg == null) {

                    // Caching templates under the cache directory.
                    cacheTemplates(
                        classContext,
                        DamascusProps.TEMPLATE_FOLDER_NAME,
                        DamascusProps.CACHE_DIR_PATH + DamascusProps.DS,
                        version
                    );

                    // You should do this ONLY ONCE in the whole application life-cycle:
                    // Create and adjust the configuration singleton
                    _cfg = new Configuration(Configuration.VERSION_2_3_25);

                    // Resource root path and initialize Freemarker configration with the path
                    _cfg.setDirectoryForTemplateLoading(getResourceRootPath(version));

                    _cfg.setDefaultEncoding("UTF-8");
                    _cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
                    _cfg.setLogTemplateExceptions(false);

                    //This is required to enable call user custom methods in a template.
                    _cfg.setSetting(Configurable.API_BUILTIN_ENABLED_KEY_CAMEL_CASE, "true");
                }
            }
        }
        return _cfg;
    }

    /**
     * Get Resource root path
     * <p>
     * If a path outside of jar is configured, use the path instead of the resource path pointing inside of jar
     *
     * @param version Lifeay version (e.g. 70)
     * @return File object pointing the resource location
     * @throws IOException            most likely when it can't access to the resource folder for some reasons.
     * @throws ConfigurationException settings.properties file manipulation error
     */
    public File getResourceRootPath(String version) throws IOException, ConfigurationException {

        //Fetch root path for resources from .damascus first.
        //Damascus uses resource in this jar if no configration is found in .damascus.
        String rootPath = PropertyUtil.getInstance().getProperty(DamascusProps.PROP_RESOURCE_ROOT_PATH);

        log.debug("getResourceRootPath : rootPath : " + rootPath);

        if (rootPath.equals("")) {
            rootPath = DamascusProps.TEMPLATE_FILE_PATH + DamascusProps.SEP + version;
            PropertyUtil.getInstance().setProperty(DamascusProps.PROP_RESOURCE_ROOT_PATH, rootPath).save();
            System.out.println(DamascusProps.PROP_RESOURCE_ROOT_PATH + " is initilized with <" + rootPath + ">");
        }

        return new File(rootPath);
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
        return StringUtils.substringBetween(templateFileName, DamascusProps.TARGET_TEMPLATE_PREFIX, DamascusProps.TARGET_TEMPLATE_SUFFIX);
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
    private void process(Configuration cfg, String templateFileName, Map params, String outputFilePath)
        throws IOException, TemplateException, URISyntaxException {

        /* Get the template (uses cache internally) */
        Template template = cfg.getTemplate(templateFileName);

        StringWriter sw  = new StringWriter();
        Environment  env = template.createProcessingEnvironment(params, sw);
        env.process();

        //Write processed template into the output file.
        String targetFilePath = outputFilePath;

        if (null == outputFilePath) {

            //Fetch output path and filename from the processed template file.
            TemplateModel filePath = env.getVariable(DamascusProps.TEMPKEY_FILEPATH);

            if (null == filePath) {

                //filePath is required if outputFilePath is null.
                StringBuffer sb = new StringBuffer();
                sb.append("Reqired values are missing in the target template. <" + templateFileName + ">" + DamascusProps.EOL);
                sb.append("File Path : <" + ((null == filePath) ? "NULL" : filePath) + ">" + DamascusProps.EOL);

                throw new InvalidParameterException(sb.toString());
            }

            targetFilePath = filePath.toString();
        }

        log.debug("TemplateUtil#process output file path <" + targetFilePath + ">");

        FileUtils.writeStringToFile(new File(targetFilePath), sw.toString(), DamascusProps.FILE_ENCODING);

    }

    /**
     * Get service.xml directory under *-service directory
     *
     * @param rootPath    the root directory of the project
     * @param projectName project name
     * @param modelName   model name
     * @return relative path to the service.xml from the root directory
     */
    public String getServiceXmlPath(String rootPath, String projectName, String modelName) {
        String DS        = DamascusProps.DS;
        String returnStr = rootPath;

        if (rootPath.endsWith(DamascusProps.DS)) {
            returnStr = StringUtils.removeEndIgnoreCase(rootPath, DamascusProps.DS);
        }

        return returnStr + DS + projectName + DS + modelName + DamascusProps.DIR_SERVICE_SUFFIX + DS + DamascusProps.SERVICE_XML;
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
        File         jarFile = new File(getClass().getProtectionDomain().getCodeSource().getLocation().getPath());
        List<String> files   = new ArrayList<>();

        if (!jarFile.isFile()) {
            return files;
        }

        JarFile jarObj = null;
        try {
            jarObj = new JarFile(jarFile);
            final Enumeration<JarEntry> entries = jarObj.entries(); //gives ALL entries in jarObj
            while (entries.hasMoreElements()) {
                final String name = entries.nextElement().getName();
                if (name.startsWith(templateRootPath + DamascusProps.SEP)) {
                    //filter according to the path
                    files.add(name);
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (null != jarObj) {
                try {
                    jarObj.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
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
     * @param distinationRoot  Distination root path to output templates. e.g. /outputs
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
            
            String      contents = Resources.toString(url, StandardCharsets.UTF_8);
            InputStream is       = new ByteArrayInputStream(contents.getBytes(StandardCharsets.UTF_8));
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
     */
    public void cacheTemplates(Class<?> clazz, String templateRootPath, String distinationRoot, String version)
        throws URISyntaxException, IOException {

        log.debug("templateRootPath<" + templateRootPath + ">");
        log.debug("distinationRoot <" + distinationRoot + ">");
        log.debug("version         <" + version + ">");
        log.debug("isInsideJar     <" + String.valueOf(isInsideJar(clazz)) + ">");

        File   distFile = new File(distinationRoot);
        String rootPath = PropertyUtil.getInstance().getProperty(DamascusProps.PROP_RESOURCE_ROOT_PATH);

        if (distFile.exists() && !rootPath.equals("")) {
            log.debug("Template folder has already existed. Skip initializing templates.");
            return;
        }

        if (isInsideJar(clazz)) {

            //Production environment
            List<String> files = getTemplateFileLists(templateRootPath);
            copyTemplatesToCache(clazz, files, distinationRoot);
        } else {

            //Test environment (non-zipped environment)
            //The way of processing directory is different from contents in a jar
            //modifying path appropriately
            String modifiedDistRoot = distinationRoot;
            if (!distinationRoot.endsWith(DamascusProps.TEMPLATE_FOLDER_NAME) &&
                !distinationRoot.endsWith(DamascusProps.TEMPLATE_FOLDER_NAME + DamascusProps.DS)) {
                modifiedDistRoot = distinationRoot +
                    ((modifiedDistRoot.endsWith(DamascusProps.DS))
                        ? DamascusProps.TEMPLATE_FOLDER_NAME
                        : DamascusProps.DS + DamascusProps.TEMPLATE_FOLDER_NAME);
            }
            copyTemplatesToCache(clazz, templateRootPath, modifiedDistRoot);
        }

        //Build destination path
        String targetPath = distinationRoot
            + (distinationRoot.endsWith(DamascusProps.DS) ? "" : DamascusProps.DS)
            + DamascusProps.TEMPLATE_FOLDER_NAME + DamascusProps.DS + version;

        //Store the path into cache
        PropertyUtil.getInstance().setProperty(
            DamascusProps.PROP_RESOURCE_ROOT_PATH,
            targetPath
        );
        
        System.out.println("Initialized Templates.");

    }
}
