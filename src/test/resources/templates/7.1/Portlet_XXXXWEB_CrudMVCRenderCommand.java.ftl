<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}CrudMVCRenderCommand.java">
<#assign skipTemplate = !generateWeb>
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
import ${packageName}.service.${capFirstModel}LocalService;
import ${packageName}.service.${capFirstModel}LocalServiceUtil;
import ${packageName}.service.permission.${capFirstModel}PermissionChecker;
import ${packageName}.service.permission.${capFirstModel}ResourcePermissionChecker;

import ${packageName}.web.constants.${capFirstModel}WebKeys;
import ${packageName}.web.upload.${capFirstModel}ItemSelectorHelper;

<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
import ${packageName}.service.${capFirstValidationModel}LocalService;
import ${packageName}.web.constants.${capFirstValidationModel}WebKeys;
import ${packageName}.web.util.${capFirstValidationModel}ViewHelper;		
	</#if>
</#list> 

import java.util.ArrayList;
import java.util.List;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
* @author Yasuyuki Takeo
* @author ${damascus_author}
*/
@Component(
    immediate = true,
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
        "mvc.command.name=/${lowercaseModel}/crud"
    },
    service = MVCRenderCommand.class
)
public class ${capFirstModel}CrudMVCRenderCommand implements MVCRenderCommand {

    @Override
    public String render(RenderRequest request, RenderResponse response) throws PortletException {

        String renderJSP = ${capFirstModel}WebKeys.VIEW_JSP;

        // Fetch command
        String cmd = ParamUtil.getString(request, Constants.CMD);

        // Fetch primary key
        long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);
        ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute( WebKeys.THEME_DISPLAY);
        
        try {
            if (cmd.equalsIgnoreCase(Constants.UPDATE)) {

                ${capFirstModel} record = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(primaryKey);
                if (${capFirstModel}PermissionChecker.contains(themeDisplay.getPermissionChecker(), record, ActionKeys.UPDATE)) {
                    request.setAttribute("${uncapFirstModel}", record);
                    renderJSP = ${capFirstModel}WebKeys.EDIT_JSP;
                } else {
                    List<String> error = new ArrayList<String>();
                    error.add("permission-error");
                    throw new ${capFirstModel}ValidateException(error);
                }
            } else if (cmd.equalsIgnoreCase(Constants.VIEW)) {

                ${capFirstModel} record = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(primaryKey);
                if (${capFirstModel}PermissionChecker.contains(themeDisplay.getPermissionChecker(), record, ActionKeys.VIEW)) {
                    request.setAttribute("${uncapFirstModel}", record);
                    renderJSP = ${capFirstModel}WebKeys.VIEW_RECORD_JSP;
                } else {
                    List<String> error = new ArrayList<String>();
                    error.add("permission-error");
                    throw new ${capFirstModel}ValidateException(error);
                }
            } else {

                ${capFirstModel} record = _${uncapFirstModel}LocalService.getNewObject(primaryKey);
                if (${capFirstModel}ResourcePermissionChecker.contains(themeDisplay.getPermissionChecker(), themeDisplay.getScopeGroupId(), ActionKeys.ADD_ENTRY)) {
                    if (Validator.isNull(request.getParameter("addErrors"))) {

                        record = _${uncapFirstModel}LocalService.getInitialized${capFirstModel}(primaryKey, request);
                    } else {

                        record = _${uncapFirstModel}LocalService.get${capFirstModel}FromRequest(primaryKey, request);
                    }
                    request.setAttribute("${uncapFirstModel}", record);
                    renderJSP = ${capFirstModel}WebKeys.EDIT_JSP;
                } else {
                    List<String> error = new ArrayList<String>();
                    error.add("permission-error");
                    throw new ${capFirstModel}ValidateException(error);
                }
            }
        } catch (PortalException e) {
            throw new PortletException(e.getMessage());
        }

        request.setAttribute(${capFirstModel}WebKeys.${uppercaseModel}_ITEM_SELECTOR_HELPER, _${uncapFirstModel}ItemSelectorHelper);
		
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">		
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
		<#assign uppercaseValidationModel = "${field.validation.className?upper_case}">
		
		request.setAttribute(${capFirstValidationModel}WebKeys.${uppercaseValidationModel}_VIEW_HELPER, _${uncapFirstValidationModel}ViewHelper);
        request.setAttribute(${capFirstModel}WebKeys.${uppercaseValidationModel}_LOCAL_SERVICE, _${uncapFirstValidationModel}LocalService);
	</#if>
</#list>    
		
        return renderJSP;
    }

    @Reference
    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

    @Reference
    private ${capFirstModel}ItemSelectorHelper _${uncapFirstModel}ItemSelectorHelper;

<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">		
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
	
	@Reference    
    private ${capFirstValidationModel}ViewHelper _${uncapFirstValidationModel}ViewHelper;    

    @Reference
    private ${capFirstValidationModel}LocalService _${uncapFirstValidationModel}LocalService;
	</#if>
</#list>    
}