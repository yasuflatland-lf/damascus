package com.liferay.damascus.cli;

public abstract class BaseCommand<T extends BaseArgs> {
	public BaseCommand() {
	}

	public BaseCommand(Damascus damascus, T args) {
		_damascus = damascus;
		_args = args;
	}

	public abstract void execute() throws Exception;

	public T getArgs() {
		return _args;
	}

	public abstract Class<T> getArgsClass();

	public Damascus getDamascus() {
		return _damascus;
	}

	public void setArgs(BaseArgs commandArgs) {
		_args = getArgsClass().cast(commandArgs);
	}

	public void setDamascus(Damascus damascus) {
		_damascus = damascus;
	}

	private T _args;
	private Damascus _damascus;
}
