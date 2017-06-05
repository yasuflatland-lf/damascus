package com.liferay.damascus.cli;

public interface ICommand {
    /**
     * Check if this command is runnable
     *
     * @return true if it's runnable or false.
     */
    public boolean isRunnable();

    /**
     * Invoke actual command
     *
     * @param damascus
     * @param args
     */
    public void run(Damascus damascus, String... args);
}
