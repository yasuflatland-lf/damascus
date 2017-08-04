<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}FindEntryAction.java">

package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.struts.BaseStrutsAction;
import com.liferay.portal.kernel.struts.StrutsAction;
import com.liferay.portal.struts.FindActionHelper;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "path=" + ${capFirstModel}PortletKeys.${uppercaseModel}_FIND_ENTRY
    },
    service = StrutsAction.class
)
public class ${capFirstModel}FindEntryAction extends BaseStrutsAction {

    @Override
    public String execute(
        HttpServletRequest request, HttpServletResponse response)
        throws Exception {

        _findActionHelper.execute(request, response);

        return null;
    }

    @Reference(
        target = "(model.class.name=${packageName}.model.${capFirstModel})",
        unbind = "-"
    )
    protected void setFindActionHelper(FindActionHelper findActionHelper) {
        _findActionHelper = findActionHelper;
    }

    private FindActionHelper _findActionHelper;

}