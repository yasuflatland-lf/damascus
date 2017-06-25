<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-service/src/main/java/${packagePath}/service/permission/${capFirstModel}PermissionChecker.java">

package ${application.packageName}.service.permission;

import com.liferay.exportimport.kernel.staging.permission.StagingPermissionUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.portlet.PortletProvider;
import com.liferay.portal.kernel.portlet.PortletProviderUtil;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.BaseModelPermissionChecker;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.workflow.permission.WorkflowPermissionUtil;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalServiceUtil;

import org.osgi.service.component.annotations.Component;

/**
 * @author Yasuyuki Takeo
 */
@Component(
    immediate = true,
    property = {"model.class.name=${application.packageName}.model.${capFirstModel}" }
)
public class ${capFirstModel}PermissionChecker
    implements BaseModelPermissionChecker {

    public static void check(
        PermissionChecker permissionChecker, ${capFirstModel} entry, String actionId)
        throws PortalException {

        if (!contains(permissionChecker, entry, actionId)) {
            throw new PrincipalException.MustHavePermission(
                permissionChecker,${capFirstModel}.class.getName(),
                entry.getPrimaryKey(), actionId);
        }
    }

    public static void check(
        PermissionChecker permissionChecker, long entryId, String actionId)
        throws PortalException, SystemException {

        if (!contains(permissionChecker, entryId, actionId)) {
            throw new PrincipalException.MustHavePermission(
                permissionChecker, ${capFirstModel}.class.getName(),
                entryId, actionId);
        }
    }

    public static boolean contains(
        PermissionChecker permissionChecker, ${capFirstModel} entry, String actionId) {

        if (entry.isDraft() || entry.isScheduled()) {
            if (actionId.equals(ActionKeys.VIEW)
                && !contains(permissionChecker, entry, ActionKeys.UPDATE)) {

                return false;
            }
        } else if (entry.isPending()) {
            Boolean hasPermission = WorkflowPermissionUtil.hasPermission(
                permissionChecker, entry.getGroupId(), ${capFirstModel}.class.getName(),
                entry.getPrimaryKey(), actionId);

            if (hasPermission != null) {
                return hasPermission.booleanValue();
            }
        }

        if (permissionChecker.hasOwnerPermission(
            entry.getCompanyId(),${capFirstModel}.class.getName(),
            entry.getPrimaryKey(), entry.getUserId(),actionId)) {

            return true;
        }

        return permissionChecker.hasPermission(
            entry.getGroupId(), ${capFirstModel}.class.getName(),
            entry.getPrimaryKey(), actionId);
    }

    public static boolean contains(
        PermissionChecker permissionChecker, long entryId, String actionId)
        throws PortalException, SystemException {

        ${capFirstModel} entry = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(entryId);

        return contains(permissionChecker, entry, actionId);
    }

    @Override
    public void checkBaseModel(
        PermissionChecker permissionChecker, long groupId, long primaryKey,
        String actionId) throws PortalException {

        check(permissionChecker, primaryKey, actionId);

    }
}
