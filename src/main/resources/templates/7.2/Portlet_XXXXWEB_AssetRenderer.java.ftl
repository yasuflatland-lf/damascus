// <dmsc:root templateName="Portlet_XXXXWEB_AssetRenderer.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/asset/${capFirstModel}AssetRenderer.java">
// </dmsc:sync> //

package ${packageName}.web.asset;

import com.liferay.asset.display.page.portlet.AssetDisplayPageFriendlyURLProvider;
import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.model.BaseJSPAssetRenderer;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.PortletLayoutFinder;
import com.liferay.portal.kernel.portlet.PortletLayoutFinderRegistryUtil;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.service.GroupLocalServiceUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.trash.TrashRenderer;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.ResourceBundleLoader;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.web.internal.security.permission.resource.${capFirstModel}EntryPermission;

import java.util.Locale;

import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.portlet.PortletURL;
import javax.portlet.WindowState;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Asset Renderer
 *
 * This class is used to display contents in Asset Publisher.
 *
 * @author ${damascus_author}
 */
public class ${capFirstModel}AssetRenderer
	extends BaseJSPAssetRenderer<${capFirstModel}> implements TrashRenderer {

	public ${capFirstModel}AssetRenderer(
		${capFirstModel} entry, ResourceBundleLoader resourceBundleLoader) {

		_entry = entry;
		_resourceBundleLoader = resourceBundleLoader;
	}

	@Override
	public ${capFirstModel} getAssetObject() {
		return _entry;
	}

	@Override
	public String getClassName() {
		return ${capFirstModel}.class.getName();
	}

	@Override
	public long getClassPK() {
		return _entry.getPrimaryKey();
	}

	@Override
	public String getDiscussionPath() {
		return null;
	}

	@Override
	public long getGroupId() {
		return _entry.getGroupId();
	}

	@Override
	public String getJspPath(HttpServletRequest request, String template) {
		if (template.equals(TEMPLATE_ABSTRACT) ||
			template.equals(TEMPLATE_FULL_CONTENT)) {

			request.setAttribute("${uncapFirstModel}", _entry);

			return "/${snakecaseModel}/asset/" + template + ".jsp";
		}

		return null;
	}

	@Override
	public String getPortletId() {
		AssetRendererFactory<${capFirstModel}> assetRendererFactory =
			getAssetRendererFactory();

		return assetRendererFactory.getPortletId();
	}

	@Override
	public int getStatus() {
		return _entry.getStatus();
	}

	@Override
	public String getSummary(
		PortletRequest portletRequest, PortletResponse portletResponse) {

		return HtmlUtil.stripHtml(_entry.get${application.asset.assetSummaryFieldName?cap_first}());
	}

	@Override
	public String getTitle(Locale locale) {
		return _entry.get${application.asset.assetTitleFieldName?cap_first}();
	}

	@Override
	public String getType() {
		return ${capFirstModel}AssetRendererFactory.TYPE;
	}

	@Override
	public PortletURL getURLEdit(
			LiferayPortletRequest liferayPortletRequest,
			LiferayPortletResponse liferayPortletResponse)
		throws Exception {

		Group group = GroupLocalServiceUtil.fetchGroup(_entry.getGroupId());

		if (group.isCompany()) {
			ThemeDisplay themeDisplay =
				(ThemeDisplay)liferayPortletRequest.getAttribute(
					WebKeys.THEME_DISPLAY);

			group = themeDisplay.getScopeGroup();
		}

		PortletURL portletURL = PortalUtil.getControlPanelPortletURL(
			liferayPortletRequest, group, ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, 0,
			0, PortletRequest.RENDER_PHASE);

		portletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
		portletURL.setParameter("fromAsset", StringPool.TRUE);
		portletURL.setParameter(Constants.CMD, Constants.UPDATE);
		portletURL.setParameter(
			"resourcePrimKey", String.valueOf(_entry.getPrimaryKey()));

		return portletURL;
	}

	@Override
	public String getUrlTitle() {
		return _entry.getUrlTitle();
	}

	@Override
	public String getURLView(
			LiferayPortletResponse liferayPortletResponse,
			WindowState windowState)
		throws Exception {

		AssetRendererFactory<${capFirstModel}> assetRendererFactory =
			getAssetRendererFactory();

		PortletURL portletURL = assetRendererFactory.getURLView(
			liferayPortletResponse, windowState);

		portletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
		portletURL.setParameter("fromAsset", StringPool.TRUE);
		portletURL.setParameter(Constants.CMD, Constants.VIEW);
		portletURL.setParameter(
			"resourcePrimKey", String.valueOf(_entry.getPrimaryKey()));
		portletURL.setWindowState(windowState);

		return portletURL.toString();
	}

	@Override
	public String getURLViewInContext(
			LiferayPortletRequest liferayPortletRequest,
			LiferayPortletResponse liferayPortletResponse,
			String noSuchEntryRedirect)
		throws PortalException {

		if (_assetDisplayPageFriendlyURLProvider != null) {
			ThemeDisplay themeDisplay =
				(ThemeDisplay)liferayPortletRequest.getAttribute(
					WebKeys.THEME_DISPLAY);

			String friendlyURL =
				_assetDisplayPageFriendlyURLProvider.getFriendlyURL(
					getClassName(), getClassPK(), themeDisplay);

			if (Validator.isNotNull(friendlyURL)) {
				return friendlyURL;
			}
		}

		ThemeDisplay themeDisplay =
			(ThemeDisplay)liferayPortletRequest.getAttribute(
				WebKeys.THEME_DISPLAY);

		if (!_hasViewInContextGroupLayout(_entry.getGroupId(), themeDisplay)) {
			return null;
		}

		return getURLViewInContext(
			liferayPortletRequest, noSuchEntryRedirect, "/${lowercaseModel}/crud",
			"resourcePrimKey", _entry.getPrimaryKey());
	}

	@Override
	public long getUserId() {
		return _entry.getUserId();
	}

	@Override
	public String getUserName() {
		return _entry.getUserName();
	}

	@Override
	public String getUuid() {
		return _entry.getUuid();
	}

	@Override
	public boolean hasEditPermission(PermissionChecker permissionChecker)
		throws PortalException {

		return ${capFirstModel}EntryPermission.contains(
			permissionChecker, _entry, ActionKeys.UPDATE);
	}

	@Override
	public boolean hasViewPermission(PermissionChecker permissionChecker)
		throws PortalException {

		return ${capFirstModel}EntryPermission.contains(
			permissionChecker, _entry, ActionKeys.VIEW);
	}

	@Override
	public boolean include(
			HttpServletRequest request, HttpServletResponse response,
			String template)
		throws Exception {

		request.setAttribute("${uncapFirstModel}", _entry);

		return super.include(request, response, template);
	}

	@Override
	public boolean isPrintable() {
		return true;
	}

	public void setAssetDisplayPageFriendlyURLProvider(
		AssetDisplayPageFriendlyURLProvider
			assetDisplayPageFriendlyURLProvider) {

		_assetDisplayPageFriendlyURLProvider =
			assetDisplayPageFriendlyURLProvider;
	}

	private boolean _hasViewInContextGroupLayout(
		long groupId, ThemeDisplay themeDisplay) {

		try {
			PortletLayoutFinder portletLayoutFinder =
				PortletLayoutFinderRegistryUtil.getPortletLayoutFinder(
					${capFirstModel}.class.getName());

			PortletLayoutFinder.Result result = portletLayoutFinder.find(
				themeDisplay, groupId);

			if ((result == null) || Validator.isNull(result.getPortletId())) {
				return false;
			}

			return true;
		}
		catch (PortalException pe) {
			if (_log.isDebugEnabled()) {
				_log.debug(pe, pe);
			}

			return false;
		}
	}

	private static final Log _log = LogFactoryUtil.getLog(
		${capFirstModel}AssetRenderer.class);

	private AssetDisplayPageFriendlyURLProvider
		_assetDisplayPageFriendlyURLProvider;
	private final ${capFirstModel} _entry;
	private final ResourceBundleLoader _resourceBundleLoader;

}