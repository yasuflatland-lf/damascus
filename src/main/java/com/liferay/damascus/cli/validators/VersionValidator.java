package com.liferay.damascus.cli.validators;

import com.beust.jcommander.IParameterValidator;
import com.beust.jcommander.ParameterException;

/**
 * Validate Version
 */
public class VersionValidator implements IParameterValidator {
    public void validate(String name, String value)
            throws ParameterException {
        if (!value.matches("^[\\w]+")) {
            throw new ParameterException("Parameter " + name + " should be only alphabets and underscore (found " + value + ")");
        }
    }
}