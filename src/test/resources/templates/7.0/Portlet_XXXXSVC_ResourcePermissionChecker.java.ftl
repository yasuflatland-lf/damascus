<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/service/permission/${capFirstModel}ResourcePermissionChecker.java">

package ${packageName}.service.permission;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.PortletProvider;
import com.liferay.portal.kernel.portlet.PortletProviderUtil;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.permission.BaseResourcePermissionChecker;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.ResourcePermissionChecker;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};

import org.osgi.service.component.annotations.Component;

/**
 * ${capFirstModel} Resource Permission Checker
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    immediate = true,
    property = {"resource.name=" +  ${capFirstModel}ResourcePermissionChecker.RESOURCE_NAME},
    service = ResourcePermissionChecker.class
)
public class ${capFirstModel}ResourcePermissionChecker
    extends BaseResourcePermissionChecker {

    public static final String RESOURCE_NAME = "${packageName}";

    public static void check(
        PermissionChecker permissionChecker, long groupId, String actionId)
        throws PortalException {

        if (!contains(permissionChecker, groupId, actionId)) {
            throw new PrincipalException.MustHavePermission(
                permissionChecker.getUserId(), RESOURCE_NAME, groupId, actionId);
        }
    }

    public static boolean contains(
        PermissionChecker permissionChecker, long classPK, String actionId) {

        String portletId = PortletProviderUtil.getPortletId(
            ${capFirstModel}.class.getName(), PortletProvider.Action.EDIT);

        return contains(
            permissionChecker, RESOURCE_NAME, portletId, classPK, actionId);
    }

    @Override
    public Boolean checkResource(
        PermissionChecker permissionChecker, long classPK, String actionId) {
        return contains(permissionChecker, classPK, actionId);
    }
}