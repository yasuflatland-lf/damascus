// <dmsc:root templateName="Portlet_XXXXAPI_ValidateException.java.ftl"  />
/* <dmsc:sync id="head-common" > */
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/src/main/java/${packagePath}/exception/${capFirstModel}ValidateException.java">
/* </dmsc:sync> */

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