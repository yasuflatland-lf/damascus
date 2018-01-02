package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.liferay.damascus.cli.common.CaseUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.common.TemplateUtil;
import com.liferay.damascus.cli.validators.PackageNameValidator;
import com.liferay.damascus.cli.validators.ProjectNameValidator;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Initialize Damascus
 * <p>
 * Damascus will create the base configuration called base.json.
 * All Service builder portlet configuration are described in the file.
 *
 * @author Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
@Slf4j
@Data
public class InitCommand implements ICommand {

    public InitCommand() {
    }

    /**
     * Judge if Init is runnable
     *
     * @return true if it's runnable or false
     */
    public boolean isRunnable(Damascus damascus) {

        return ((null != getProjectName()) && (null != getPackageName()));
    }

    /**
     * Invoke actual command
     *
     * @param damascus
     * @param args
     */
    public void run(Damascus damascus, String... args) {
        try {
            System.out.println("Creating base.json");

            //Parse template and output
            TemplateUtil.getInstance()
                .process(
                    InitCommand.class,
                    damascus.getLiferayVersion(),
                    DamascusProps.BASE_JSON,
                    getParameters(damascus),
                    getTargetDir()
                );

            System.out.println("Done.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Target directory
     *
     * @return Target directory where the output file is generated.
     */
    private String getTargetDir() {
        StringBuilder targetDir = new StringBuilder();
        targetDir.append(DamascusProps.CURRENT_DIR);
        if (!targetDir.toString().endsWith(DamascusProps.DS)) {
            targetDir.append(DamascusProps.DS);
        }

        String projectDirectoryName = CaseUtil.camelCaseToDashCase(getProjectName());

        return targetDir
            .append(projectDirectoryName)
            .append(DamascusProps.DS)
            .append(DamascusProps.BASE_JSON)
            .toString();
    }

    /**
     * Gather Parameters for a template parsing
     *
     * @param damascus
     * @return Map with required parameters to parse base.json
     */
    private Map getParameters(Damascus damascus) {
        Map params = new ConcurrentHashMap<>();

        //Set parameters
        params.put(DamascusProps.BASE_PROJECT_NAME, getProjectName());
        params.put(DamascusProps.BASE_LIFERAY_VERSION, damascus.getLiferayVersion());
        params.put(DamascusProps.BASE_PACKAGE_NAME, getPackageName());

        String entityName = getProjectName().replace("-", "");
        params.put(DamascusProps.BASE_ENTITY_NAME, entityName);
        params.put(DamascusProps.BASE_ENTITY_NAME_LOWER, StringUtils.lowerCase(entityName));

        Map damascusMap = com.beust.jcommander.internal.Maps.newHashMap();
        damascusMap.put(DamascusProps.BASE_DAMASCUS_OBJ, params);

        return damascusMap;
    }

    @Parameter(names = "-init", description = "Create damascus base file. -init (project name) ", validateWith = ProjectNameValidator.class)
    private String projectName = null;

    @Parameter(names = "-p", description = "Package name. (e.g. com.liferay.test)", validateWith = PackageNameValidator.class)
    private String packageName = null;

}
