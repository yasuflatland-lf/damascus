<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}FindEntryHelper.java">
package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.portlet.PortletLayoutFinder;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.struts.BaseFindActionHelper;
import com.liferay.portal.struts.FindActionHelper;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

import javax.portlet.PortletURL;
import javax.servlet.http.HttpServletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "model.class.name=${packageName}.model.${capFirstModel}",
	service = FindActionHelper.class
)
public class ${capFirstModel}FindEntryHelper extends BaseFindActionHelper {

	@Override
	public long getGroupId(long primaryKey) throws Exception {
		${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(primaryKey);

		return entry.getGroupId();
	}

	@Override
	public String getPrimaryKeyParameterName() {
		return "resourcePrimKey";
	}

	@Override
	public PortletURL processPortletURL(
			HttpServletRequest request, PortletURL portletURL)
		throws Exception {

		return portletURL;
	}

	@Override
	public void setPrimaryKeyParameter(PortletURL portletURL, long primaryKey)
		throws Exception {

		portletURL.setParameter("resourcePrimKey", String.valueOf(primaryKey));
	}

	@Override
	protected void addRequiredParameters(
		HttpServletRequest request, String portletId, PortletURL portletURL) {

		portletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
		portletURL.setParameter(Constants.CMD, Constants.VIEW);
		portletURL.setParameter("redirect", portletURL.toString());
	}

	@Override
	protected PortletLayoutFinder getPortletLayoutFinder() {
		return _portletLayoutFinder;
	}

	@Reference(unbind = "-")
	protected void set${capFirstModel}LocalService(
		${capFirstModel}LocalService ${lowercaseModel}localservice) {
		_${uncapFirstModel}LocalService = ${lowercaseModel}localservice;
	}

	@Reference(
		target = "(model.class.name=${packageName}.model.${capFirstModel})",
		unbind = "-"
	)
	protected void setPortletLayoutFinder(
		PortletLayoutFinder portletPageFinder) {

		_portletLayoutFinder = portletPageFinder;
	}

	private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
	private PortletLayoutFinder _portletLayoutFinder;

}
