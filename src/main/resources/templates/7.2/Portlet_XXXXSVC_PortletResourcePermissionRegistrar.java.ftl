// <dmsc:root templateName="Portlet_XXXXSVC_PortletResourcePermissionRegistrar.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/security/permission/resource/${capFirstModel}PortletResourcePermissionRegistrar.java">
/* </dmsc:sync> */ 

package ${packageName}.internal.security.permission.resource;

import com.liferay.exportimport.kernel.staging.permission.StagingPermission;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermissionFactory;
import com.liferay.portal.kernel.security.permission.resource.StagedPortletPermissionLogic;
import com.liferay.portal.kernel.util.HashMapDictionary;
import ${packageName}.constants.${capFirstModel}Constants;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import java.util.Dictionary;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceRegistration;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;

/**
 * Portlet Resource Permission Regsitra
 *
 * @author ${damascus_author}
 */
@Component(immediate = true, service = {})
public class ${capFirstModel}PortletResourcePermissionRegistrar {

	@Activate
	public void activate(BundleContext bundleContext) {
		Dictionary<String, Object> properties = new HashMapDictionary<>();

		properties.put("resource.name", ${capFirstModel}Constants.RESOURCE_NAME);

		_serviceRegistration = bundleContext.registerService(
			PortletResourcePermission.class,
			PortletResourcePermissionFactory.create(
				${capFirstModel}Constants.RESOURCE_NAME,
				new StagedPortletPermissionLogic(
					_stagingPermission, ${capFirstModel}PortletKeys.${uppercaseModel})),
			properties);
	}

	@Deactivate
	public void deactivate() {
		_serviceRegistration.unregister();
	}

	private ServiceRegistration<PortletResourcePermission> _serviceRegistration;

	@Reference
	private StagingPermission _stagingPermission;

}