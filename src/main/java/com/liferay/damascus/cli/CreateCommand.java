package com.liferay.damascus.cli;

import com.google.common.collect.Maps;
import com.liferay.damascus.cli.common.*;
import com.liferay.damascus.cli.exception.DamascusProcessException;
import com.liferay.damascus.cli.json.Application;
import com.liferay.damascus.cli.json.DamascusBase;
import com.liferay.damascus.cli.relation.validators.RelationValidator;
import freemarker.template.TemplateException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidParameterException;
import java.util.*;

/**
 * Create command
 * <p>
 * Damascus creates service according to the base.json
 *
 * @author Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
@Slf4j
public class CreateCommand extends BaseCommand<CreateArgs> {
    private TemplateUtil _templateUtil;

    public CreateCommand() {
        _templateUtil = new TemplateUtil();
    }

    public CreateCommand(Damascus damascus) {
        super(damascus, null);
    }

    @Override
    public void execute() throws Exception {
        try {
            System.out.println("Started creating service scaffolding. Fetching base.json");

            // base.json validation
            validation(getArgs().getBaseDir() + DamascusProps.BASE_JSON);

            // Mapping base.json into an object after parsing values
            DamascusBase dmsb = JsonUtil.getObject(
                    getArgs().getBaseDir() + DamascusProps.BASE_JSON,
                    DamascusBase.class
            );

            // Get root path to the templates
            File resourceRoot = _templateUtil.getResourceRootPath(dmsb.getLiferayVersion());

            // Fetch all template file paths
            Collection<File> templatePaths = _templateUtil.getTargetTemplates(DamascusProps.TARGET_TEMPLATE_PREFIX, resourceRoot);

            String dashCaseProjectName = CaseUtil.camelCaseToDashCase(dmsb.getProjectName());

            //1. Generate skeleton of the project.
            //2. Parse service.xml
            //3. run gradle buildService
            //4. generate corresponding files from templates
            //5. run gradle buildService again.

            // Get path to the service.xml
            String serviceXmlPath = _templateUtil.getServiceXmlPath(
                    getArgs().getBaseDir(),
                    dashCaseProjectName
            );

            StringBuilder sb = new StringBuilder();
            sb.append("Generating *-api, *-service");
            if (dmsb.isWebExist()) {
                sb.append(", *-web");
            }
            sb.append(" skeletons for " + dashCaseProjectName);
            System.out.println(sb.toString());

            // Generate skeletons of the project
            generateProjectSkeleton(
                    dmsb.getLiferayVersion(),
                    dashCaseProjectName,
                    dmsb.getPackageName(),
                    getArgs().getBaseDir(),
                    dmsb.isWebExist()
            );

            System.out.println("Parsing " + serviceXmlPath);

            // Generate service.xml based on base.json configurations and overwrite existing service.xml
            generateScaffolding(dmsb, DamascusProps.SERVICE_XML, serviceXmlPath, null);

            System.out.println("Moving all modules projects into the same directory");

            // Project origin path
            String originPath = DamascusProps.CURRENT_DIR + DamascusProps.DS;
            File srcDir = new File(originPath + dashCaseProjectName);
            File distDir = new File(originPath);

            // Resolve Project Directory: move modules directories into the current directory
            resolveProjects(srcDir, distDir);

            // Resolve gradle files
            resolveGradleFiles(distDir.getAbsolutePath());

            System.out.println("Running \"gradle buildService\" to generate the service based on parsed service.xml");

            // Run "gradle buildService" to generate the skeleton of services.
            CommonUtil.runGradle(distDir.getAbsolutePath() + DamascusProps.DS + dashCaseProjectName + DamascusProps.DIR_SERVICE_SUFFIX, "buildService");

            //Parse all templates and generate scaffold files.
            for (Application app : dmsb.getApplications()) {

                System.out.print("Parsing templates");

                // Process all templates
                for (File template : templatePaths) {
                    System.out.print(".");
                    generateScaffolding(dmsb, template.getName(), null, app);
                }

                System.out.println(".");
            }

            System.out.println("Finishing up the project files format.");

            // Resolve template generated gradle files
            resolveGradleFiles(distDir.getAbsolutePath());

            // Clean up files at the end
            finalCleanupProjectFiles(DamascusProps.CURRENT_DIR);

            System.out.println("Running \"gradle buildService\" again to generate the service according to the template generated services.");

            // Run "gradle buildService" to generate the skeleton of services.
            CommonUtil.runGradle(distDir.getAbsolutePath() + DamascusProps.DS + dashCaseProjectName + DamascusProps.DIR_SERVICE_SUFFIX, "buildService");

            System.out.println("Done.");

        } catch (DamascusProcessException e) {
            // Damascus operation error
            log.error(e.getMessage());
        } catch (FileNotFoundException e) {
            log.error(e.getMessage());
        }
    }

    @Override
    public Class<CreateArgs> getArgsClass() {
        return CreateArgs.class;
    }

    /**
     * Generate Scaffolding from a template.
     *
     * @param damascusBase     Damascus object
     * @param templateFileName target template name (e.g. Portlet_XXXXLocalService.ftl)
     * @param outputFilePath   Output file path. if it's null, refers output file path from createPath in the template
     * @param app              Application object.
     * @throws IOException
     * @throws URISyntaxException
     * @throws TemplateException
     * @throws ConfigurationException settings.properties file manipulation error
     */
    private void generateScaffolding(DamascusBase damascusBase, String templateFileName, String outputFilePath, Application app)
            throws IOException, URISyntaxException, TemplateException, ConfigurationException {
        Map params = Maps.newHashMap();

        //Mapping values used in templates
        params.put(DamascusProps.BASE_DAMASCUS_OBJ, damascusBase);
        params.put(DamascusProps.BASE_TEMPLATE_UTIL_OBJ, _templateUtil);
        params.put(DamascusProps.BASE_CASE_UTIL_OBJ, CaseUtil.getInstance());
        params.put(DamascusProps.BASE_CURRENT_APPLICATION, app);
        params.put(DamascusProps.TEMPVALUE_FILEPATH, getArgs().getBaseDir());

        PropertyContext propertyContext = PropertyContextFactory.createPropertyContext();
        String author = propertyContext.getString(DamascusProps.PROP_AUTHOR);
        params.put(DamascusProps.PROP_AUTHOR.replace(".", "_"), author);

        //Parse template and output
        _templateUtil.process(
                CreateCommand.class,
                damascusBase.getLiferayVersion(),
                templateFileName,
                params,
                outputFilePath);
    }

    /**
     * Generate product skelton
     * <p>
     * Generating service and web project skeleton at once.
     *
     * @param version        Liferay Version
     * @param projectName    Project Name
     * @param packageName    Package Name
     * @param destinationDir Destination dir where the project is created.
     * @param webEnable      when it's true, *-web will be created.
     * @throws Exception
     */
    private void generateProjectSkeleton(String version, String projectName, String packageName, String destinationDir, boolean webEnable) throws Exception {

        //Generate Service (*-service, *-api) skelton
        CommonUtil.createServiceBuilderProject(
                version,
                projectName,
                packageName,
                destinationDir
        );

        if (true == webEnable) {
            //Generate Web project (*-web)
            CommonUtil.createMVCPortletProject(
                    version,
                    projectName,
                    packageName,
                    destinationDir + DamascusProps.DS + projectName
            );
        }
    }

    /**
     * Finalize Gradle Files
     *
     * @param rootPath Root path of project
     * @throws IOException
     * @throws DamascusProcessException
     */
    private void resolveGradleFiles(String rootPath) throws IOException, DamascusProcessException {

        //Fetch replacement target files
        List<String> pathPatterns = new ArrayList<>(Arrays.asList(
                DamascusProps._BUILD_GRADLE_FILE_NAME
        ));
        List<File> targetPaths = CommonUtil.getTargetFiles(rootPath, pathPatterns);

        //Configure replace strings regex pattern
        Map<String, String> patterns = new HashMap<String, String>() {
            {
                // Fix project path
                for (File path : targetPaths) {
                    List<String> pathList = CommonUtil.invertPathWithSize(
                            path.getPath(), DamascusProps._DEPTH_OF_MINIMAL_PROJECT_PATH);

                    if (pathList.size() < DamascusProps._DEPTH_OF_MINIMAL_PROJECT_PATH) {
                        throw new DamascusProcessException(
                                "Path must be larger than " + DamascusProps._DEPTH_OF_MINIMAL_PROJECT_PATH
                                        + " depth. Currently it's <" + path.getPath() + ">");
                    }

                    put("project.*:" + pathList.get(0) + "\".*", "project(\"" + CommonUtil.getModulePath(path.getAbsolutePath()) + "\")");
                }
            }
        };

        // Replace contents
        CommonUtil.replaceContents(targetPaths, patterns);
    }

    /**
     * Move Project into current.
     * <p>
     * Liferay template library doesn't allow to overwrite project file,
     * So it gets nested in this tool. This method move those nested project directory
     * into the current directory.
     *
     * @param srcDir  Source Directory
     * @param destDir Destination Directory
     * @throws IOException
     * @throws DamascusProcessException
     */
    private void resolveProjects(File srcDir, File destDir) throws IOException, DamascusProcessException {

        if (!srcDir.isDirectory()) {
            log.info("srcDir does not exist");
            return;
        } else if (!srcDir.isDirectory()) {
            log.info("srcDir is not a directory");
            return;
        }

        // Create a filter for ".gradle" and ".md" files
        FileUtils.copyDirectory(srcDir, destDir);

        // Delete old nested directory
        FileUtils.deleteDirectory(srcDir);

        //Remove unused gradlew / gradlew.bat files
        List<String> pathPatterns = new ArrayList<>(Arrays.asList(
                DamascusProps._GRADLEW_UNIX_FILE_NAME,
                DamascusProps._GRADLEW_WINDOWS_FILE_NAME,
                DamascusProps._GRADLE_SETTINGS_FILE_NAME
        ));

        List<File> deletePaths = CommonUtil.getTargetFiles(DamascusProps.CURRENT_DIR, pathPatterns);
        deletePaths.add(new File(DamascusProps.CURRENT_DIR + DamascusProps.DS + DamascusProps._BUILD_GRADLE_FILE_NAME));
        deletePaths.add(new File(DamascusProps.CURRENT_DIR + DamascusProps.DS + DamascusProps._GRADLE_FOLDER_NAME));

        for (File file : deletePaths) {
            FileUtils.deleteQuietly(file);
        }
    }

    /**
     * Clean up project files at the end of process.
     * <p>
     * For example, project root gradle related files are necessarily during the build process,
     * but they cause of errors once the all template generation process is done.
     *
     * This method cleans up the unnecessarily files at the end of building project.
     *
     * @param projectRootPath
     */
    private void finalCleanupProjectFiles(String projectRootPath) {
        List<File> deletePaths = new ArrayList<>();
        deletePaths.add(new File(projectRootPath + DamascusProps.DS + DamascusProps._BUILD_GRADLE_FILE_NAME));
        deletePaths.add(new File(projectRootPath + DamascusProps.DS + DamascusProps._GRADLE_FOLDER_NAME));
        deletePaths.add(new File(projectRootPath + DamascusProps.DS + DamascusProps._GRADLE_SETTINGS_FILE_NAME));

        for (File file : deletePaths) {
            FileUtils.deleteQuietly(file);
        }
    }

    /**
     * base.json validation
     * <p>
     * Validation checking across multiple application definitions in base.json
     *
     * @param baseJsonPath
     * @throws IOException
     */
    public void validation(String baseJsonPath) throws IOException {
        String baseJson = FileUtils.readFileToString(new File(baseJsonPath), StandardCharsets.UTF_8);
        RelationValidator relationValidator = new RelationValidator();
        if (!relationValidator.check(baseJson)) {
            throw new InvalidParameterException("Validation mapping error");
        }
    }

    /**
     * Base.json directory path
     *
     * @return Base.json directory path
     */
    public String getBaseDir() {
        return getArgs().getBaseDir();
    }

}
