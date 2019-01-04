<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}ViewMVCRenderCommand.java">
<#assign skipTemplate = !generateWeb>
package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.web.constants.${capFirstModel}WebKeys;
import ${packageName}.web.util.${capFirstModel}ViewHelper;

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
        "mvc.command.name=/",
        "mvc.command.name=/${lowercaseModel}/view"
    },
    service = MVCRenderCommand.class
)
public class ${capFirstModel}ViewMVCRenderCommand implements MVCRenderCommand {

    @Override
    public String render(
        RenderRequest request, RenderResponse response)
        throws PortletException {

        request.setAttribute(${capFirstModel}WebKeys.${uppercaseModel}_VIEW_HELPER, _${uncapFirstModel}ViewHelper);

        return "/${snakecaseModel}/view.jsp";
    }

    @Reference(unbind = "-")
    public void setViewHelper(
        ${capFirstModel}ViewHelper ${uncapFirstModel}ViewHelper) {
        _${uncapFirstModel}ViewHelper = ${uncapFirstModel}ViewHelper;
    }

    private ${capFirstModel}ViewHelper _${uncapFirstModel}ViewHelper;
}