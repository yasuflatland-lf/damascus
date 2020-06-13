// <dmsc:root templateName="Portlet_XXXXSVC_ModelIndexerWriterContributor.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/index/contributor/${capFirstModel}ModelIndexerWriterContributor.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search.index.contributor;

import com.liferay.portal.kernel.dao.orm.Property;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.search.batch.BatchIndexingActionable;
import com.liferay.portal.search.batch.DynamicQueryBatchIndexingActionableFactory;
import com.liferay.portal.search.spi.model.index.contributor.ModelIndexerWriterContributor;
import com.liferay.portal.search.spi.model.index.contributor.helper.IndexerWriterMode;
import com.liferay.portal.search.spi.model.index.contributor.helper.ModelIndexerWriterDocumentHelper;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

/**
 * ${capFirstModel} Model Indexer Writer Contributor
 *
 * This class is used during bulk reindexing to identify records to reindex.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "indexer.class.name=${packageName}.model.${capFirstModel}",
	service = ModelIndexerWriterContributor.class
)
public class ${capFirstModel}ModelIndexerWriterContributor implements ModelIndexerWriterContributor<${capFirstModel}> {

	@Override
	public void customize(BatchIndexingActionable batchIndexingActionable, ModelIndexerWriterDocumentHelper modelIndexerWriterDocumentHelper) {

		// TODO: add criteria to the DQ to select the entities to include in the reindex.
		batchIndexingActionable.setAddCriteriaMethod(dynamicQuery -> {
			Property statusProperty = PropertyFactoryUtil.forName("status");

			Integer[] statuses = {
				WorkflowConstants.STATUS_APPROVED,
				WorkflowConstants.STATUS_IN_TRASH
			};

			// reindex any entry that is approved or in the trash
			dynamicQuery.add(statusProperty.in(statuses));
		});

		// add any matched entry into the documents to index.
		batchIndexingActionable.setPerformActionMethod((${capFirstModel} entry) -> {
			batchIndexingActionable.addDocuments(modelIndexerWriterDocumentHelper.getDocument(entry));
		});
	}

	@Override
	public IndexerWriterMode getIndexerWriterMode(${capFirstModel} entry) {

		// TODO: Update as necessary to control the indexer writer mode for the given entry.

		int status = entry.getStatus();

		if ((status == WorkflowConstants.STATUS_APPROVED) || (status == WorkflowConstants.STATUS_IN_TRASH) || (status == WorkflowConstants.STATUS_DRAFT)) {
			return IndexerWriterMode.UPDATE;
		}

		return IndexerWriterMode.DELETE;
	}

	@Override
	public BatchIndexingActionable getBatchIndexingActionable() {
		return dynamicQueryBatchIndexingActionableFactory.getBatchIndexingActionable(
			_${uncapFirstModel}LocalService.getIndexableActionableDynamicQuery());
	}

	@Override
	public long getCompanyId(${capFirstModel} entry) {
		return entry.getCompanyId();
	}

	@Reference
	protected ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

	@Reference
	protected DynamicQueryBatchIndexingActionableFactory dynamicQueryBatchIndexingActionableFactory;
}