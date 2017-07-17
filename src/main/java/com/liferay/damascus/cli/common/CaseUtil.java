package com.liferay.damascus.cli.common;

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
			if (Character.isLowerCase(c)) {
				output.append(c);
			} else {
				if (i > 0) {
					if (Character.isLowerCase(input[i - 1]) 
							|| (i < (input.length - 1) && Character.isLowerCase(input[i + 1]))) {
						output.append(separator);
					}
				}
				output.append(Character.toLowerCase(c));
			}
		}
		
		String result = output.toString();
		
		return result;
	}

}
