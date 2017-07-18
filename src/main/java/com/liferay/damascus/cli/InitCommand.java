package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.google.common.collect.Maps;
import com.liferay.damascus.cli.common.CaseUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.common.TemplateUtil;
import com.liferay.damascus.cli.validators.PackageNameValidator;
import com.liferay.damascus.cli.validators.ProjectNameValidator;
import com.liferay.damascus.cli.validators.VersionValidator;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import java.util.Map;

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
    public boolean isRunnable() {
        return ((null != projectName) && (null != packageName));
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
                    getLiferayVersion(),
                    DamascusProps.BASE_JSON,
                    getParameters(),
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
    	if(!targetDir.toString().endsWith(DamascusProps.DS)) {
    		targetDir.append(DamascusProps.DS);
    	}
        
    	String projectDirectoryName = CaseUtil.getInstance().camelCaseToDashCase(getProjectName());
        
		return targetDir
        		.append(projectDirectoryName)
        		.append(DamascusProps.DS)
        		.append(DamascusProps.BASE_JSON)
        		.toString();
    }

    /**
     * Gather Parameters for a template parsing
     *
     * @return Map with required parameters to parse base.json
     */
    private Map getParameters() {
        Map params = Maps.newHashMap();

        //Set parameters
        params.put(DamascusProps.BASE_PROJECT_NAME, getProjectName());
        params.put(DamascusProps.BASE_LIFERAY_VERSION, getLiferayVersion());
        params.put(DamascusProps.BASE_PACKAGE_NAME, getPackageName());
        params.put(DamascusProps.BASE_PROJECT_NAME_LOWER, StringUtils.lowerCase(getProjectName()));
        Map damascus = com.beust.jcommander.internal.Maps.newHashMap();
        damascus.put(DamascusProps.BASE_DAMASCUS_OBJ, params);

        return damascus;
    }

    @Parameter(names = "-init", description = "Create damascus base file. -init (project name) ", validateWith = ProjectNameValidator.class)
    private String projectName = null;

    @Parameter(names = "-p", description = "Package name. (e.g. com.liferay.test)", validateWith = PackageNameValidator.class)
    private String packageName = null;

    @Parameter(names = "-v", description = "Target Liferay Version. (e.g. 70)", validateWith = VersionValidator.class)
    private String liferayVersion = DamascusProps.VERSION_70;

}
