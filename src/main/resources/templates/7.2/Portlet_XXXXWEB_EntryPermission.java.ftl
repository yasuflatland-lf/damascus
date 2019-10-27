// <dmsc:root templateName="Portlet_XXXXWEB_EntryPermission.java.ftl"  />

package ${packageName}.web.internal.security.permission.resource;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import ${packageName}.model.${capFirstModel};

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferencePolicy;
import org.osgi.service.component.annotations.ReferencePolicyOption;

/**
 * Entry　Permission
 *
 * @author ${damascus_author}
 */
@Component(immediate = true, service = {})
public class ${capFirstModel}EntryPermission {

	public static boolean contains(
			PermissionChecker permissionChecker, long entryId, String actionId)
		throws PortalException {

		return _${uncapFirstModel}ModelResourcePermission.contains(
			permissionChecker, entryId, actionId);
	}

	public static boolean contains(
			PermissionChecker permissionChecker, ${capFirstModel} entry,
			String actionId)
		throws PortalException {

		return _${uncapFirstModel}ModelResourcePermission.contains(
			permissionChecker, entry, actionId);
	}

	@Reference(
		policy = ReferencePolicy.DYNAMIC,
		policyOption = ReferencePolicyOption.GREEDY,
		target = "(model.class.name=${packageName}.model.${capFirstModel})"
	)
	protected void set${capFirstModel}ModelResourcePermission(
		ModelResourcePermission<${capFirstModel}> modelResourcePermission) {

		_${uncapFirstModel}ModelResourcePermission = modelResourcePermission;
	}

	protected void unset${capFirstModel}ModelResourcePermission(
		ModelResourcePermission<${capFirstModel}> modelResourcePermission) {
	}

	private static ModelResourcePermission<${capFirstModel}>
		_${uncapFirstModel}ModelResourcePermission;

}