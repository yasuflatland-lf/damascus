<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/portlet/${capFirstModel}PanelApp.java">
package ${application.packageName}.web.portlet;

import com.liferay.application.list.BasePanelApp;
import com.liferay.application.list.PanelApp;
import com.liferay.application.list.constants.PanelCategoryKeys;
import com.liferay.portal.kernel.model.Portlet;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
    immediate = true,
    property = {
        "panel.app.order:Integer=100", //TODO : this number determin the order in the panel
        "panel.category.key=" + PanelCategoryKeys.SITE_ADMINISTRATION_CONTENT
    },
    service = PanelApp.class
)
public class ${capFirstModel}PanelApp extends BasePanelApp  {

    @Override
    public String getPortletId() {
        return ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN;
    }

    @Override
    @Reference(
        target = "(javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN + ")",
        unbind = "-"
    )
    public void setPortlet(Portlet portlet) {
        super.setPortlet(portlet);
    }
}
