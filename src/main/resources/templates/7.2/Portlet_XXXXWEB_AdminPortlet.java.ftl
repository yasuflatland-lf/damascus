// <dmsc:root templateName="Portlet_XXXXWEB_AdminPortlet.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/${capFirstModel}AdminPortlet.java">
// </dmsc:sync> //

package ${packageName}.web.portlet;

import com.liferay.asset.constants.AssetWebKeys;
import com.liferay.asset.util.AssetHelper;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import com.liferay.trash.TrashHelper;
import com.liferay.trash.util.TrashWebKeys;

import java.io.IOException;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Admin Portlet
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = {
		"com.liferay.portlet.css-class-wrapper=portlet-${lowercaseModel}",
		"com.liferay.portlet.display-category=category.hidden",
		"com.liferay.portlet.header-portlet-css=/${snakecaseModel}_admin/css/main.css",
		"com.liferay.portlet.preferences-unique-per-layout=true",
		"com.liferay.portlet.preferences-owned-by-group=true",
		"com.liferay.portlet.private-request-attributes=false",
		"com.liferay.portlet.private-session-attributes=false",
		"com.liferay.portlet.render-weight=50",
		"com.liferay.portlet.scopeable=true",
		"com.liferay.portlet.struts-path=${lowercaseModel}_admin",
		"com.liferay.portlet.use-default-template=true",
		"javax.portlet.display-name=${capFirstModel} Admin",
		"javax.portlet.init-param.mvc-command-names-default-views=/${lowercaseModel}/view",
		"javax.portlet.init-param.portlet-title-based-navigation=true",
		"javax.portlet.expiration-cache=0",
		"javax.portlet.init-param.template-path=/META-INF/resources/",
		"javax.portlet.init-param.view-template=/${snakecaseModel}_admin/view.jsp",
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=administrator"
	},
	service = Portlet.class
)
public class ${capFirstModel}AdminPortlet extends MVCPortlet {

	@Override
	public void render(
			RenderRequest renderRequest, RenderResponse renderResponse)
		throws IOException, PortletException {

		renderRequest.setAttribute(AssetWebKeys.ASSET_HELPER, _assetHelper);
		renderRequest.setAttribute(TrashWebKeys.TRASH_HELPER, _trashHelper);

		super.render(renderRequest, renderResponse);
	}

	@Reference
	private AssetHelper _assetHelper;

	@Reference
	private TrashHelper _trashHelper;

}