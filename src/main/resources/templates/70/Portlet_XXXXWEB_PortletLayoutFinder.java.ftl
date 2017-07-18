<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/${capFirstModel}PortletLayoutFinder.java">

package ${packageName}.web.portlet;

import com.liferay.portal.kernel.portlet.BasePortletLayoutFinder;
import com.liferay.portal.kernel.portlet.PortletLayoutFinder;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import org.osgi.service.component.annotations.Component;

/**
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = {"model.class.name=${packageName}.model.${capFirstModel}"},
	service = PortletLayoutFinder.class
)
public class ${capFirstModel}PortletLayoutFinder extends BasePortletLayoutFinder {

	@Override
	protected String[] getPortletIds() {
		return _PORTLET_IDS;
	}

	private static final String[] _PORTLET_IDS = {${capFirstModel}PortletKeys.${uppercaseModel}};

}
