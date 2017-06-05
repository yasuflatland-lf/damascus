<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-api/src/main/java/${packagePath}/exception/${capFirstModel}ValidateException.java">

package ${application.packageName}.exception;

import com.liferay.portal.kernel.exception.PortalException;

import java.util.List;

/**
* @author Yasuyuki Takeo
*/
public class ${capFirstModel}ValidateException extends PortalException {

    protected List<String> _errors = null;

    public ${capFirstModel}ValidateException() {}

    public ${capFirstModel}ValidateException(List<String> errors) {
        _errors = errors;
    }

    public List<String> getErrors() {
        return _errors;
    }
}