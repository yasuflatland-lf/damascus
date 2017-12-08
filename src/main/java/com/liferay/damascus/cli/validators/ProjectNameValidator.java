package com.liferay.damascus.cli.validators;

import com.beust.jcommander.IParameterValidator;
import com.beust.jcommander.ParameterException;

/**
 * Validate Project Name
 */
public class ProjectNameValidator implements IParameterValidator {
    public void validate(String name, String value)
            throws ParameterException {
        if (!value.matches("^[A-Z][a-zA-Z-]+[a-zA-Z]")) {
            throw new ParameterException("Parameter " + name + " should only use alphabetic and dash characters," +
					" start with a capital character and end with an alphabetic character (found " + value + ")");
        }
    }
}
