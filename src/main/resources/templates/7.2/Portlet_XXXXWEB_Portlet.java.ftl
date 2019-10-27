// <dmsc:root templateName="Portlet_XXXXWEB_Portlet.java.ftl"  />

package ${packageName}.web.portlet;

import aQute.bnd.annotation.metatype.Configurable;

import com.liferay.asset.constants.AssetWebKeys;
import com.liferay.asset.util.AssetHelper;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.web.portlet.action.${capFirstModel}Configuration;
import com.liferay.trash.TrashHelper;
import com.liferay.trash.util.TrashWebKeys;

import java.io.IOException;

import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;
import org.osgi.service.component.annotations.Reference;

/**
 * Portlet
 *
 * @author yasuflatland
 */
@Component(
	configurationPid = ${capFirstModel}PortletKeys.${uppercaseModel}_CONFIG, immediate = true,
	property = {
		"com.liferay.portlet.add-default-resource=true",
		"com.liferay.portlet.application-type=full-page-application",
		"com.liferay.portlet.application-type=widget",
		"com.liferay.portlet.css-class-wrapper=portlet-${lowercaseModel}",
		"com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.header-portlet-css=/sample_sb/css/main.css",
		"com.liferay.portlet.layout-cacheable=true",
		"com.liferay.portlet.preferences-owned-by-group=true",
		"com.liferay.portlet.private-request-attributes=false",
		"com.liferay.portlet.private-session-attributes=false",
		"com.liferay.portlet.render-weight=50",
		"com.liferay.portlet.scopeable=true",
		"com.liferay.portlet.struts-path=${lowercaseModel}",
		"com.liferay.portlet.use-default-template=true",
		"javax.portlet.display-name=${capFirstModel}",
		"javax.portlet.init-param.mvc-command-names-default-views=/${lowercaseModel}/view",
		"javax.portlet.expiration-cache=0",
		"javax.portlet.init-param.always-display-default-configuration-icons=true",
		"javax.portlet.init-param.template-path=/META-INF/resources/",
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
		"javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=guest,power-user,user"
	},
	service = Portlet.class
)
public class ${capFirstModel}Portlet extends MVCPortlet {

	@Override
	public void render(
			RenderRequest renderRequest, RenderResponse renderResponse)
		throws IOException, PortletException {

		renderRequest.setAttribute(AssetWebKeys.ASSET_HELPER, _assetHelper);
		renderRequest.setAttribute(TrashWebKeys.TRASH_HELPER, _trashHelper);
		renderRequest.setAttribute(
			${capFirstModel}Configuration.class.getName(), _${uncapFirstModel}Configuration);

		super.render(renderRequest, renderResponse);
	}

	@Activate
	@Modified
	protected void activate(Map<Object, Object> properties) {
		_${uncapFirstModel}Configuration = Configurable.createConfigurable(
			${capFirstModel}Configuration.class, properties);
	}

	@Override
	protected void doDispatch(
			RenderRequest renderRequest, RenderResponse renderResponse)
		throws IOException, PortletException {

		renderRequest.setAttribute(
			${capFirstModel}Configuration.class.getName(), _${uncapFirstModel}Configuration);

		super.doDispatch(renderRequest, renderResponse);
	}

	@Reference
	private AssetHelper _assetHelper;

	private volatile ${capFirstModel}Configuration _${uncapFirstModel}Configuration;

	@Reference
	private TrashHelper _trashHelper;

}