// <dmsc:root templateName="Portlet_XXXXAPI_ValidateException.java.ftl"  />
/* <dmsc:sync id="head-common" > */
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/src/main/java/${packagePath}/exception/${capFirstModel}ValidateException.java">
/* </dmsc:sync> */

/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */


package ${packageName}.exception;

import com.liferay.portal.kernel.exception.PortalException;

import java.util.List;

import org.osgi.annotation.versioning.ProviderType;

/**
 * @author ${damascus_author}
 */
@ProviderType
public class ${capFirstModel}ValidateException extends PortalException {

	public ${capFirstModel}ValidateException() {
	}

	public ${capFirstModel}ValidateException(List<String> errors) {
		_errors = errors;
	}

	public List<String> getErrors() {
		return _errors;
	}

	protected List<String> _errors = null;

}