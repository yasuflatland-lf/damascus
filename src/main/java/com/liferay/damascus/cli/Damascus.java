package com.liferay.damascus.cli;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.Parameter;
import com.beust.jcommander.ParametersDelegate;
import com.liferay.damascus.cli.common.DamascusProps;
import com.liferay.damascus.cli.validators.VersionValidator;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

/**
 * Damascus Tool
 * <p>
 * Damascus is an extension of blade tool
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
@Data
public class Damascus {

    public final static String VERSION = "20190325";// + "_" + LocalDateTime.now().toString();

    @ParametersDelegate
    private InitCommand initCommand = new InitCommand();

    @ParametersDelegate
    private CreateCommand createCommand = new CreateCommand();

    @ParametersDelegate
    private TemplateGeneratorCommand templateGeneratorCommand = new TemplateGeneratorCommand();

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
            new JCommander(damascus).parse(args);

            if (helpCommand.isRunnable(damascus)) {
                helpCommand.run(damascus, args);

            } else if (initCommand.isRunnable(damascus)) {
                initCommand.run(damascus, args);

            } else if (createCommand.isRunnable(damascus)) {
                createCommand.run(damascus, args);

            } else if (templateGeneratorCommand.isRunnable(damascus)) {
                templateGeneratorCommand.run(damascus, args);

            } else {
                System.out.println("Damascus version : " + VERSION );
                helpCommand.run(damascus, args);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Parameter(names = "-v", description = "Target Liferay Version. (e.g. 7.1)", validateWith = VersionValidator.class)
    private String liferayVersion = DamascusProps.VERSION_71;

    @Parameter(names = {"-generate","-g"}, description = "Generate mode. This can be template.", validateWith = VersionValidator.class)
    private String generate = "";

}
