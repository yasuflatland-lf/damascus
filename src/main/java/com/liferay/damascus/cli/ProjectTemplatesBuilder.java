package com.liferay.damascus.cli;

import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.project.templates.ProjectTemplates;
import com.liferay.project.templates.extensions.ProjectTemplatesArgs;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

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
    private File destinationDir;
    private boolean force;
    @Builder.Default private boolean gradle = true;
    private boolean help;
    private boolean list;
    @Builder.Default private boolean maven = false;
    private String name;
    private String packageName;
    @Builder.Default private String template = DamascusProps.MVC_PORTLET_CMD;
    @NonNull
    private String liferayVersion;

    /**
     * Create scaffold
     *
     * @throws Exception
     */
    public void create() throws Exception {
        ProjectTemplatesArgs projectTemplatesArgs = new ProjectTemplatesArgs();

        projectTemplatesArgs.setClassName(getClassName());
        projectTemplatesArgs.setDestinationDir(getDestinationDir());
        projectTemplatesArgs.setName(getName());
        projectTemplatesArgs.setPackageName(getPackageName());
        projectTemplatesArgs.setTemplate(getTemplate());
        projectTemplatesArgs.setLiferayVersion(getLiferayVersion());

        new ProjectTemplates(projectTemplatesArgs);
    }

}
