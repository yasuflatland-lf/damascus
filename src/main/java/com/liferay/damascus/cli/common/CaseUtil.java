package com.liferay.damascus.cli.common;

/**
 * Case formats conversion utility
 * 
 * <p>
 * Note: We don't use Guava CaseFormat because it has some limitations with uppercase characters sequences. 
 * For example, converting from camel case to dash case the string "UnknownURL":
 * <ul>
 * 	<li>with Guava: "unknown-u-r-l"</li>
 * 	<li>with the custom class: "unknown-url"</li>
 * </ul>
 * </p>
 * 
 * @author Sébastien Le Marchand
 */
public class CaseUtil {
	
	protected CaseUtil() {
		
	}
	
    /**
     * Get Instance
     *
     * @return this instance
     */
    public static CaseUtil getInstance() {
        return SingletonHolder.INSTANCE;
    }

    private static class SingletonHolder {
        private static final CaseUtil INSTANCE = new CaseUtil();
    }
	
	public String camelCaseToDashCase(String s) {
		
		return camelCaseToSeparatorCase(s, "-");
	}

	public String camelCaseToSnakeCase(String s) {
		
		return camelCaseToSeparatorCase(s, "_");
	}
	
	protected String camelCaseToSeparatorCase(String s, String separator) {
		
		char[] input = s.toCharArray();
		
		StringBuilder output = new StringBuilder();
	
		for (int i = 0; i < input.length; i++) {
			char c = input[i];
			if (Character.isLowerCase(c) || isSpecialCharacter(c)) {
				output.append(c);
			} else {
				if (i > 0) {
					if ((previousCharIsLowerCase(input, i) || nextCharIsLowerCase(input, i))
							&& (!isSpecialCharacter(input[i - 1]) && !isSpecialCharacter(input[i + 1]))) {
						output.append(separator);
					}
				}
				output.append(Character.toLowerCase(c));
			}
		}
		
		String result = output.toString();
		
		return result;
	}

	private boolean previousCharIsLowerCase(char[] input, int i) {

		return Character.isLowerCase(input[i - 1]);
	}

	private boolean nextCharIsLowerCase(char[] input, int i) {

		return i < (input.length - 1) && Character.isLowerCase(input[i + 1]);
	}

	private boolean isSpecialCharacter(char c) {

		return !Character.isLetterOrDigit(c);
	}

}
