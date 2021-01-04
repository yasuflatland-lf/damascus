package com.liferay.damascus.cli.common;

import com.google.common.base.Charsets;
import com.google.common.collect.Lists;
import com.google.common.io.Resources;
import com.liferay.damascus.cli.ProjectTemplatesBuilder;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.apache.commons.io.filefilter.RegexFileFilter;
import org.apache.commons.io.filefilter.TrueFileFilter;
import org.apache.commons.lang3.StringUtils;
import org.gradle.tooling.GradleConnector;
import org.gradle.tooling.ProjectConnection;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.InvalidPathException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Utility Class
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class CommonUtil {

    /**
     * Identify the OS : Windows
     *
     * @return true if this tool is on Windows system
     */
    static public boolean isWindows() {

        return (DamascusProps.OS.indexOf("win") >= 0);
    }

    /**
     * Given a {@code resourceName} that is relative to {@code contextClass}, returns a {@code URL}
     * pointing to the named resource.
     *
     * @throws IllegalArgumentException if the resource is not found
     */
    static public URL getResource(Class<?> classContext, String path) {
        String convertedPath = path.replace(DamascusProps.DS, DamascusProps.SEP);
        return Resources.getResource(classContext, convertedPath);
    }

    /**
     * Load Resource file
     *
     * @param classContext Class context of where this method is called.
     * @param path         Path to the resource file in a jar.
     * @return Path to the resource
     * @throws IOException
     */
    static protected String readResource(Class<?> classContext, String path) throws IOException {
        URL url = CommonUtil.getResource(classContext, path);
        return Resources.toString(url, Charsets.UTF_8);
    }

    /**
     * Search file recursive in child folders.
     *
     * @param root     Root folder where you search file.
     * @param filename Target file name that you are looking for.
     * @return File object of the target file.
     */
    static public File getPathFromName(File root, String filename) {
        Collection<File> files = FileUtils.listFiles(root, FileFilterUtils.nameFileFilter(filename), TrueFileFilter.INSTANCE);
        if (1 < files.size()) {
            throw new InvalidPathException(files.toString(), "Same name files were found");
        }

        Optional<File> value = files.stream().findFirst();

        if (!value.isPresent()) {
            throw new InvalidPathException(files.toString(), "The file was not found");
        }
        return value.get();
    }

    /**
     * Get Directory path
     *
     * @param file Either file or directory path
     * @return if file is given, this returns directory where the file is located. If directory given, this returns as it is.
     * @throws IOException
     */
    static public File getDirFromPath(File file) throws IOException {
        return (file.isDirectory())
                ? new File(file.getAbsolutePath())
                : new File(FilenameUtils.getFullPath(file.getAbsolutePath()));
    }

    /**
     * Get file path in the parent directories
     * <p>
     * This method search file in the parent directories.
     * </p>
     *
     * @param root     Directory / file path where the search starts.
     * @param filename Target file name to search
     * @return Absolute file path when it's found or return null.
     * @throws IOException
     */
    static public File getPathFromNameInParents(File root, String filename) throws IOException {

        File gradleFile = null;

        for (File currentDir = getDirFromPath(root); null != currentDir; currentDir = currentDir.getParentFile()) {

            Collection<File> files = FileUtils.listFiles(currentDir, null, false);
            if (0 < files.size()) {
                gradleFile = files
                        .stream()
                        .filter(file -> file.getName().equals(filename))
                        .findFirst()
                        .orElse(null);
            }

            if (null != gradleFile) {
                break;
            }
        }
        return gradleFile;
    }

    /**
     * Run Gradle task
     *
     * @param projectPath Project path where build.gradle is placed.
     * @param task        Task name, if gradle clean, task is "clean"
     */
    static public void runGradle(String projectPath, String task) throws IOException {

        //Convert path to directory if it's included file name
        File filePath = CommonUtil.getDirFromPath(new File(projectPath));

        log.debug("gradle " + task + " -- path <" + filePath.getPath() + ">");

        ProjectConnection connection = null;
        try {
            connection =
                    GradleConnector
                            .newConnector()
                            .forProjectDirectory(filePath)
                            .connect();
            connection
                    .newBuild()
                    .forTasks(task)
                    .setStandardOutput(System.out)
                    .run();
        } finally {
            if (null != connection) {
                connection.close();
            } else {
                System.out.println("Fail to run task <" + task + ">");
            }
        }
    }

    /**
     * Create workspace
     *
     * @param version        Liferay Version
     * @param destinationDir Directory path to create a workspace
     * @param name           workspace name to create
     * @throws Exception
     */
    static public void createWorkspace(String version, String destinationDir, String name) throws Exception {
        ProjectTemplatesBuilder.builder()
                .liferayVersion(version)
                .destinationDir(new File(destinationDir))
                .name(name)
                .template(DamascusProps.WORKSPACE_CMD)
                .build().create();
    }

    /**
     * Crate Workspace With Gradle Properties
     *
     * @param version        Liferay Version
     * @param destinationDir Directory path to create a workspace
     * @param name           workspace name to create
     * @throws Exception
     */
    static public void createWorkspaceWithProperties(String version, String destinationDir, String name) throws Exception {
        createWorkspace(version, destinationDir, name);

        // Original file path
        String path = DamascusProps.TEMPLATE_FILE_PATH +
                DamascusProps.DS +
                version +
                DamascusProps.DS +
                DamascusProps.GRADLE_LOCAL_PROP;

        // Distinction path
        String distPath = destinationDir +
                DamascusProps.DS +
                name +
                DamascusProps.DS +
                DamascusProps.GRADLE_LOCAL_PROP;

        // Write the gradle properties into the target workspace
        FileUtils.copyFile(
                new File(path),
                new File(distPath)
        );
    }

    /**
     * Create Service Builder Project base
     *
     * @param version        Liferay Version (7.0,7.1, etc.)
     * @param name           Project Name
     * @param packageName    Package Name
     * @param destinationDir Destination dir where the project is created.
     * @throws Exception
     */
    static public void createServiceBuilderProject(String version, String name, String packageName, String destinationDir) throws Exception {
        ProjectTemplatesBuilder.builder()
                .liferayVersion(version)
                .destinationDir(new File(destinationDir))
                .name(name)
                .packageName(packageName)
                .template(DamascusProps.SERVICE_BUILDER_CMD)
                .build().create();
    }

    /**
     * Create MVC Portlet project
     *
     * @param version        Liferay Version
     * @param name           Project Name. If it doesn't have "-web" as suffix, it's automatically added.
     * @param packageName    Package Name
     * @param destinationDir Destination dir where the project is created.
     * @throws Exception
     */
    static public void createMVCPortletProject(String version, String name, String packageName, String destinationDir) throws Exception {

        // According to DXP code standard, add "-web" as a suffix if the project name doesn't have "-web" at the end
        String projectName = name;
        if (!name.endsWith(DamascusProps.DIR_WEB_SUFFIX)) {
            projectName = name.concat(DamascusProps.DIR_WEB_SUFFIX);
        }

        String packageNameForWeb = packageName;
        if (!packageName.endsWith(".web")) {
            packageNameForWeb = packageName.concat(".web");
        }

        ProjectTemplatesBuilder.builder()
                .liferayVersion(version)
                .destinationDir(new File(destinationDir))
                .name(projectName)
                .packageName(packageNameForWeb)
                .template(DamascusProps.MVC_PORTLET_CMD)
                .build().create();

        String webPath = destinationDir + DamascusProps.DS + projectName + DamascusProps.DS;

        // Delete gradlew files of *-web directory to force to use gradlew files of parent directory instead.
        deleteUnusedGradleAssets(webPath);

        // Delete default Java source files
        deleteDefaultJavaSources(webPath);

        // Delete unused default JSPs
        deleteDefaultJsps(webPath);
    }

    /**
     * Delete unused gradle assets
     *
     * @param rootPath root path where gradlew/gradlew.bat and gradle folder placed
     */
    static public void deleteUnusedGradleAssets(String rootPath) {
        List<String> paths = new ArrayList<>(Arrays.asList(
                DamascusProps._GRADLEW_UNIX_FILE_NAME,
                DamascusProps._GRADLEW_WINDOWS_FILE_NAME,
                DamascusProps._GRADLE_FOLDER_NAME
        ));
        for (String path : paths) {
            FileUtils.deleteQuietly(new File(rootPath + path));
        }
    }

    /**
     * Delete unused default java sources
     *
     * @param path root path where src directory is located
     */
    static public void deleteDefaultJavaSources(String path) {
        File javaPath = new File(path + DamascusProps._DEFAULT_GRADLE_JAVA_PATH);
        FileUtils.deleteQuietly(javaPath);
    }

    /**
     * Delete unused default jsp files
     *
     * @param path root path where default jsp files are located.
     */
    static public void deleteDefaultJsps(String path) {
        File jspsPath = new File(path + DamascusProps._DEFAULT_GRADLE_JSP_PATH);
        FileUtils.deleteQuietly(jspsPath);
    }

    /**
     * Fetch files with filter
     * <p>
     * Only fetching files, omitting directories.
     *
     * @param rootPath Root path where starts searching
     * @param patterns Search pattern regular expression list
     * @return a List of found file's File objects
     */
    static public List<File> getTargetFiles(String rootPath, List<String> patterns) {
        String result = String.join("|", patterns);
        return FileUtils.listFiles(
                new File(rootPath),
                new RegexFileFilter("(" + result + ")"),
                TrueFileFilter.INSTANCE
        ).stream().collect(Collectors.toList());

    }

    /**
     * Replace Contents at once
     *
     * @param files    Files to be processed
     * @param patterns Replacement patterns in a map
     * @throws IOException
     */
    static public void replaceContents(List<File> files, Map<String, String> patterns) throws IOException {
        for (File file : files) {

            String fileContents = FileUtils.readFileToString(file, StandardCharsets.UTF_8);

            //Convert contents
            String converted =
                    patterns.entrySet()
                            .stream()
                            .reduce(
                                    fileContents,
                                    (s, e) -> s.replaceAll(e.getKey(), e.getValue()),
                                    (s1, s2) -> null
                            );

            FileUtils.writeStringToFile(file, converted, StandardCharsets.UTF_8);
        }
    }

    /**
     * Invert path to List
     *
     * @param path Path string (either file path or directory path is fine)
     * @return Reverse order of each directory name in a list.
     * @throws IOException
     */
    static public List<String> invertPathToList(String path) throws IOException {
        File pathTmp = getDirFromPath(new File(path));
        String separator = (isWindows()) ? "\\\\" : DamascusProps.DS;
        List<String> retList = Arrays.asList(pathTmp.getAbsolutePath().toString().split(separator));
        return Lists.reverse(retList);
    }

    /**
     * Invert path to List with size
     *
     * @param path Path string (either file path or directory path is fine)
     * @param size size of lists to return
     * @return Reverse order of each directory name in a list.
     * @throws IOException
     */
    static public List<String> invertPathWithSize(String path, int size) throws IOException {
        List<String> paths = invertPathToList(path);
        return Lists.partition(paths, size).get(0);
    }

    /**
     * Validate if this method called inside of a jar
     *
     * @param clazz Target class
     * @return true if it's in a jar or false
     */
    static public boolean isInsideJar(Class<?> clazz) {
        File path = new File(clazz.getProtectionDomain().getCodeSource().getLocation().getPath());
        return path.isFile();
    }

    /**
     * Replace keywords in contents
     *
     * @param contents
     * @param replacements
     * @return
     */
    static public String replaceKeywords(String contents, Map<String, String> replacements) {
        String converted = contents;
        for (Map.Entry<String, String> replacement : replacements.entrySet()) {
            converted =
                    StringUtils.replace(
                            converted,
                            replacement.getKey(),
                            replacement.getValue());
        }
        return converted;
    }

    /**
     * Comma separated strings to List
     *
     * @param source comma separated strings
     * @return String List
     */
    static public List<String> stringToList(String source) {

        return Arrays.asList(source.split("\\s*,\\s*"));
    }


    /**
     * Normalize path
     * <p>
     * Normalize path and add separator if the path doesn't end with a separator.
     *
     * @param path
     * @return
     */
    static public String normalizePath(String path) {
        // Normalize path
        String validatedPath = FilenameUtils.normalize(path);

        if (null == validatedPath) {
            log.error("Template file path is invalid. <" + path + ">");
            return null;
        }

        if (!validatedPath.endsWith(DamascusProps.DS)) {
            validatedPath = validatedPath.concat(DamascusProps.DS);
        }

        return validatedPath;
    }
}
