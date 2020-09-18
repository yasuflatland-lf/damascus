// <dmsc:root templateName="Portlet_XXXXSVC_WorkflowHandler.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/service/workflow/${capFirstModel}WorkflowHandler.java">
/* </dmsc:sync> */ 


package ${packageName}.service.workflow;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.security.permission.ResourceActionsUtil;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.workflow.BaseWorkflowHandler;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.kernel.workflow.WorkflowHandler;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

import java.io.Serializable;

import java.util.Locale;
import java.util.Map;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Workflow Handler
 *
 * @author ${damascus_author}
 */
@Component(
	property = "model.class.name=${packageName}.model.${capFirstModel}",
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