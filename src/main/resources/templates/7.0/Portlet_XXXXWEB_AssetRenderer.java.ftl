<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/asset/${capFirstModel}AssetRenderer.java">
<#assign skipTemplate = !generateWeb>
package ${packageName}.web.asset;

import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.model.BaseJSPAssetRenderer;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.model.Group;
import com.liferay.portal.kernel.model.LayoutConstants;
import com.liferay.portal.kernel.model.PortletPreferences;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portal.kernel.service.PortletPreferencesLocalServiceUtil;
import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.service.GroupLocalServiceUtil;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.trash.TrashRenderer;
import com.liferay.portal.kernel.util.ArrayUtil;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.PortletKeys;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.WebKeys;


import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.permission.${capFirstModel}PermissionChecker;

import java.util.List;
import java.util.Locale;

import javax.portlet.PortletRequest;
import javax.portlet.PortletResponse;
import javax.portlet.PortletURL;
import javax.portlet.WindowState;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
public class ${capFirstModel}AssetRenderer
    extends BaseJSPAssetRenderer<${capFirstModel}>
    implements TrashRenderer {

    public ${capFirstModel}AssetRenderer(${capFirstModel} entry) {
        _entry = entry;
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
        } else {
            return null;
        }
    }

    @Override
    public String getPortletId() {
        AssetRendererFactory<${capFirstModel}> assetRendererFactory = getAssetRendererFactory();

        return assetRendererFactory.getPortletId();
    }

    @Override
    public int getStatus() {
        return _entry.getStatus();
    }

    @Override
    public String getSummary(
        PortletRequest portletRequest, PortletResponse portletResponse) {
        <#if application.asset.assetSummaryFieldName?? && application.asset.assetSummaryFieldName != "" >
        return HtmlUtil.stripHtml(_entry.get${application.asset.assetSummaryFieldName?cap_first}());
        <#else>
        // TODO : This need to be customized
        return HtmlUtil.stripHtml("Asset Renderer need to be implimented");
        </#if>
    }

    @Override
    public String getTitle(Locale locale) {
        <#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
        return _entry.get${application.asset.assetTitleFieldName?cap_first}();
        <#else>
        // TODO : This need to be customized
        return "Asset Renderer need to be implimented";
        </#if>
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

        PortletURL portletURL = PortalUtil.getControlPanelPortletURL(
            liferayPortletRequest, group, ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, 0, 0,
            PortletRequest.RENDER_PHASE);

        portletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
        portletURL.setParameter("fromAsset", StringPool.TRUE);
        portletURL.setParameter(Constants.CMD, Constants.UPDATE);
        portletURL.setParameter("resourcePrimKey", String.valueOf(_entry.getPrimaryKey()));

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
        portletURL.setWindowState(windowState);
        portletURL.setParameter("resourcePrimKey", String.valueOf(_entry.getPrimaryKey()));

        return portletURL.toString();
    }

    @Override
    public String getURLViewInContext(
        LiferayPortletRequest liferayPortletRequest,
        LiferayPortletResponse liferayPortletResponse,
        String noSuchEntryRedirect) {

        try {
            ThemeDisplay themeDisplay = (ThemeDisplay) liferayPortletRequest.getAttribute(WebKeys.THEME_DISPLAY);
            long plid = getPlidsFromPreferenceValue(themeDisplay.getScopeGroupId(), ${capFirstModel}PortletKeys.${uppercaseModel}, false); 
            String namespace = getPortletInstanceFromPreferenceValue(themeDisplay.getScopeGroupId(), ${capFirstModel}PortletKeys.${uppercaseModel}, false);

            PortletURL portletURL;

            if (plid == LayoutConstants.DEFAULT_PLID) {
                portletURL = liferayPortletResponse.createLiferayPortletURL(plid, namespace, PortletRequest.RENDER_PHASE);
            } else {
                portletURL = PortletURLFactoryUtil.create(liferayPortletRequest, namespace, plid, PortletRequest.RENDER_PHASE);
            }

            portletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
            portletURL.setParameter(Constants.CMD, Constants.VIEW);
            portletURL.setParameter("resourcePrimKey", String.valueOf(_entry.getPrimaryKey()));
        
            String currentUrl = PortalUtil.getCurrentURL(liferayPortletRequest);
        
            portletURL.setParameter("redirect", currentUrl);
        
            return portletURL.toString();
        
            } catch (SystemException e) {
            }
        
            return noSuchEntryRedirect;
    }

    private static long getPlidsFromPreferenceValue(long groupId, String portletId, boolean privateLayout) {
		Group group = GroupLocalServiceUtil.fetchGroup(groupId);

		long[] plids = new long[0];

		if (group != null) {
			List<PortletPreferences> portletPreferences = PortletPreferencesLocalServiceUtil.getPortletPreferences(group.getCompanyId(), groupId, PortletKeys.PREFS_OWNER_ID_DEFAULT, PortletKeys.PREFS_OWNER_TYPE_LAYOUT, portletId, privateLayout);

			for (PortletPreferences curPortletPreferences : portletPreferences) {
                plids = ArrayUtil.append(plids, curPortletPreferences.getPlid());
			}
		}

        if (ArrayUtil.isEmpty(plids))
			return LayoutConstants.DEFAULT_PLID;
		else
			return plids[0];
    }
    
    private static String getPortletInstanceFromPreferenceValue(long groupId, String portletId, boolean privateLayout) {
		Group group = GroupLocalServiceUtil.fetchGroup(groupId);

		String[] plids = new String[0];

		if (group != null) {
			List<PortletPreferences> portletPreferences = PortletPreferencesLocalServiceUtil.getPortletPreferences(group.getCompanyId(), groupId, PortletKeys.PREFS_OWNER_ID_DEFAULT, PortletKeys.PREFS_OWNER_TYPE_LAYOUT, portletId, privateLayout);

			for (PortletPreferences curPortletPreferences : portletPreferences) {
                plids = ArrayUtil.append(plids, curPortletPreferences.getPortletId());
			}
		}

        if (ArrayUtil.isEmpty(plids))
			return portletId;
		else
			return plids[0];
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
    public boolean hasEditPermission(PermissionChecker permissionChecker) {
        return ${capFirstModel}PermissionChecker.contains(permissionChecker, _entry,
                                                  ActionKeys.UPDATE);
    }

    @Override
    public boolean hasViewPermission(PermissionChecker permissionChecker) {
        return ${capFirstModel}PermissionChecker.contains(permissionChecker, _entry,
                                                  ActionKeys.VIEW);
    }

    @Override
    public boolean include(
        HttpServletRequest request, HttpServletResponse response,
        String template) throws Exception {
        request.setAttribute("${uncapFirstModel}", _entry);

        return super.include(request, response, template);
    }

    @Override
    public boolean isPrintable() {
        return true;
    }

    private final ${capFirstModel} _entry;

}
