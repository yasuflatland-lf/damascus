package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.Parameters;
import com.liferay.damascus.cli.validators.PackageNameValidator;
import com.liferay.damascus.cli.validators.ProjectNameValidator;
import lombok.extern.slf4j.Slf4j;

/**
 * Initialize Init command arguments
 *
 * @author Yasuyuki Takeo
 */
@Parameters(
    commandDescription = "Initialize scaffolding generation configuration file",
    commandNames = "init"
)
@Slf4j
public class InitArgs extends BaseArgs {

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    @Parameter(names = "-c", description = "Class name. E.g. ToDo ", validateWith = ProjectNameValidator.class, required = true)
    private String projectName = null;

    @Parameter(names = "-p", description = "Package name. (e.g. com.liferay.test)", validateWith = PackageNameValidator.class, required = true)
    private String packageName = null;

}
