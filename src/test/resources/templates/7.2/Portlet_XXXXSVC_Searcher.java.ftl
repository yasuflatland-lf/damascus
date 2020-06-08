// <dmsc:root templateName="Portlet_XXXXSVC_Searcher.java.ftl"  />
/* <dmsc:sync id="head-common" >  */ 
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/internal/search/${capFirstModel}Searcher.java">
/* </dmsc:sync> */ 
package ${packageName}.internal.search;

import com.liferay.portal.kernel.search.BaseSearcher;
import com.liferay.portal.kernel.search.Field;
import org.osgi.service.component.annotations.Component;
import ${packageName}.model.${capFirstModel};

/**
 * ${capFirstModel} Searcher
 *
 * Sets up the searcher instance for ${capFirstModel}.
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "model.class.name=${packageName}.model.${capFirstModel}",
	service = BaseSearcher.class.class
)
public class ${capFirstModel}Searcher extends BaseSearcher {

	public static final String CLASS_NAME = ${capFirstModel}.class.getName();

	public ${capFirstModel}Searcher() {

		// TODO: Adjust the fields as necessary.
		setDefaultSelectedFieldNames(
			Field.ASSET_TAG_NAMES, Field.COMPANY_ID, Field.CONTENT,
			Field.ENTRY_CLASS_NAME, Field.ENTRY_CLASS_PK, Field.GROUP_ID,
			Field.MODIFIED_DATE, Field.SCOPE_GROUP_ID, Field.TITLE, Field.UID);
		setFilterSearch(true);
		setPermissionAware(true);

		// TODO Adjust localized fields as well
		setDefaultSelectedLocalizedFieldNames(Field.TITLE, Field.CONTENT);
	}

	@Override
	public String getClassName() {
		return CLASS_NAME;
	}
}