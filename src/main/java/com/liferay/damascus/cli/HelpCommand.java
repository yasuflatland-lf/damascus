package com.liferay.damascus.cli;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

/**
 * Help command
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
@Data
public class HelpCommand implements ICommand {
    @Override
    public boolean isRunnable(Damascus damascus) {
        return help;
    }

    @Override
    public void run(Damascus damascus, String... args) {
        final JCommander jc = new JCommander(damascus);
        jc.setProgramName("damascus");
        jc.usage();
    }

    @Parameter(names = {"-h", "--help"}, description = "Help command")
    private boolean help = false;
}
