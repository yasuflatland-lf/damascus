<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}CurdMVCRenderCommand.java">

package ${application.packageName}.web.portlet.action;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalService;
import ${application.packageName}.service.${capFirstModel}LocalServiceUtil;
import ${application.packageName}.web.constants.${capFirstModel}WebKeys;
import ${application.packageName}.web.upload.${capFirstModel}ItemSelectorHelper;
import ${application.packageName}.web.util.${capFirstModel}ViewHelper;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Yasuyuki Takeo
 */
@Component(
    immediate = true,
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "mvc.command.name=/${lowercaseModel}/crud"
    },
    service = MVCRenderCommand.class
)
public class ${capFirstModel}CurdMVCRenderCommand implements MVCRenderCommand {

    @Override
    public String render(RenderRequest request, RenderResponse response) throws PortletException {

        String renderJSP = ${capFirstModel}WebKeys.VIEW_JSP;

        // Fetch command
        String cmd = ParamUtil.getString(request, Constants.CMD);

        // Fetch primary key
        long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);

        try {
            if (cmd.equalsIgnoreCase(Constants.UPDATE)) {

                ${capFirstModel} record = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(primaryKey);
                request.setAttribute("${uncapFirstModel}", record);
                renderJSP = ${capFirstModel}WebKeys.EDIT_JSP;

            } else if (cmd.equalsIgnoreCase(Constants.VIEW)) {

                ${capFirstModel} record = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(primaryKey);
                request.setAttribute("${uncapFirstModel}", record);
                renderJSP = ${capFirstModel}WebKeys.VIEW_RECORD_JSP;

            } else {

                ${capFirstModel} record = _${uncapFirstModel}LocalService.getNewObject(primaryKey);

                if (Validator.isNull(request.getParameter("addErrors"))) {

                    record = _${uncapFirstModel}LocalService.getInitialized${capFirstModel}(primaryKey, request);
                } else {

                    record = _${uncapFirstModel}LocalService.get${capFirstModel}FromRequest(primaryKey, request);
                }
                request.setAttribute("${uncapFirstModel}", record);
                renderJSP = ${capFirstModel}WebKeys.EDIT_JSP;
            }
        } catch (PortalException e) {
            throw new PortletException(e.getMessage());
        }

        request.setAttribute(${capFirstModel}WebKeys.${uppercaseModel}_ITEM_SELECTOR_HELPER, _${uncapFirstModel}ItemSelectorHelper);

        return renderJSP;
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(
        ${capFirstModel}LocalService ${lowercaseModel}localservice) {
        _${uncapFirstModel}LocalService = ${lowercaseModel}localservice;
    }

    @Reference(unbind = "-")
    public void setItemSelectorHelper(
        ${capFirstModel}ItemSelectorHelper ${uncapFirstModel}ItemSelectorHelper) {
        _${uncapFirstModel}ItemSelectorHelper = ${uncapFirstModel}ItemSelectorHelper;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
    private ${capFirstModel}ItemSelectorHelper _${uncapFirstModel}ItemSelectorHelper;

}