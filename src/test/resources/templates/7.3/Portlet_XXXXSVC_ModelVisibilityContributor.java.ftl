// <dmsc:root templateName="Portlet_XXXXSVC_ModelVisibilityContributor.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/result/contributor/${capFirstModel}ModelVisibilityContributor.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search.result.contributor;

import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.search.spi.model.result.contributor.ModelVisibilityContributor;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Model Visibility Contributor
 *
 * Controls the visibility of entities that can be attached to other asset types in the search context.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "indexer.class.name=${packageName}.model.${capFirstModel}",
	service = ModelVisibilityContributor.class
)
public class ${capFirstModel}ModelVisibilityContributor implements ModelVisibilityContributor {

	@Override
	public boolean isVisible(long classPK, int status) {

		${capFirstModel} entry = _${uncapFirstModel}LocalService.fetch${capFirstModel}(classPK);

		if (entry == null) {
			return false;
		}

		return isVisible(entry.getStatus(), status);
	}

	protected boolean isVisible(int entryStatus, int queryStatus) {
		if (((queryStatus != WorkflowConstants.STATUS_ANY) && (entryStatus == queryStatus)) || (entryStatus != WorkflowConstants.STATUS_IN_TRASH)) {
			return true;
		}

		return false;
	}

	@Reference
	protected ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
}