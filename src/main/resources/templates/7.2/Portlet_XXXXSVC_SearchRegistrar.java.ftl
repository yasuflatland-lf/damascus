// <dmsc:root templateName="Portlet_XXXXSVC_SearchRegistrar.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/${capFirstModel}SearchRegistrar.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search;

import com.liferay.portal.kernel.search.Field;
import com.liferay.portal.search.spi.model.index.contributor.ModelIndexerWriterContributor;
import com.liferay.portal.search.spi.model.registrar.ModelSearchRegistrarHelper;
import com.liferay.portal.search.spi.model.result.contributor.ModelSummaryContributor;
import com.liferay.portal.search.spi.model.result.contributor.ModelVisibilityContributor;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceRegistration;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Deactivate;
import org.osgi.service.component.annotations.Reference;
import ${packageName}.model.${capFirstModel};

/**
 * ${capFirstModel} Search Registrar
 *
 * Registers the ${capFirstModel} entity with Liferay's search framework.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	service = {}
)
public class ${capFirstModel}SearchRegistrar {

	@Activate
	protected void activate(BundleContext bundleContext) {
		_serviceRegistration = modelSearchRegistrarHelper.register(
			${capFirstModel}.class, bundleContext,
			modelSearchDefinition -> {
				modelSearchDefinition.setDefaultSelectedFieldNames(
					Field.ASSET_TAG_NAMES, Field.COMPANY_ID, Field.CONTENT,
					Field.ENTRY_CLASS_NAME, Field.ENTRY_CLASS_PK, Field.GROUP_ID,
					Field.MODIFIED_DATE, Field.SCOPE_GROUP_ID, Field.TITLE, Field.UID);

			modelSearchDefinition.setDefaultSelectedLocalizedFieldNames(Field.TITLE, Field.CONTENT);

			modelSearchDefinition.setModelIndexWriteContributor(modelIndexWriterContributor);
			modelSearchDefinition.setModelSummaryContributor(modelSummaryContributor);
			modelSearchDefinition.setModelVisibilityContributor(modelVisibilityContributor);
		});
	}

	@Deactivate
	protected void deactivate() {
		_serviceRegistration.unregister();
	}

	@Reference(target = "(indexer.class.name=${packageName}.model.${capFirstModel})")
	protected ModelIndexerWriterContributor<${capFirstModel}> modelIndexWriterContributor;

	@Reference
	protected ModelSearchRegistrarHelper modelSearchRegistrarHelper;

	@Reference(target = "(indexer.class.name=${packageName}.model.${capFirstModel})")
	protected ModelSummaryContributor modelSummaryContributor;

	@Reference(target = "(indexer.class.name=${packageName}.model.${capFirstModel})")
	protected ModelVisibilityContributor modelVisibilityContributor;

	private ServiceRegistration<?> _serviceRegistration;
}