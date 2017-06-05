package com.liferay.damascus.cli.exception;

public class DamascusProcessException extends Exception {
    public DamascusProcessException() {
    }

    public DamascusProcessException(String msg) {
        super(msg);
    }

    public DamascusProcessException(String msg, Throwable cause) {
        super(msg, cause);
    }

    public DamascusProcessException(Throwable cause) {
        super(cause);
    }
}
