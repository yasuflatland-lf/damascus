// <dmsc:root templateName="Portlet_XXXXSVC_ModelResourcePermissionRegistrar.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/security/permission/resource/${capFirstModel}ModelResourcePermissionRegistrar.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.security.permission.resource;

import com.liferay.exportimport.kernel.staging.permission.StagingPermission;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermission;
import com.liferay.portal.kernel.security.permission.resource.ModelResourcePermissionFactory;
import com.liferay.portal.kernel.security.permission.resource.PortletResourcePermission;
import com.liferay.portal.kernel.security.permission.resource.StagedModelPermissionLogic;
import com.liferay.portal.kernel.security.permission.resource.WorkflowedModelPermissionLogic;
import com.liferay.portal.kernel.service.GroupLocalService;
import com.liferay.portal.kernel.util.HashMapDictionary;
import com.liferay.portal.kernel.workflow.permission.WorkflowPermission;
import ${packageName}.constants.${capFirstModel}Constants;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

import java.util.Dictionary;

import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceRegistration;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;

/**
 * Model Resource Permission Registrar
 *
 * @author ${damascus_author}
 *
 */
@Component(immediate = true, service = {})
public class ${capFirstModel}ModelResourcePermissionRegistrar {

	@Activate
	public void activate(BundleContext bundleContext) {
		Dictionary<String, Object> properties = new HashMapDictionary<>();

		properties.put("model.class.name", ${capFirstModel}.class.getName());

		_serviceRegistration = bundleContext.registerService(
			ModelResourcePermission.class,
			ModelResourcePermissionFactory.create(
				${capFirstModel}.class, ${capFirstModel}::getPrimaryKey,
				_${lowercaseModel}LocalService::get${capFirstModel}, _portletResourcePermission,
				(modelResourcePermission, consumer) -> {
					consumer.accept(
						new StagedModelPermissionLogic<>(
							_stagingPermission, ${capFirstModel}PortletKeys.${uppercaseModel},
							${capFirstModel}::getPrimaryKey));

					consumer.accept(
						new WorkflowedModelPermissionLogic<>(
							_workflowPermission, modelResourcePermission,
							_groupLocalService, ${capFirstModel}::getPrimaryKey));
				}),
			properties);
	}

	@Deactivate
	public void deactivate() {
		_serviceRegistration.unregister();
	}

	@Reference
	private GroupLocalService _groupLocalService;

	@Reference(
		target = "(resource.name=" + ${capFirstModel}Constants.RESOURCE_NAME + ")"
	)
	private PortletResourcePermission _portletResourcePermission;

	@Reference
	private ${capFirstModel}LocalService _${lowercaseModel}LocalService;

	@SuppressWarnings("rawtypes")
	private ServiceRegistration<ModelResourcePermission> _serviceRegistration;

	@Reference
	private StagingPermission _stagingPermission;

	@Reference
	private WorkflowPermission _workflowPermission;

}