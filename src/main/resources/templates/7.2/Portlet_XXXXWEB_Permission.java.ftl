// <dmsc:root templateName="Portlet_XXXXWEB_Permission.java.ftl"  />

package ${packageName}.web.internal.security.permission.resource;

import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;
import ${packageName}.constants.${capFirstModel}Constants;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 *　Permission
 *
 * @author ${damascus_author}
 */
@Component(immediate = true, service = {})
public class ${capFirstModel}Permission {

	public static boolean contains(
		PermissionChecker permissionChecker, long groupId, String actionId) {

		return _portletResourcePermission.contains(
			permissionChecker, groupId, actionId);
	}

	@Reference(
		target = "(resource.name=" + ${capFirstModel}Constants.RESOURCE_NAME + ")",
		unbind = "-"
	)
	protected void setPortletResourcePermission(
		PortletResourcePermission portletResourcePermission) {

		_portletResourcePermission = portletResourcePermission;
	}

	private static PortletResourcePermission _portletResourcePermission;

}