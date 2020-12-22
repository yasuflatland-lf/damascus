// <dmsc:root templateName="Portlet_XXXXSVC_ModelDocumentContributor.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/index/contributor/${capFirstModel}ModelDocumentContributor.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search.index.contributor;

import com.liferay.portal.kernel.search.Document;
import com.liferay.portal.kernel.search.Field;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.search.spi.model.index.contributor.ModelDocumentContributor;
import org.osgi.service.component.annotations.Component;
import ${packageName}.model.${capFirstModel};

/**
 * ${capFirstModel} Model Document Contributor
 *
 * This class is used to contribute fields to the document to be indexed.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "indexer.class.name=${packageName}.model.${capFirstModel}",
	service = ModelDocumentContributor.class
)
public class ${capFirstModel}ModelDocumentContributor implements ModelDocumentContributor<${capFirstModel}> {

	@Override
	public void contribute(Document document, ${capFirstModel} entry) {

		// TODO : These fields should be modified according to your requirements.

		document.addText(Field.CAPTION, entry.get${application.asset.assetTitleFieldName?cap_first}());
		document.addText(
			Field.CONTENT,
			HtmlUtil.extractText(entry.get${application.asset.assetSummaryFieldName?cap_first}()));
		document.addText(Field.DESCRIPTION, entry.get${application.asset.assetTitleFieldName?cap_first}());
		document.addText(Field.SUBTITLE, entry.get${application.asset.assetTitleFieldName?cap_first}());
		document.addText(Field.TITLE, entry.get${application.asset.assetTitleFieldName?cap_first}());

		document.addDate(Field.MODIFIED_DATE, entry.getModifiedDate());
		
<#if advancedSearch>
	<#list application.fields as field >		
		<#if field.name != "title">
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Long"     		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Double"   		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Integer"
				>
				document.addNumber("${field.name}", entry.get${field.name?cap_first}());			
			</#if>			
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.RichText" 		
				>
				document.addText("${field.name}", HtmlUtil.extractText(entry.get${field.name?cap_first}()));
			</#if>			
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Text"
				>
				document.addText("${field.name}", entry.get${field.name?cap_first}());
			</#if>
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
				field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
				>
				document.addDate("${field.name}", entry.get${field.name?cap_first}());
			</#if>
		</#if>			
	</#list>
</#if>	
	}
}