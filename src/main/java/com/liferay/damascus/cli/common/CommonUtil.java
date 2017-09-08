package com.liferay.damascus.cli.common;

import com.google.common.base.Charsets;
import com.google.common.io.*;
import com.liferay.damascus.cli.*;
import lombok.extern.slf4j.*;
import org.apache.commons.io.*;
import org.apache.commons.io.filefilter.*;
import org.gradle.tooling.*;

import java.io.*;
import java.net.*;
import java.nio.charset.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.*;

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
        return files.stream().findFirst().get();
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
            connection.newBuild().forTasks(task).run();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (null != connection) {
                connection.close();
            }
        }
    }

    /**
     * Create workspace
     *
     * @param destinationDir Directory path to create a workspace
     * @param name           workspace name to create
     * @throws Exception
     */
    static public void createWorkspace(String destinationDir, String name) throws Exception {
        ProjectTemplatesBuilder.builder()
                               .destinationDir(new File(destinationDir))
                               .name(name)
                               .template(DamascusProps.WORKSPACE_CMD)
                               .build().create();
    }

    /**
     * Create Service Builder Project base
     *
     * @param name           Project Name
     * @param packageName    Package Name
     * @param destinationDir Destination dir where the project is created.
     * @throws Exception
     */
    static public void createServiceBuilderProject(String name, String packageName, String destinationDir) throws Exception {
        ProjectTemplatesBuilder.builder()
                               .destinationDir(new File(destinationDir))
                               .name(name)
                               .packageName(packageName)
                               .template(DamascusProps.SERVICE_BUILDER_CMD)
                               .build().create();
    }

    /**
     * Create MVC Portlet project
     *
     * @param name           Project Name. If it doesn't have "-web" as suffix, it's automatically added.
     * @param packageName    Package Name
     * @param destinationDir Destination dir where the project is created.
     * @throws Exception
     */
    static public void createMVCPortletProject(String name, String packageName, String destinationDir) throws Exception {

        // According to DXP code standard, add "-web" as a suffix if the project name doesn't have "-web" at the end
        String projectName = name;
        if (!name.endsWith("-web")) {
            projectName = name.concat("-web");
        }

        String packageNameForWeb = packageName;
        if (!packageName.endsWith(".web")) {
            packageNameForWeb = packageName.concat(".web");
        }

        ProjectTemplatesBuilder.builder()
                               .destinationDir(new File(destinationDir))
                               .name(projectName)
                               .packageName(packageNameForWeb)
                               .template(DamascusProps.MVC_PORTLET_CMD)
                               .build().create();

        String webPath = destinationDir + DamascusProps.DS + projectName + DamascusProps.DS;

        // Delete gradlew files of *-web directory to force to use gradlew files of parent directory instead.
        deleteGradlews(webPath);

        // Delete default Java source files
        deleteDefaultJavaSources(webPath);

        // Delete unused default JSPs
        deleteDefaultJsps(webPath);
    }

    /**
     * Delete gradlews
     *
     * @param path root path where gradlew/gradlew.bat placed
     */
    static public void deleteGradlews(String path) {
        File gradlewPath    = new File(path + DamascusProps._GRADLEW_UNIX_FILE_NAME);
        File gradlewBatPath = new File(path + DamascusProps._GRADLEW_WINDOWS_FILE_NAME);
        FileUtils.deleteQuietly(gradlewPath);
        FileUtils.deleteQuietly(gradlewBatPath);
    }

    /**
     * Delete unused default java sources
     *
     * @param path root path where src directory is located
     */
    static public void deleteDefaultJavaSources(String path) {
        File javaPath = new File(path + "/src/main/java");
        FileUtils.deleteQuietly(javaPath);
    }

    /**
     * Delete unused default jsp files
     *
     * @param path root path where default jsp files are located.
     */
    static public void deleteDefaultJsps(String path) {
        File jspsPath = new File(path + "/src/main/resources/META-INF/resources");
        FileUtils.deleteQuietly(jspsPath);
    }

    /**
     * Fetch files with filter
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
     * @param files Files to be processed
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
}
