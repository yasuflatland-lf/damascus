package com.liferay.damascus.cli.validators;

import com.beust.jcommander.IParameterValidator;
import com.beust.jcommander.ParameterException;

/**
 * Validate Package Name
 */
public class PackageNameValidator implements IParameterValidator {
    public void validate(String name, String value)
            throws ParameterException {
        if (!value.matches("([a-zA-Z_$][a-zA-Z\\d_$]*\\.)*[a-zA-Z_$][a-zA-Z\\d_$]*")) {
            throw new ParameterException("Parameter " + name + " should be appropriate package name (found " + value + ")");
        }
    }
}