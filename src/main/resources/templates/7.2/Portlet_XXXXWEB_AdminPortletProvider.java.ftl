// <dmsc:root templateName="Portlet_XXXXWEB_AdminPortletProvider.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/${capFirstModel}AdminPortletProvider.java">
// </dmsc:sync> //
package ${packageName}.web.portlet;

import com.liferay.portal.kernel.portlet.BasePortletProvider;
import com.liferay.portal.kernel.portlet.EditPortletProvider;
import com.liferay.portal.kernel.portlet.ManagePortletProvider;
import com.liferay.portal.kernel.portlet.ViewPortletProvider;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import org.osgi.service.component.annotations.Component;

/**
 * ${capFirstModel} Portlet Provider
 *
 * This class returns Portlet ID for PortletProviderUtil which is used in TrashHandler.
 * This Portlet ID is used to create a restore URL.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "model.class.name=${packageName}.model.${capFirstModel}",
	service = {
		EditPortletProvider.class, ManagePortletProvider.class,
		ViewPortletProvider.class
	}
)
public class ${capFirstModel}AdminPortletProvider
	extends BasePortletProvider
	implements EditPortletProvider, ManagePortletProvider, ViewPortletProvider {

	@Override
	public String getPortletName() {
		return ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN;
	}

}