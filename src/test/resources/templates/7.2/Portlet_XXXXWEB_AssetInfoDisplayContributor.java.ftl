// <dmsc:root templateName="Portlet_XXXXWEB_AssetInfoDisplayContributor.java.ftl"  />
// <dmsc:sync id="head-common" > //
// <#include "./valuables.ftl">
// <#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/info/display/contributor/${capFirstModel}AssetInfoDisplayContributor.java">
// </dmsc:sync> //
package ${packageName}.web.info.display.contributor;

import com.liferay.asset.info.display.field.AssetEntryInfoDisplayFieldProvider;
import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.info.display.contributor.InfoDisplayContributor;
import com.liferay.info.display.contributor.InfoDisplayField;
import com.liferay.info.display.contributor.InfoDisplayObjectProvider;
import com.liferay.info.display.field.ExpandoInfoDisplayFieldProvider;
import com.liferay.info.display.field.InfoDisplayFieldProvider;
import com.liferay.portal.kernel.exception.PortalException;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Asset Info Display Contributor
 * 
 * @author ${damascus_author}
 *
 */
@Component(immediate = true, service = InfoDisplayContributor.class)
public class ${capFirstModel}AssetInfoDisplayContributor implements InfoDisplayContributor<${capFirstModel}> {

	@Override
	public String getClassName() {
		return ${capFirstModel}.class.getName();
	}

	@Override
	public Set<InfoDisplayField> getInfoDisplayFields(
			long classTypeId, Locale locale)
		throws PortalException {

		Set<InfoDisplayField> infoDisplayFields =
			_infoDisplayFieldProvider.getContributorInfoDisplayFields(
				locale, AssetEntry.class.getName(), ${capFirstModel}.class.getName());

		infoDisplayFields.addAll(
			_expandoInfoDisplayFieldProvider.
				getContributorExpandoInfoDisplayFields(
						${capFirstModel}.class.getName(), locale));

		return infoDisplayFields;
	}

	@Override
	public Map<String, Object> getInfoDisplayFieldsValues(
			${capFirstModel} entry, Locale locale)
		throws PortalException {

		Map<String, Object> infoDisplayFieldValues = new HashMap<>();

		infoDisplayFieldValues.putAll(
			_assetEntryInfoDisplayFieldProvider.
				getAssetEntryInfoDisplayFieldsValues(
						${capFirstModel}.class.getName(), entry.getPrimaryKey(),
					locale));
		infoDisplayFieldValues.putAll(
			_expandoInfoDisplayFieldProvider.
				getContributorExpandoInfoDisplayFieldsValues(
						${capFirstModel}.class.getName(), entry, locale));
		infoDisplayFieldValues.putAll(
			_infoDisplayFieldProvider.getContributorInfoDisplayFieldsValues(
					${capFirstModel}.class.getName(), entry, locale));

		return infoDisplayFieldValues;
	}

	@Override
	public InfoDisplayObjectProvider<${capFirstModel}> getInfoDisplayObjectProvider(
			long classPK)
		throws PortalException {

		${capFirstModel} entry = _${dashcaseProjectName}LocalService.get${capFirstModel}(classPK);

		if (entry.isInTrash()) {
			return null;
		}

		return new ${capFirstModel}InfoDisplayObjectProvider(entry);
	}

	@Override
	public InfoDisplayObjectProvider<${capFirstModel}> getInfoDisplayObjectProvider(
			long groupId, String urlTitle)
		throws PortalException {

		${capFirstModel} entry = _${dashcaseProjectName}LocalService.get${capFirstModel}(groupId, urlTitle);

		if (entry.isInTrash()) {
			return null;
		}

		return new ${capFirstModel}InfoDisplayObjectProvider(entry);
	}

	@Override
	public String getInfoURLSeparator() {
		return "/${dashcaseProjectName}/";
	}

	@Reference
	private AssetEntryInfoDisplayFieldProvider
		_assetEntryInfoDisplayFieldProvider;

	@Reference
	private ${capFirstModel}LocalService _${dashcaseProjectName}LocalService;

	@Reference
	private ExpandoInfoDisplayFieldProvider _expandoInfoDisplayFieldProvider;

	@Reference
	private InfoDisplayFieldProvider _infoDisplayFieldProvider;


}
