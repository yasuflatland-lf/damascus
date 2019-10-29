// <dmsc:root templateName="Portlet_XXXXWEB_AssetInfoDisplayContributor.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/info/display/contributor/${capFirstModel}AssetInfoDisplayContributor.java">
// </dmsc:sync> //
package ${packageName}.web.info.display.contributor;

import com.liferay.asset.info.display.contributor.BaseAssetInfoDisplayContributor;
import com.liferay.info.display.contributor.InfoDisplayContributor;
import ${packageName}.model.${capFirstModel};

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import org.osgi.service.component.annotations.Component;

@Component(immediate = true, service = InfoDisplayContributor.class)
public class ${capFirstModel}AssetInfoDisplayContributor extends BaseAssetInfoDisplayContributor<${capFirstModel}> {

	@Override
	public String getClassName() {
		return ${capFirstModel}.class.getName();
	}

	@Override
	public String getInfoURLSeparator() {
		return "/${lowercaseModel}/";
	}

	@Override
	protected Map<String, Object> getClassTypeValues(${capFirstModel} assetEntryObject, Locale locale) {
		return new HashMap<>();
	}

}
