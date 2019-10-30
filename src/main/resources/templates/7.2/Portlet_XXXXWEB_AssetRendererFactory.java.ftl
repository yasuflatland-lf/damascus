// <dmsc:root templateName="Portlet_XXXXWEB_AssetRendererFactory.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/asset/${capFirstModel}AssetRendererFactory.java">
// </dmsc:sync> //
package ${packageName}.web.asset;

import com.liferay.asset.kernel.model.AssetRenderer;
import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.model.BaseAssetRendererFactory;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.LiferayPortletURL;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.Portal;
import com.liferay.portal.kernel.util.ResourceBundleLoaderUtil;
import ${packageName}.constants.${capFirstModel}Constants;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;
import javax.portlet.WindowState;
import javax.portlet.WindowStateException;

import javax.servlet.ServletContext;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Asset Renderer Factory
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
	service = AssetRendererFactory.class
)
public class ${capFirstModel}AssetRendererFactory
	extends BaseAssetRendererFactory<${capFirstModel}> {

	public static final String SYMBOLIC_NAME =
		${capFirstModel}Constants.RESOURCE_NAME + ".web";

	public static final String TYPE = "${lowercaseModel}";

	public ${capFirstModel}AssetRendererFactory() {
		setClassName(${capFirstModel}.class.getName());
		setCategorizable(true);
		setPortletId(${capFirstModel}PortletKeys.${uppercaseModel});
		setLinkable(true);
		setSearchable(true);
		setSelectable(true);
	}

	@Override
	public AssetRenderer<${capFirstModel}> getAssetRenderer(long classPK, int type)
		throws PortalException {

		${capFirstModel}AssetRenderer ${uncapFirstModel}AssetRenderer = new ${capFirstModel}AssetRenderer(
			_${uncapFirstModel}LocalService.get${capFirstModel}(classPK),
			ResourceBundleLoaderUtil.
				getResourceBundleLoaderByBundleSymbolicName(SYMBOLIC_NAME));

		${uncapFirstModel}AssetRenderer.setAssetRendererType(type);
		${uncapFirstModel}AssetRenderer.setServletContext(_servletContext);

		return ${uncapFirstModel}AssetRenderer;
	}

	@Override
	public AssetRenderer<${capFirstModel}> getAssetRenderer(
			long groupId, String urlTitle)
		throws PortalException {

		${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(groupId, urlTitle);

		${capFirstModel}AssetRenderer ${uncapFirstModel}AssetRenderer = new ${capFirstModel}AssetRenderer(
			entry,
			ResourceBundleLoaderUtil.
				getResourceBundleLoaderByBundleSymbolicName(SYMBOLIC_NAME));

		${uncapFirstModel}AssetRenderer.setServletContext(_servletContext);

		return ${uncapFirstModel}AssetRenderer;
	}

	@Override
	public String getClassName() {
		return ${capFirstModel}.class.getName();
	}

	@Override
	public String getType() {
		return TYPE;
	}

	@Override
	public PortletURL getURLAdd(
		LiferayPortletRequest liferayPortletRequest,
		LiferayPortletResponse liferayPortletResponse, long classTypeId) {

		PortletURL portletURL = _portal.getControlPanelPortletURL(
			liferayPortletRequest, getGroup(liferayPortletRequest),
			${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, 0, 0,
			PortletRequest.RENDER_PHASE);

		portletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
		portletURL.setParameter(Constants.CMD, Constants.ADD);
		portletURL.setParameter("fromAsset", StringPool.TRUE);

		return portletURL;
	}

	@Override
	public PortletURL getURLView(
		LiferayPortletResponse liferayPortletResponse,
		WindowState windowState) {

		LiferayPortletURL liferayPortletURL =
			liferayPortletResponse.createLiferayPortletURL(
				${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
				PortletRequest.RENDER_PHASE);

		liferayPortletURL.setParameter(
			"mvcRenderCommandName", "/${lowercaseModel}/view");
		liferayPortletURL.setParameter(Constants.CMD, Constants.VIEW);
		liferayPortletURL.setParameter("fromAsset", StringPool.TRUE);

		try {
			liferayPortletURL.setWindowState(windowState);
		}
		catch (WindowStateException wse) {
			_log.error("Windos state is not valid. Skip.", wse);
		}

		return liferayPortletURL;
	}

	@Override
	public boolean hasAddPermission(
			PermissionChecker permissionChecker, long groupId, long classTypeId)
		throws Exception {

		if (_portletResourcePermission.contains(
				permissionChecker, groupId, ActionKeys.VIEW)) {

			return false;
		}

		return _portletResourcePermission.contains(
			permissionChecker, groupId, ActionKeys.ADD_ENTRY);
	}

	@Override
	public boolean hasPermission(
			PermissionChecker permissionChecker, long classPK, String actionId)
		throws Exception {

		return _${uncapFirstModel}ModelResourcePermission.contains(
			permissionChecker, classPK, actionId);
	}

	@Reference(
		target = "(osgi.web.symbolicname=${packageName}.web)", unbind = "-"
	)
	public void setServletContext(ServletContext servletContext) {
		_servletContext = servletContext;
	}

	private static final Log _log = LogFactoryUtil.getLog(
		${capFirstModel}AssetRendererFactory.class);

	@Reference
	private Portal _portal;

	@Reference(
		target = "(resource.name=" + ${capFirstModel}Constants.RESOURCE_NAME + ")"
	)
	private PortletResourcePermission _portletResourcePermission;

	@Reference
	private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

	@Reference(target = "(model.class.name=${packageName}.model.${capFirstModel})")
	private ModelResourcePermission<${capFirstModel}> _${uncapFirstModel}ModelResourcePermission;

	@Reference(target = "(osgi.web.symbolicname=" + SYMBOLIC_NAME + ")")
	private ServletContext _servletContext;

}