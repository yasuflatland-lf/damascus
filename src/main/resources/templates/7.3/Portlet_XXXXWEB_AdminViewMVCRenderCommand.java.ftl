// <dmsc:root templateName="Portlet_XXXXWEB_AdminViewMVCRenderCommand.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}AdminViewMVCRenderCommand.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;
import com.liferay.portal.kernel.util.Portal;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.web.constants.${capFirstModel}WebKeys;
import ${packageName}.web.internal.display.context.${capFirstModel}DisplayContext;
import ${packageName}.web.util.${capFirstModel}ViewHelper;
import com.liferay.trash.TrashHelper;

//<dmsc:sync id="additional-imports" > //
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
import ${packageName}.service.${capFirstValidationModel}LocalService;
import ${packageName}.web.constants.${capFirstValidationModel}WebKeys;
	</#if>
</#list>
//</dmsc:sync> //

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
		"mvc.command.name=/", "mvc.command.name=/${lowercaseModel}/view"
	},
	service = MVCRenderCommand.class
)
public class ${capFirstModel}AdminViewMVCRenderCommand implements MVCRenderCommand {

	@Override
	public String render(RenderRequest request, RenderResponse response) {
		request.setAttribute(
			${capFirstModel}WebKeys.${uppercaseModel}_DISPLAY_CONTEXT,
			new ${capFirstModel}DisplayContext(
				_portal.getLiferayPortletRequest(request),
				_portal.getLiferayPortletResponse(response), _trashHelper,
				_${uncapFirstModel}ViewHelper));

		request.setAttribute(
			${capFirstModel}WebKeys.${uppercaseModel}_VIEW_HELPER, _${uncapFirstModel}ViewHelper);

//<dmsc:sync id="additional-request-attributes" > //
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
		<#assign uppercaseValidationModel = "${field.validation.className?upper_case}">
        request.setAttribute(${capFirstModel}WebKeys.${uppercaseValidationModel}_LOCAL_SERVICE, _${uncapFirstValidationModel}LocalService);
	</#if>
</#list>
//</dmsc:sync> //
		
		return ${capFirstModel}WebKeys.ADMIN_VIEW_JSP;
	}

	@Reference
	private Portal _portal;

	@Reference
	private ${capFirstModel}ViewHelper _${uncapFirstModel}ViewHelper;

	@Reference
	private TrashHelper _trashHelper;
	
//<dmsc:sync id="service-references" > //
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
    @Reference
    private ${capFirstValidationModel}LocalService _${uncapFirstValidationModel}LocalService;
	</#if>
</#list>
//</dmsc:sync> //	

}