// <dmsc:root templateName="Portlet_XXXXSVC_ServiceImpl.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/service/impl/${capFirstModel}ServiceImpl.java">
/* </dmsc:sync> */ 


package ${packageName}.service.impl;

import com.liferay.portal.aop.AopService;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.security.auth.PrincipalException;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermissionFactory;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import ${packageName}.constants.${capFirstModel}Constants;
import ${packageName}.exception.${capFirstModel}ValidateException;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.base.${capFirstModel}ServiceBaseImpl;

import javax.portlet.PortletException;
import javax.portlet.PortletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferencePolicy;
import org.osgi.service.component.annotations.ReferencePolicyOption;

/**
 * The implementation of the ${capFirstModel} remote service.
 *
 * <p>
 * All custom service methods should be put in this class. Whenever methods are added, rerun ServiceBuilder to copy their definitions into the <code>${packageName}.service.${capFirstModel}Service</code> interface.
 *
 * <p>
 * This is a remote service. Methods of this service are expected to have security checks based on the propagated JAAS credentials because this service can be accessed remotely.
 * </p>
 *
 * @author ${damascus_author}
 * @see ${capFirstModel}ServiceBaseImpl
 */
@Component(
	property = {
		"json.web.service.context.name=${lowercaseModel}",
		"json.web.service.context.path=${capFirstModel}"
	},
	service = AopService.class
)
public class ${capFirstModel}ServiceImpl extends ${capFirstModel}ServiceBaseImpl {

	/**
	 * Add Entry
	 *
	 * @param orgEntry       ${capFirstModel} model
	 * @param serviceContext ServiceContext
	 * @exception PortalException
	 * @exception ${capFirstModel}ValidateException
	 * @return created ${capFirstModel} model.
	 */
	@Override
	public ${capFirstModel} addEntry(${capFirstModel} orgEntry, ServiceContext serviceContext)
		throws PortalException, ${capFirstModel}ValidateException {

		_portletResourcePermission.check(
			getPermissionChecker(), serviceContext.getScopeGroupId(),
			ActionKeys.ADD_ENTRY);

		return ${uncapFirstModel}LocalService.addEntry(orgEntry, serviceContext);
	}

	/**
	 * Delete Entry
	 *
	 * @param primaryKey
	 * @return ${capFirstModel}
	 * @throws PortalException
	 */
	public void deleteEntry(long primaryKey) throws PortalException {
		_${uncapFirstModel}ModelResourcePermission.check(
			getPermissionChecker(), primaryKey, ActionKeys.DELETE);

		${uncapFirstModel}LocalService.deleteEntry(primaryKey);
	}

	/**
	 * Populate Model with values from a form
	 *
	 * @param primaryKey primary key
	 * @param request    PortletRequest
	 * @return ${capFirstModel} Object
	 * @throws PortletException
	 * @throws PortalException
	 */
	public ${capFirstModel} getInitialized${capFirstModel}(
			long primaryKey, PortletRequest request)
		throws PortalException, PortletException {

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			request);

		_portletResourcePermission.check(
			getPermissionChecker(), serviceContext.getScopeGroupId(),
			ActionKeys.ADD_ENTRY);

		return ${uncapFirstModel}LocalService.getNewObject(primaryKey);
	}

	/**
	 * Get Record
	 *
	 * @param primaryKey Primary key
	 * @return ServiceContext serviceContext
	 * @throws PrincipalException
	 * @throws PortletException
	 */
	public ${capFirstModel} getNewObject(long primaryKey, ServiceContext serviceContext)
		throws PrincipalException {

		primaryKey = (primaryKey <= 0) ? 0 :
		counterLocalService.increment(${capFirstModel}.class.getName());

		_portletResourcePermission.check(
			getPermissionChecker(), serviceContext.getScopeGroupId(),
			ActionKeys.UPDATE);

		return ${uncapFirstModel}LocalService.getNewObject(primaryKey);
	}

	/**
	 * Returns the ${lowercaseModel} with the primary key.
	 *
	 * @param ${lowercaseModel}Id the primary key of the sample sb
	 * @return the ${lowercaseModel}
	 * @throws PortalException if a ${lowercaseModel} with the primary key could not be found
	 */
	@Override
	public ${capFirstModel} get${capFirstModel}(long primaryKey) throws PortalException {
		_${uncapFirstModel}ModelResourcePermission.check(
			getPermissionChecker(), primaryKey, ActionKeys.VIEW);

		return ${uncapFirstModel}LocalService.get${capFirstModel}(primaryKey);
	}

	/**
	 * Returns the ${lowercaseModel}
	 *
	 * @param groupId
	 * @param urlTitle
	 * @return
	 * @throws PortalException
	 */
	public ${capFirstModel} get${capFirstModel}(long groupId, String urlTitle)
		throws PortalException {

		${capFirstModel} entry = ${uncapFirstModel}LocalService.get${capFirstModel}(groupId, urlTitle);

		_${uncapFirstModel}ModelResourcePermission.check(
			getPermissionChecker(), entry, ActionKeys.VIEW);

		return entry;
	}

	/**
	 * Populate Model with values from a form
	 *
	 * @param request PortletRequest
	 * @return ${capFirstModel} Object
	 * @throws PortletException
	 * @throws PortalException
	 */
	public ${capFirstModel} get${capFirstModel}FromRequest(
			long primaryKey, PortletRequest request)
		throws PortalException, PortletException {

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			request);

		_portletResourcePermission.check(
			getPermissionChecker(), serviceContext.getScopeGroupId(),
			ActionKeys.VIEW);

		return ${uncapFirstModel}LocalService.get${capFirstModel}FromRequest(primaryKey, request);
	}

	/**
	 * Move an entry to the trush can
	 *
	 * @param userId
	 * @param entryId
	 * @return ${capFirstModel}
	 * @throws PortalException
	 */
	public ${capFirstModel} moveEntryToTrash(long entryId) throws PortalException {
		_${uncapFirstModel}ModelResourcePermission.check(
			getPermissionChecker(), entryId, ActionKeys.DELETE);

		return ${uncapFirstModel}LocalService.moveEntryToTrash(getUserId(), entryId);
	}

	/**
	 * Edit Entry
	 *
	 * @param orgEntry       ${capFirstModel} model
	 * @param serviceContext ServiceContext
	 * @exception PortalException
	 * @exception ${capFirstModel}ValidateException
	 * @return updated ${capFirstModel} model.
	 */
	@Override
	public ${capFirstModel} updateEntry(
			${capFirstModel} orgEntry, ServiceContext serviceContext)
		throws PortalException, ${capFirstModel}ValidateException {

		_${uncapFirstModel}ModelResourcePermission.check(
			getPermissionChecker(), orgEntry.getPrimaryKey(),
			ActionKeys.UPDATE);

		return ${uncapFirstModel}LocalService.updateEntry(orgEntry, serviceContext);
	}

	private static volatile ModelResourcePermission<${capFirstModel}>
		_${uncapFirstModel}ModelResourcePermission =
			ModelResourcePermissionFactory.getInstance(
				${capFirstModel}ServiceImpl.class, "_${uncapFirstModel}ModelResourcePermission",
				${capFirstModel}.class);

	@Reference(
		policy = ReferencePolicy.DYNAMIC,
		policyOption = ReferencePolicyOption.GREEDY,
		target = "(resource.name=" + ${capFirstModel}Constants.RESOURCE_NAME + ")"
	)
	private volatile PortletResourcePermission _portletResourcePermission;

}