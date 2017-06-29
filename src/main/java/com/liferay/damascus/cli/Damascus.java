package com.liferay.damascus.cli;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.ParametersDelegate;
import com.liferay.damascus.cli.common.*;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.io.*;

/**
 * Damascus Tool
 * <p>
 * Damascus is an extension of blade tool (
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
@Data
public class Damascus {

    public final static String VERSION = "20170629";

    @ParametersDelegate
    private InitCommand initCommand = new InitCommand();

    @ParametersDelegate
    private CreateCommand createCommand = new CreateCommand();

    @ParametersDelegate
    private HelpCommand helpCommand = new HelpCommand();

    private String projectDir = null;

    public Damascus() {
    }

    /**
     * Main function
     * <p>
     * Entry point of Damascus tool.
     *
     * @param args
     * @throws Exception
     */
    public static void main(String... args) throws Exception {
        Damascus damascus = new Damascus();
        damascus.run(damascus, args);
    }

    /**
     * Invoke actual command
     *
     * @param damascus
     * @param args
     */
    public void run(Damascus damascus, String... args) {
        try {
            new JCommander(damascus, args);

            if (helpCommand.isRunnable()) {
                helpCommand.run(damascus, args);

            } else if (initCommand.isRunnable()) {
                initCommand.run(damascus, args);

            } else if (createCommand.isRunnable()) {
                createCommand.run(damascus, args);

            } else {
                System.out.println("Damascus version : " + VERSION );
                helpCommand.run(damascus, args);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
