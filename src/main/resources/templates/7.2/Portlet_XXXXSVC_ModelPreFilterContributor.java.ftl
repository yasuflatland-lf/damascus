// <dmsc:root templateName="Portlet_XXXXSVC_ModelPreFilterContributor.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/query/contributor/${capFirstModel}ModelPreFilterContributor.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search.query.contributor;

import com.liferay.portal.kernel.search.SearchContext;
import com.liferay.portal.kernel.search.filter.BooleanFilter;
import com.liferay.portal.search.spi.model.query.contributor.ModelPreFilterContributor;
import com.liferay.portal.search.spi.model.registrar.ModelSearchSettings;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Model PreFilter Contributor
 *
 * Filters search results before they are returned from the search engine.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "indexer.class.name=${packageName}.model.${capFirstModel}",
	service = ModelPreFilterContributor.class
)
public class ChallengeModelPreFilterContributor implements ModelPreFilterContributor {

	@Override
	public void contribute(BooleanFilter booleanFilter, ModelSearchSettings modelSearchSettings, SearchContext searchContext) {

		// TODO: Adjust as necessary to filter results that should not normally be included as search results.

		// exclude non-approved entities from the search results.
		addWorkflowStatusFilter(booleanFilter, modelSearchSettings, searchContext);
	}

	protected void addWorkflowStatusFilter(BooleanFilter booleanFilter, ModelSearchSettings modelSearchSettings, SearchContext searchContext) {
		workflowStatusModelPreFilterContributor.contribute(booleanFilter, modelSearchSettings, searchContext);
	}

	@Reference(target = "(model.pre.filter.contributor.id=WorkflowStatus)")
	protected ModelPreFilterContributor workflowStatusModelPreFilterContributor;
}