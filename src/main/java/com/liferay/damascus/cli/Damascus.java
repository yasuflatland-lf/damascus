package com.liferay.damascus.cli;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.MissingCommandException;
import com.beust.jcommander.ParameterException;
import com.beust.jcommander.Parameters;
import lombok.extern.slf4j.Slf4j;

import java.util.*;

/**
 * Damascus
 * <p>
 * Damascus is CRUD scaffolding tool for Liferay
 *
 * @author Yasuyuki Takeo
 */
@Slf4j
public class Damascus {

    public final static String VERSION = "1.0.23"; //"20190708" + "_" + LocalDateTime.now().toString();

    /**
     * Main
     *
     * @param args parameters for Damascus
     */
    public static void main(String[] args) {
        Damascus damascus = new Damascus();
        try {
            damascus.run(args);
        } catch (Exception e) {
            System.err.println("Unexpected error occured.");
            e.printStackTrace();
        }
    }

    /**
     * Run Command
     *
     * @param args String array arguments
     * @throws IllegalAccessException
     * @throws InstantiationException
     */
    public void run(String[] args) throws IllegalAccessException, InstantiationException {
        JCommander jc = null;
        String commandName = "";
        try {
            Damascus damascus = new Damascus();

            // Retrieve Command classes from ServiceLoader in a map
            Map<String, BaseCommand<?>> commands = damascus._getCommandsByClassLoader(Damascus.class.getClassLoader());

            // Bind commands to JCommander
            jc = damascus._buildJCommanderWithCommandMap(commands);
            jc.parse(args);

            commandName = jc.getParsedCommand();

            BaseArgs baseArgs = _getBaseArgs(jc, commandName);

            if (null == baseArgs || baseArgs.isHelp()) {
                printUsage(commandName, args, jc);
                return;
            }

            // Execute command
            if (!_runCommand(commands, baseArgs, commandName)) {
                printUsage(commandName, args, jc);
                return;
            }

        } catch (Throwable e) {
            if (e instanceof MissingCommandException) {
                StringBuilder stringBuilder = new StringBuilder("0. No such command");

                for (String arg : args) {
                    stringBuilder.append(" " + arg);
                }
                if (null != jc) {
                    printUsage(null, args, jc);
                }

            } else if (e instanceof ParameterException) {
                if (null != jc) {
                    System.err.println(jc.getParsedCommand() + ": " + e.getMessage());
                }
                printUsage(commandName, args, jc);
            } else {
                e.printStackTrace();
            }

        }
    }

    /**
     * Print Usage
     *
     * @param commandName
     * @param args
     * @param jc
     */
    protected void printUsage(String commandName, String[] args, JCommander jc) {
        if (null != commandName && 1 <= args.length) {
            commandName = args[0];
            jc.usage(commandName);
        } else {
            System.out.println("Version : " + VERSION);
            jc.usage();
        }
    }

    /**
     * Run Command
     *
     * @param commands
     * @param baseArgs
     * @param commandName
     * @return
     * @throws Exception
     */
    protected boolean _runCommand(Map<String, BaseCommand<?>> commands, BaseArgs baseArgs, String commandName)
        throws Exception {

        if (!commands.containsKey(commandName)) {
            return false;
        }

        _command = commands.get(commandName);

        if (null == _command) {
            return false;
        }

        //
        // Store required objects for a command
        //
        _command.setArgs(baseArgs);
        _command.setDamascus(this);

        try {
            // Execute command
            _command.execute();

        } catch (Throwable th) {
            throw th;
        } finally {
            if (_command instanceof AutoCloseable) {
                ((AutoCloseable) _command).close();
            }
        }

        return true;
    }

    /**
     * Get BaseArgs
     *
     * @param jc
     * @param commandName
     * @return null if no appropriate commands found, or BaseArgs object
     */
    protected BaseArgs _getBaseArgs(JCommander jc, String commandName) {

        Map<String, JCommander> jCommands = jc.getCommands();

        JCommander jCommander = jCommands.get(commandName);

        if (jCommander == null) {
            return null;
        }

        List<Object> objects = jCommander.getObjects();

        Object commandArgs = objects.get(0);

        return (BaseArgs) commandArgs;
    }

    /**
     * Get all commands from Service Loader
     *
     * @param classLoader
     * @return
     */
    @SuppressWarnings("rawtypes")
    protected Map<String, BaseCommand<? extends BaseArgs>> _getCommandsByClassLoader(ClassLoader classLoader) {
        Map<String, BaseCommand<? extends BaseArgs>> allCommands = new HashMap<String, BaseCommand<? extends BaseArgs>>();

        ServiceLoader<BaseCommand> serviceLoader = ServiceLoader.load(BaseCommand.class, classLoader);

        Iterator<BaseCommand> baseCommandIterator = serviceLoader.iterator();

        while (baseCommandIterator.hasNext()) {
            try {
                BaseCommand<?> baseCommand = baseCommandIterator.next();

                String commandName = _getCommandName(baseCommand);

                allCommands.put(commandName, baseCommand);
            } catch (Throwable e) {
                Class<?> throwableClass = e.getClass();

                System.err.println("Exception thrown while loading services." + System.lineSeparator() + "Exception: "
                                       + throwableClass.getName() + ": " + e.getMessage() + System.lineSeparator());

                Throwable cause = e.getCause();

                if (cause != null) {
                    Class<?> throwableCauseClass = cause.getClass();

                    System.err
                        .print(throwableCauseClass.getName() + ": " + cause.getMessage() + System.lineSeparator());
                }
            }
        }

        return allCommands;
    }

    /**
     * Get Command Name
     *
     * @param baseCommand
     * @return
     * @throws IllegalAccessException
     * @throws InstantiationException
     */
    protected String _getCommandName(BaseCommand<?> baseCommand)
        throws IllegalAccessException, InstantiationException {

        Class<? extends BaseArgs> baseArgsClass = baseCommand.getArgsClass();

        BaseArgs baseArgs = baseArgsClass.newInstance();

        baseCommand.setArgs(baseArgs);

        Parameters parameters = baseArgsClass.getAnnotation(Parameters.class);

        if (parameters == null) {
            throw new IllegalArgumentException(
                "Loaded base command class that does not have a Parameters annotation " + baseArgsClass.getName());
        }

        String[] names = parameters.commandNames();

        if (1 < names.length) {
            throw new InstantiationException("Multiple Same name commands exist > " + names[0]);
        }

        return names[0];
    }

    /**
     * Build JCommander With Command Map
     *
     * @param baseCommands
     * @return
     * @throws IllegalAccessException
     * @throws InstantiationException
     */
    protected JCommander _buildJCommanderWithCommandMap(Map<String, BaseCommand<? extends BaseArgs>> baseCommands)
        throws IllegalAccessException, InstantiationException {
        JCommander.Builder builder = JCommander.newBuilder();

        for (Map.Entry<String, BaseCommand<? extends BaseArgs>> entry : baseCommands.entrySet()) {
            BaseCommand<? extends BaseArgs> value = entry.getValue();

            try {
                builder.addCommand(entry.getKey(), value.getArgs());
            } catch (ParameterException pe) {
                System.err.println(pe.getMessage());
            }
        }

        return builder.build();
    }

    /**
     * Get Command
     *
     * @return Command object
     */
    public BaseCommand<?> getCommand() {
        return _command;
    }

    private BaseCommand<?> _command = null;

}
