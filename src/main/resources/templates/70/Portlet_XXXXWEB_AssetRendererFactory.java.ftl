<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/asset/${capFirstModel}AssetRendererFactory.java">

package ${application.packageName}.web.asset;

import com.liferay.asset.kernel.model.AssetRenderer;
import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.model.BaseAssetRendererFactory;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.LiferayPortletURL;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.Portal;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalService;
import ${application.packageName}.service.permission.${capFirstModel}PermissionChecker;
import ${application.packageName}.service.permission.${capFirstModel}ResourcePermissionChecker;

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
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    immediate = true,
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}
    },
    service = AssetRendererFactory.class
)
public class ${capFirstModel}AssetRendererFactory extends BaseAssetRendererFactory<${capFirstModel}> {

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
    public AssetRenderer<${capFirstModel}> getAssetRenderer(long classPK, int type) throws PortalException {
        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(classPK);

        ${capFirstModel}AssetRenderer ${uncapFirstModel}AssetRenderer =
            new ${capFirstModel}AssetRenderer(entry);

        ${uncapFirstModel}AssetRenderer.setAssetRendererType(type);
        ${uncapFirstModel}AssetRenderer.setServletContext(_servletContext);

        return ${uncapFirstModel}AssetRenderer;
    }

    @Override
    public AssetRenderer<${capFirstModel}> getAssetRenderer(
        long groupId, String urlTitle)
        throws PortalException {

        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}ByUrlTitle(
            groupId, urlTitle, WorkflowConstants.STATUS_ANY);

        if(Validator.isNull(entry)) {
            return null;
        }

        return new ${capFirstModel}AssetRenderer(entry);
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

        LiferayPortletURL liferayPortletURL =
            liferayPortletResponse.createLiferayPortletURL(
                ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, PortletRequest.RENDER_PHASE);

        liferayPortletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/crud");
        liferayPortletURL.setParameter(Constants.CMD, Constants.ADD);
        liferayPortletURL.setParameter("fromAsset", StringPool.TRUE);

        return liferayPortletURL;
    }

    @Override
    public PortletURL getURLView(
        LiferayPortletResponse liferayPortletResponse,
        WindowState windowState) {

        LiferayPortletURL liferayPortletURL =
            liferayPortletResponse.createLiferayPortletURL(
                ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, PortletRequest.RENDER_PHASE);

        liferayPortletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/view");
        liferayPortletURL.setParameter(Constants.CMD, Constants.VIEW);
        liferayPortletURL.setParameter("fromAsset", StringPool.TRUE);

        try {
            liferayPortletURL.setWindowState(windowState);
        }
        catch (WindowStateException wse) {
            _log.error("Windos state is not valid. Skip.");
        }

        return liferayPortletURL;
    }

    @Override
    public boolean hasAddPermission(
        PermissionChecker permissionChecker, long groupId, long classTypeId)
        throws Exception {

        if( !${capFirstModel}ResourcePermissionChecker.contains(
            permissionChecker, groupId, ActionKeys.VIEW) ) {
            return false;
        }

        return ${capFirstModel}ResourcePermissionChecker.contains(
            permissionChecker, groupId, ActionKeys.ADD_ENTRY);
    }

    @Override
    public boolean hasPermission(
        PermissionChecker permissionChecker, long classPK, String actionId)
        throws Exception {

        return ${capFirstModel}PermissionChecker.contains(
            permissionChecker, classPK, actionId);
    }

    @Reference(
        target = "(osgi.web.symbolicname=${application.packageName}.web)", unbind = "-"
    )
    public void setServletContext(ServletContext servletContext) {
        _servletContext = servletContext;
    }

    @Reference
    private Portal _portal;
    @Reference
    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

    private ServletContext       _servletContext;

    private static final Log _log = LogFactoryUtil.getLog(
        ${capFirstModel}AssetRendererFactory.class);
}
