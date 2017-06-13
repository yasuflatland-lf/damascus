<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-service/src/main/java/${packagePath}/trash/${capFirstModel}TrashHandler.java">

package ${application.packageName}.trash;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.PortletURLFactoryUtil;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.trash.BaseTrashHandler;
import com.liferay.portal.kernel.trash.TrashHandler;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.Portal;
import com.liferay.portal.kernel.util.WebKeys;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalService;
import ${application.packageName}.service.permission.${capFirstModel}PermissionChecker;

import javax.portlet.PortletRequest;
import javax.portlet.PortletURL;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * Trash handler
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    property = {"model.class.name=${application.packageName}.model.${capFirstModel}"},
    service = TrashHandler.class
)
public class ${capFirstModel}TrashHandler
    extends BaseTrashHandler {

    @Override
    public void deleteTrashEntry(long classPK) throws PortalException {
        _${uncapFirstModel}LocalService.deleteEntry(classPK);
    }

    @Override
    public String getClassName() {
        return ${capFirstModel}.class.getName();
    }

    @Override
    public String getRestoreContainedModelLink(
        PortletRequest portletRequest, long classPK)
        throws PortalException {

        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(classPK);

        PortletURL portletURL = getRestoreURL(portletRequest, classPK, true);

        portletURL.setParameter(Constants.CMD, Constants.UPDATE);
        portletURL.setParameter("resourcePrimKey", String.valueOf(entry.getPrimaryKey()));

        return portletURL.toString();
    }

    @Override
    public String getRestoreContainerModelLink(
        PortletRequest portletRequest, long classPK)
        throws PortalException {
        PortletURL portletURL = getRestoreURL(portletRequest, classPK, true);

        return portletURL.toString();
    }

    @Override
    public String getRestoreMessage(
        PortletRequest portletRequest, long classPK) {

        ThemeDisplay themeDisplay = (ThemeDisplay)portletRequest.getAttribute(
            WebKeys.THEME_DISPLAY);

        return themeDisplay.translate("${capFirstModel}");
    }

    @Override
    public boolean isInTrash(long classPK) throws PortalException {
        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(classPK);

        return entry.isInTrash();
    }

    @Override
    public void restoreTrashEntry(long userId, long classPK)
        throws PortalException {

        _${uncapFirstModel}LocalService.restoreEntryFromTrash(userId, classPK);
    }

    protected PortletURL getRestoreURL(
        PortletRequest portletRequest, long classPK, boolean containerModel)
        throws PortalException {

        PortletURL portletURL = null;

        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(classPK);

        long plid = _portal.getPlidFromPortletId(entry.getGroupId(), ${capFirstModel}PortletKeys.${uppercaseModel});

        portletURL = PortletURLFactoryUtil.create(
            portletRequest, ${capFirstModel}PortletKeys.${uppercaseModel}, plid,
            PortletRequest.RENDER_PHASE);

        if (!containerModel) {
            portletURL.setParameter(
                "mvcRenderCommandName", "/${lowercaseModel}/crud");
        } else {
            portletURL.setParameter(
                "mvcRenderCommandName", "/${lowercaseModel}/view");
        }

        return portletURL;
    }

    @Override
    protected boolean hasPermission(
        PermissionChecker permissionChecker, long classPK, String actionId)
        throws PortalException {

        return ${capFirstModel}PermissionChecker.contains(
            permissionChecker, classPK, actionId);
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(
        ${capFirstModel}LocalService ${uncapFirstModel}localservice) {
        _${uncapFirstModel}LocalService = ${uncapFirstModel}localservice;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

    @Reference
    private Portal _portal;
}
