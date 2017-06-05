<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-service/src/main/java/${packagePath}/service/workflow/${capFirstModel}WorkflowHandler.java">

package ${application.packageName}.service.workflow;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.security.permission.ResourceActionsUtil;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.workflow.BaseWorkflowHandler;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.kernel.workflow.WorkflowHandler;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalService;

import java.io.Serializable;
import java.util.Locale;
import java.util.Map;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * Workflow Handler
 *
 * @author Yasuyuki Takeo
 */
@Component(
    property = {"model.class.name=${application.packageName}.model.${capFirstModel}"},
    service = WorkflowHandler.class
)
public class ${capFirstModel}WorkflowHandler extends BaseWorkflowHandler<${capFirstModel}> {

    @Override
    public String getClassName() {
        return ${capFirstModel}.class.getName();
    }

    @Override
    public String getType(Locale locale) {
        return ResourceActionsUtil.getModelResource(locale, getClassName());
    }

    @Override
    public ${capFirstModel} updateStatus(
        int status, Map<String, Serializable> workflowContext)
        throws PortalException {

        long userId = GetterUtil.getLong(
            (String)workflowContext.get(WorkflowConstants.CONTEXT_USER_ID));
        long classPK = GetterUtil.getLong(
            (String)workflowContext.get(
                WorkflowConstants.CONTEXT_ENTRY_CLASS_PK));

        ServiceContext serviceContext = (ServiceContext)workflowContext.get(
            "serviceContext");

        return _${uncapFirstModel}LocalService.updateStatus(
            userId, classPK, status, serviceContext, workflowContext);
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(
        ${capFirstModel}LocalService ${uncapFirstModel}LocalService) {

        _${uncapFirstModel}LocalService = ${uncapFirstModel}LocalService;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
}
