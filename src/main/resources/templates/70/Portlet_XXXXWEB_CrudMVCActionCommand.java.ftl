<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}CrudMVCActionCommand.java">

package ${application.packageName}.web.portlet.action;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.TrashedModel;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.WebKeys;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.exception.${capFirstModel}ValidateException;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalService;
import ${application.packageName}.service.permission.${capFirstModel}PermissionChecker;
import ${application.packageName}.service.permission.${capFirstModel}ResourcePermissionChecker;
import com.liferay.trash.kernel.util.TrashUtil;

import java.util.ArrayList;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    immediate = true, property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "mvc.command.name=/${lowercaseModel}/crud"
    },
    service = MVCActionCommand.class
)
public class ${capFirstModel}CrudMVCActionCommand
    extends BaseMVCActionCommand {

    @Override
    protected void doProcessAction(ActionRequest request, ActionResponse response) {

        try {
            // Fetch command
            String cmd = ParamUtil.getString(request, Constants.CMD);

            if (cmd.equals(Constants.ADD)) {
                addEntry(request, response);

            } else if (cmd.equals(Constants.UPDATE)) {
                updateEntry(request, response);

            } else if (cmd.equals(Constants.DELETE)) {
                deleteEntry(request, response, false);

            } else if (cmd.equals(Constants.MOVE_TO_TRASH)) {
                deleteEntry(request, response, true);

            }
        } catch (${capFirstModel}ValidateException e) {
            for (String error : e.getErrors()) {
                SessionErrors.add(request, error);
            }
            PortalUtil.copyRequestParameters(request, response);
            response.setRenderParameter(
                "mvcRenderCommandName",
                "/${lowercaseModel}/crud");
            hideDefaultSuccessMessage(request);
        } catch (Throwable t) {

            _log.error(t, t);
            SessionErrors.add(request, PortalException.class);
            hideDefaultSuccessMessage(request);
        }
    }

    /**
     * Delte Entry
     *
     * @param request
     * @param response
     * @param moveToTrash true to move to trush.
     * @throws PortalException
     * @throws Exception
     */
    public void deleteEntry(
        ActionRequest request, ActionResponse response, boolean moveToTrash)
        throws PortalException {
        long[] deleteEntryIds = null;
        ThemeDisplay themeDisplay = (ThemeDisplay) request
            .getAttribute(WebKeys.THEME_DISPLAY);
        PermissionChecker permissionChecker = themeDisplay
            .getPermissionChecker();

        long entryId = ParamUtil.getLong(request, "resourcePrimKey", 0L);

        if (entryId > 0) {
            deleteEntryIds = new long[] {
                entryId };
        } else {
            deleteEntryIds = StringUtil
                .split(ParamUtil.getString(request, "deleteEntryIds"), 0L);
        }

        List<TrashedModel> trashedModels = new ArrayList<TrashedModel>();

        for (long deleteEntryId : deleteEntryIds) {

            // Permission check
            if (!${capFirstModel}PermissionChecker.contains(
                    permissionChecker, deleteEntryId, ActionKeys.DELETE)) {
                SessionErrors.add(request, "permission-error for ID - "
                    + String.valueOf(deleteEntryId));
                continue;
            }

            if (moveToTrash) {
                ${capFirstModel} entry = _${uncapFirstModel}LocalService
                    .moveEntryToTrash(themeDisplay.getUserId(), deleteEntryId);

                trashedModels.add(entry);
            } else {
                _${uncapFirstModel}LocalService.deleteEntry(deleteEntryId);
            }
        }

        if (moveToTrash && !trashedModels.isEmpty()) {
            TrashUtil.addTrashSessionMessages(request, trashedModels);

            SessionMessages.add(
                request, SessionMessages.KEY_SUFFIX_HIDE_DEFAULT_SUCCESS_MESSAGE);
        } else {
            SessionMessages.add(request, "${lowercaseModel}-deleted-successfully");
        }
    }

    /**
     * Add Entry
     *
     * @param request
     * @param response
     * @throws ${capFirstModel}ValidateException, Exception
     */
    public void addEntry(ActionRequest request, ActionResponse response)
        throws ${capFirstModel}ValidateException, Exception {
        ThemeDisplay themeDisplay = (ThemeDisplay) request
            .getAttribute(WebKeys.THEME_DISPLAY);
        PermissionChecker permissionChecker = themeDisplay
            .getPermissionChecker();

        long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);

        ${capFirstModel} entry = _${uncapFirstModel}LocalService
            .get${capFirstModel}FromRequest(primaryKey, request);

        // Permission check
        if (!${capFirstModel}ResourcePermissionChecker.contains(
                permissionChecker, themeDisplay.getScopeGroupId(), ActionKeys.ADD_ENTRY)) {
            List<String> error = new ArrayList<String>();
            error.add("permission-error");
            throw new ${capFirstModel}ValidateException(error);
        }

        ServiceContext serviceContext = ServiceContextFactory
            .getInstance(${capFirstModel}.class.getName(), request);

        // Add entry
        _${uncapFirstModel}LocalService.addEntry(entry, serviceContext);

        SessionMessages.add(request, "${lowercaseModel}-added-successfully");
    }

    /**
     * Update Entry
     *
     * @param request
     * @param response
     * @throws Exception
     */
    public void updateEntry(ActionRequest request, ActionResponse response)
        throws Exception {
        ThemeDisplay themeDisplay = (ThemeDisplay) request
            .getAttribute(WebKeys.THEME_DISPLAY);
        PermissionChecker permissionChecker = themeDisplay
            .getPermissionChecker();

        long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);

        ${capFirstModel} entry = _${uncapFirstModel}LocalService
            .get${capFirstModel}FromRequest(primaryKey, request);

        // Permission check
        if (!${capFirstModel}PermissionChecker.contains(
                permissionChecker, entry.getPrimaryKey(), ActionKeys.UPDATE)) {
            List<String> error = new ArrayList<String>();
            error.add("permission-error");
            throw new ${capFirstModel}ValidateException(error);
        }

        ServiceContext serviceContext = ServiceContextFactory
            .getInstance(${capFirstModel}.class.getName(), request);

        //Update entry
        _${uncapFirstModel}LocalService.updateEntry(entry, serviceContext);

        SessionMessages.add(request, "${lowercaseModel}-updated-successfully");
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(
        ${capFirstModel}LocalService ${lowercaseModel}localservice) {
        _${uncapFirstModel}LocalService = ${lowercaseModel}localservice;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

    private static Log _log = LogFactoryUtil
        .getLog(${capFirstModel}CrudMVCActionCommand.class);
}