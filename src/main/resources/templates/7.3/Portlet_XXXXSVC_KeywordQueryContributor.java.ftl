// <dmsc:root templateName="Portlet_XXXXSVC_KeywordQueryContributor.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/query/contributor/${capFirstModel}KeywordQueryContributor.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search.query.contributor;

import com.liferay.portal.kernel.search.BooleanQuery;
import com.liferay.portal.kernel.search.Field;
import com.liferay.portal.kernel.search.SearchContext;
import com.liferay.portal.search.query.QueryHelper;
import com.liferay.portal.search.spi.model.query.contributor.KeywordQueryContributor;
import com.liferay.portal.search.spi.model.query.contributor.helper.KeywordQueryContributorHelper;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Keyword Query Contributor
 *
 * Contributes clauses to the ongoing search query to control how the model entities are searched.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "indexer.class.name=${packageName}.model.${capFirstModel}",
	service = KeywordQueryContributor.class
)
public class ${capFirstModel}KeywordQueryContributor implements KeywordQueryContributor {

	@Override
	public void contribute(String keywords, BooleanQuery booleanQuery,KeywordQueryContributorHelper keywordQueryContributorHelper) {
		SearchContext searchContext = keywordQueryContributorHelper.getSearchContext();

		// TODO: Adjust as necessary to support the search for the entity

		queryHelper.addSearchTerm(booleanQuery, searchContext, Field.ARTICLE_ID, false);
		queryHelper.addSearchTerm(booleanQuery, searchContext, Field.CLASS_PK, false);
		queryHelper.addSearchTerm(booleanQuery, searchContext, Field.ENTRY_CLASS_PK, false);
		queryHelper.addSearchTerm(booleanQuery, searchContext, Field.USER_NAME, false);
		queryHelper.addSearchLocalizedTerm(booleanQuery, searchContext, Field.CONTENT, false);
		queryHelper.addSearchLocalizedTerm(booleanQuery, searchContext, Field.DESCRIPTION, false);
		queryHelper.addSearchLocalizedTerm(booleanQuery, searchContext, Field.TITLE, false);
		queryHelper.addSearchLocalizedTerm(booleanQuery, searchContext, Field.SUBTITLE, false);

<#if advancedSearch>
	<#list application.fields as field >
		<#if field.name != "title">
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Long"     		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Double"   		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Integer"			||
				field.type?string == "com.liferay.damascus.cli.json.fields.RichText" 		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Text"			||
				field.type?string == "com.liferay.damascus.cli.json.fields.Date"     		||
				field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
				>			
				queryHelper.addSearchTerm(booleanQuery, searchContext, "${field.name}", false);			
			</#if>	
		</#if>
	</#list>
</#if>			
	}

	@Reference
	protected QueryHelper queryHelper;
}