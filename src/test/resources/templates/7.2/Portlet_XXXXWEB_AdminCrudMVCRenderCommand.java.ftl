// <dmsc:root templateName="Portlet_XXXXWEB_AdminCrudMVCRenderCommand.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}AdminCrudMVCRenderCommand.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //

package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.exception.${capFirstModel}ValidateException;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}Service;
import ${packageName}.web.constants.${capFirstModel}WebKeys;
import ${packageName}.web.internal.security.permission.resource.${capFirstModel}EntryPermission;
import ${packageName}.web.upload.${capFirstModel}ItemSelectorHelper;

//<dmsc:sync id="head-imports" > //
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
import ${packageName}.service.${capFirstValidationModel}LocalService;
import ${packageName}.web.constants.${capFirstValidationModel}WebKeys;
	</#if>
</#list>
// </dmsc:sync> //

import java.util.ArrayList;
import java.util.List;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} CRUD Render
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
		"mvc.command.name=/${lowercaseModel}/crud"
	},
	service = MVCRenderCommand.class
)
public class ${capFirstModel}AdminCrudMVCRenderCommand implements MVCRenderCommand {

	/**
	 * Edit Page JSP file
	 */
	public String getEditPageJSP() {
		return ${capFirstModel}WebKeys.ADMIN_EDIT_JSP;
	}

	/**
	 * View Page JSP file
	 */
	public String getViewPageJSP() {
		return ${capFirstModel}WebKeys.ADMIN_VIEW_JSP;
	}

	/**
	 * View Record JSP file
	 */
	public String getViewRecordPageJSP() {
		return ${capFirstModel}WebKeys.ADMIN_VIEW_RECORD_JSP;
	}

	@Override
	public String render(RenderRequest request, RenderResponse response)
		throws PortletException {

		String renderJSP = getViewPageJSP();

		// Fetch command

		String cmd = ParamUtil.getString(request, Constants.CMD);

		// Fetch primary key

		long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(
			WebKeys.THEME_DISPLAY);

		try {
			if (cmd.equalsIgnoreCase(Constants.UPDATE)) {
				renderJSP = update(request, themeDisplay, primaryKey);
			}
			else if (cmd.equalsIgnoreCase(Constants.VIEW)) {
				renderJSP = view(request, themeDisplay, primaryKey);
			}
			else {
				renderJSP = add(request, themeDisplay, primaryKey);
			}
		}
		catch (PortalException pe) {
			throw new PortletException(pe.getMessage());
		}


// <dmsc:sync id="render-attributes" > //
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
		<#assign uppercaseValidationModel = "${field.validation.className?upper_case}">

        request.setAttribute(${capFirstModel}WebKeys.${uppercaseValidationModel}_LOCAL_SERVICE, _${uncapFirstValidationModel}LocalService);
	</#if>
</#list>
//</dmsc:sync> //
		request.setAttribute(
			${capFirstModel}WebKeys.${uppercaseModel}_ITEM_SELECTOR_HELPER,
			_${uncapFirstModel}ItemSelectorHelper);

		return renderJSP;
	}

	/**
	 * Add record
	 *
	 * @param request
	 * @param themeDisplay
	 * @param primaryKey
	 * @return JSP file path
	 * @throws PortalException
	 * @throws ${capFirstModel}ValidateException
	 * @throws PortletException
	 */
	protected String add(
			RenderRequest request, ThemeDisplay themeDisplay, long primaryKey)
		throws PortalException, PortletException, ${capFirstModel}ValidateException {

		${capFirstModel} record = null;

		if (Validator.isNull(request.getParameter("addErrors"))) {
			record = _${uncapFirstModel}Service.getInitialized${capFirstModel}(
				primaryKey, request);
		}
		else {
			record = _${uncapFirstModel}Service.get${capFirstModel}FromRequest(
				primaryKey, request);
		}

		request.setAttribute("${uncapFirstModel}", record);

		return getEditPageJSP();
	}

	/**
	 * Update record
	 *
	 * @param request
	 * @param themeDisplay
	 * @param primaryKey
	 * @return JSP file path to open
	 * @throws PortalException
	 * @throws ${capFirstModel}ValidateException
	 */
	protected String update(
			RenderRequest request, ThemeDisplay themeDisplay, long primaryKey)
		throws PortalException, ${capFirstModel}ValidateException {

		${capFirstModel} record = _${uncapFirstModel}Service.get${capFirstModel}(primaryKey);

		if (!${capFirstModel}EntryPermission.contains(
				themeDisplay.getPermissionChecker(), record,
				ActionKeys.UPDATE)) {

			List<String> error = new ArrayList<>();
			error.add("permission-error");

			throw new ${capFirstModel}ValidateException(error);
		}

		request.setAttribute("${uncapFirstModel}", record);

		return getEditPageJSP();
	}

	/**
	 * View record
	 *
	 * @param request
	 * @param themeDisplay
	 * @param primaryKey
	 * @return
	 * @throws PortalException
	 * @throws ${capFirstModel}ValidateException
	 */
	protected String view(
			RenderRequest request, ThemeDisplay themeDisplay, long primaryKey)
		throws PortalException, ${capFirstModel}ValidateException {

		${capFirstModel} record = _${uncapFirstModel}Service.get${capFirstModel}(primaryKey);

		if (!${capFirstModel}EntryPermission.contains(
				themeDisplay.getPermissionChecker(), record, ActionKeys.VIEW)) {

			List<String> error = new ArrayList<>();
			error.add("permission-error");

			throw new ${capFirstModel}ValidateException(error);
		}

		request.setAttribute("${uncapFirstModel}", record);

		return getViewRecordPageJSP();
	}

// <dmsc:sync id="service-references" > //
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">

    @Reference
    private ${capFirstValidationModel}LocalService _${uncapFirstValidationModel}LocalService;
	</#if>
</#list>
//</dmsc:sync> //
	
	@Reference
	private ${capFirstModel}ItemSelectorHelper _${uncapFirstModel}ItemSelectorHelper;

}