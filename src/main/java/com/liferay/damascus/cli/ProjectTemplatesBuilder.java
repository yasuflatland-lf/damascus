package com.liferay.damascus.cli;

import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.project.templates.ProjectTemplates;
import com.liferay.project.templates.ProjectTemplatesArgs;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.io.File;

/**
 * Project Templates Create Builder
 * <p>
 * This is a wrapper of ProjectTemplatesArgs.
 *
 * @author Yasuyuki Takeo
 */
@Data
@AllArgsConstructor
@Builder
public class ProjectTemplatesBuilder {
    private String className;
    private String contributorType;
    private File destinationDir;
    private boolean force;
    private boolean gradle = true;
    private boolean help;
    private String hostBundleSymbolicName;
    private String hostBundleVersion;
    private boolean list;
    private boolean maven = false;
    private String name;
    private String packageName;
    private String service;
    private String template = DamascusProps.MVC_PORTLET_CMD;

    /**
     * Create scaffold
     *
     * @throws Exception
     */
    public void create() throws Exception {
        ProjectTemplatesArgs projectTemplatesArgs = new ProjectTemplatesArgs();

        projectTemplatesArgs.setClassName(getClassName());
        projectTemplatesArgs.setContributorType(getContributorType());
        projectTemplatesArgs.setDestinationDir(getDestinationDir());
        projectTemplatesArgs.setHostBundleSymbolicName(getHostBundleSymbolicName());
        projectTemplatesArgs.setHostBundleVersion(getHostBundleVersion());
        projectTemplatesArgs.setName(getName());
        projectTemplatesArgs.setPackageName(getPackageName());
        projectTemplatesArgs.setService(getService());
        projectTemplatesArgs.setTemplate(getTemplate());

        new ProjectTemplates(projectTemplatesArgs);
    }

}
