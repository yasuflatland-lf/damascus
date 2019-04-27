package com.liferay.damascus.cli;

import com.liferay.damascus.cli.common.CaseUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.common.TemplateUtil;
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
public class InitCommand extends BaseCommand<InitArgs> {
    public InitCommand() {
    }

    public InitCommand(Damascus damascus) {
        super(damascus, null);
    }

    @Override
    public void execute() throws Exception {
        System.out.println("Creating base.json");
        Damascus damascus = getDamascus();
        InitArgs args = getArgs();

        //Parse template and output
        TemplateUtil.getInstance()
            .process(
                InitCommand.class,
                args.getLiferayVersion(),
                DamascusProps.BASE_JSON,
                getParameters(damascus),
                getTargetDir()
            );

        System.out.println("Done.");
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

        String projectDirectoryName = CaseUtil.camelCaseToDashCase(getArgs().getProjectName());

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
        InitArgs args = getArgs();

        //Set parameters
        params.put(DamascusProps.BASE_PROJECT_NAME, getArgs().getProjectName());
        params.put(DamascusProps.BASE_LIFERAY_VERSION, args.getLiferayVersion());
        params.put(DamascusProps.BASE_PACKAGE_NAME, getArgs().getPackageName());

        String entityName = getArgs().getProjectName().replace("-", "");
        params.put(DamascusProps.BASE_ENTITY_NAME, entityName);
        params.put(DamascusProps.BASE_ENTITY_NAME_LOWER, StringUtils.lowerCase(entityName));

        Map damascusMap = com.beust.jcommander.internal.Maps.newHashMap();
        damascusMap.put(DamascusProps.BASE_DAMASCUS_OBJ, params);

        return damascusMap;
    }

    @Override
    public Class<InitArgs> getArgsClass() {
        return InitArgs.class;
    }
}
