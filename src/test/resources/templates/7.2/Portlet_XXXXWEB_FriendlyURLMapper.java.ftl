// <dmsc:root templateName="Portlet_XXXXWEB_FriendlyURLMapper.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/route/${capFirstModel}FriendlyURLMapper.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
package ${packageName}.web.portlet.route;

import com.liferay.portal.kernel.portlet.DefaultFriendlyURLMapper;
import com.liferay.portal.kernel.portlet.FriendlyURLMapper;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import org.osgi.service.component.annotations.Component;

/**
 * FriendlyURL Mapper
 *
 * This is used to mapping Friendly URL to the portlet. This class is reqired for routing path correctly for Asset Publisher.
 *
 * @author ${damascus_author}
 */
@Component(
	property = {
		"com.liferay.portlet.friendly-url-routes=META-INF/friendly-url-routes/routes.xml",
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}
	},
	service = FriendlyURLMapper.class
)
public class ${capFirstModel}FriendlyURLMapper extends DefaultFriendlyURLMapper {

	@Override
	public String getMapping() {
		return _MAPPING;
	}

	private static final String _MAPPING = "${uncapFirstModel}";

}