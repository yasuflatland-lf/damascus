package com.liferay.damascus.cli;

import com.beust.jcommander.Parameter;
import com.liferay.damascus.cli.common.CommonUtil;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.validators.VersionValidator;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class BaseArgs {

    public boolean isHelp() {
        return _help;
    }

    @Parameter(names = "--help", description = "Get help on a specific command.", help = true)
    private boolean _help;

    @Parameter(names = "-v", description = "Target Liferay Version. (e.g. 7.2)", validateWith = VersionValidator.class)
    private String liferayVersion = DamascusProps.VERSION_72;

    @Parameter(names = "-base_dir", description = "base.json location. Default is the current directory")
    private String baseDir = CommonUtil.normalizePath(DamascusProps.CURRENT_DIR);

}
