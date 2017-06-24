<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/asset/${capFirstModel}AssetRenderer.java">
package ${application.packageName}.web.asset;

import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.model.BaseJSPAssetRenderer;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.LiferayPortletURL;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.trash.TrashRenderer;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.HtmlUtil;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.permission.${capFirstModel}PermissionChecker;

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
            return "/asset/" + template + ".jsp";
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

        LiferayPortletURL liferayPortletURL =
            liferayPortletResponse.createLiferayPortletURL(
                ${capFirstModel}PortletKeys.${uppercaseModel}, PortletRequest.RENDER_PHASE);

        liferayPortletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
        liferayPortletURL.setParameter(Constants.CMD, Constants.UPDATE);
        liferayPortletURL.setParameter("resourcePrimKey", String.valueOf(_entry.getPrimaryKey()));

        return liferayPortletURL;
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

        return getURLViewInContext(
            liferayPortletRequest, noSuchEntryRedirect, ${capFirstModel}PortletKeys.${uppercaseModel}_FIND_ENTRY,
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
