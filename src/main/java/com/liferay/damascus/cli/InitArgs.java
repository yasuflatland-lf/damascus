package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.Parameters;
import com.liferay.damascus.cli.BaseArgs;
import com.liferay.damascus.cli.validators.PackageNameValidator;
import com.liferay.damascus.cli.validators.ProjectNameValidator;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

/**
 * Initialize Init command arguments
 *
 * @author Yasuyuki Takeo
 */
@Parameters(
    commandDescription = "Initialize scaffolding generation configuration file",
    commandNames = "-init"
)
@Slf4j
@Data
public class InitArgs extends BaseArgs {

    @Parameter(names = "-init", description = "Create damascus base file. -init (project name) ", validateWith = ProjectNameValidator.class)
    private String projectName = null;

    @Parameter(names = "-p", description = "Package name. (e.g. com.liferay.test)", validateWith = PackageNameValidator.class)
    private String packageName = null;

}
