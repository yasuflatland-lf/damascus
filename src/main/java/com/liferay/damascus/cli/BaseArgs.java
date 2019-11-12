package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.validators.VersionValidator;
import lombok.Data;

@Data
public class BaseArgs {

    public boolean isHelp() {
        return _help;
    }

    @Parameter(description = "Get help on a specific command.", help = true, names = "--help")
    private boolean _help;

    @Parameter(names = "-v", description = "Target Liferay Version. (e.g. 7.2)", validateWith = VersionValidator.class)
    private String liferayVersion = DamascusProps.VERSION_72;

}
