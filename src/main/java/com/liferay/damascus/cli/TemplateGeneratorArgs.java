package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.Parameters;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.validators.ProjectNameValidator;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;

/**
 * Template Generator command
 *
 * @author Yasuyuki Takeo
 */
@Parameters(
    commandDescription = "Generate mode. This can be template.",
    commandNames = "generate"
)
@Slf4j
public class TemplateGeneratorArgs extends BaseArgs {

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public boolean isPickup() {
        return pickup;
    }

    public void setPickup(boolean pickup) {
        this.pickup = pickup;
    }

    public String getTemplateDirPath() {
        return templateDirPath;
    }

    public void setTemplateDirPath(String templateDirPath) {
        this.templateDirPath = templateDirPath;
    }

    public String getSourceRootPath() {
        return sourceRootPath;
    }

    public void setSourceRootPath(String sourceRootPath) {
        this.sourceRootPath = sourceRootPath;
    }

    @Parameter(names = "-model", description = "Model to convert. -model (target model name, \"SampleSB\" e.g.) ", validateWith = ProjectNameValidator.class)
    private String model = "";

    @Parameter(names = "-pickup", description = "Only processing pickup flag is on. Default is false.")
    private boolean pickup = false;

    /**
     * Template files' root directory.
     * <p>
     * REQUIRED
     * The path must be end with '/'
     */
    @NonNull
    @Parameter(names = "-templatedir", description = "Template root directory. If this is not configured, the default directory will be used.")
    private String templateDirPath = DamascusProps.TEMPLATE_FILE_PATH;

    /**
     * Source files' root directory also where base.json exists.
     * <p>
     * REQUIRED
     * (this method will process directories under the root recursively)
     */
    @NonNull
    @Parameter(names = "-sourcerootdir", description = "The base directory where base.json exists. The default directory will be used if this value is not configured. Default is current directory.")
    private String sourceRootPath = DamascusProps.CURRENT_DIR;

}
