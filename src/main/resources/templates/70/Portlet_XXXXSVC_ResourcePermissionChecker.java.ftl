<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-service/src/main/java/${packagePath}/service/permission/${capFirstModel}ResourcePermissionChecker.java">

package ${application.packageName}.service.permission;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.permission.BaseResourcePermissionChecker;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.ResourcePermissionChecker;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;

import org.osgi.service.component.annotations.Component;

/**
 * @author Yasuyuki Takeo
 */
@Component(
    immediate = true,
    property = {"resource.name=" +  ${capFirstModel}ResourcePermissionChecker.RESOURCE_NAME},
    service = ResourcePermissionChecker.class
)
public class ${capFirstModel}ResourcePermissionChecker
    extends BaseResourcePermissionChecker {

    public static final String RESOURCE_NAME = "${application.packageName}";

    public static void check(
        PermissionChecker permissionChecker, long groupId, String actionId)
        throws PortalException {

        if (!contains(permissionChecker, groupId, actionId)) {
            throw new PrincipalException.MustHavePermission(
                permissionChecker, RESOURCE_NAME, groupId, actionId);
        }
    }

    public static boolean contains(
        PermissionChecker permissionChecker, long classPK, String actionId) {

        return contains(
            permissionChecker, RESOURCE_NAME, ${capFirstModel}PortletKeys.${uppercaseModel},
            classPK, actionId);
    }

    @Override
    public Boolean checkResource(
        PermissionChecker permissionChecker, long classPK, String actionId) {
        return contains(permissionChecker, classPK, actionId);
    }
}