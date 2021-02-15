// <dmsc:root templateName="Portlet_XXXXWEB_InfoDisplayObjectProvider.java.ftl"  />
// <dmsc:sync id="head-common" > //
// <#include "./valuables.ftl">
// <#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/info/display/contributor/${capFirstModel}InfoDisplayObjectProvider.java">
// </dmsc:sync> //
package ${packageName}.web.info.display.contributor;

import com.liferay.asset.kernel.AssetRendererFactoryRegistryUtil;
import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.asset.kernel.model.AssetRenderer;
import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil;
import com.liferay.asset.kernel.service.AssetTagLocalServiceUtil;
import com.liferay.info.display.contributor.InfoDisplayObjectProvider;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.util.ArrayUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.StringUtil;
import ${packageName}.model.${capFirstModel};

import java.util.Locale;

/**
 * @author ${damascus_author}
 */
public class ${capFirstModel}InfoDisplayObjectProvider implements InfoDisplayObjectProvider<${capFirstModel}> {


	public ${capFirstModel}InfoDisplayObjectProvider(${capFirstModel} entry)
		throws PortalException {

		_assetEntry = _getAssetEntry(entry);
		_entry = entry;
	}

	
	@Override
	public long getClassNameId() {
		return _assetEntry.getClassNameId();
	}

	@Override
	public long getClassPK() {
		return _entry.getPrimaryKey();
	}

	@Override
	public long getClassTypeId() {
		return _assetEntry.getClassTypeId();
	}

	@Override
	public String getDescription(Locale locale) {
		return _assetEntry.getDescription(locale);
	}

	@Override
	public ${capFirstModel} getDisplayObject() {
		return _entry;
	}

	@Override
	public long getGroupId() {
		return _entry.getGroupId();
	}

	@Override
	public String getKeywords(Locale locale) {
		String[] assetTagNames = AssetTagLocalServiceUtil.getTagNames(
			_assetEntry.getClassName(), _assetEntry.getClassPK());
		String[] assetCategoryNames =
			AssetCategoryLocalServiceUtil.getCategoryNames(
				_assetEntry.getClassName(), _assetEntry.getClassPK());

		String[] keywords =
			new String[assetTagNames.length + assetCategoryNames.length];

		ArrayUtil.combine(assetTagNames, assetCategoryNames, keywords);

		return StringUtil.merge(keywords);
	}

	@Override
	public String getTitle(Locale locale) {
		return _assetEntry.getTitle(locale);
	}

	@Override
	public String getURLTitle(Locale locale) {
		AssetRenderer assetRenderer = _assetEntry.getAssetRenderer();

		return assetRenderer.getUrlTitle(locale);
	}

	private AssetEntry _getAssetEntry(${capFirstModel} entry)
		throws PortalException {

		long classNameId = PortalUtil.getClassNameId(${capFirstModel}.class);

		AssetRendererFactory assetRendererFactory =
			AssetRendererFactoryRegistryUtil.
				getAssetRendererFactoryByClassNameId(classNameId);

		return assetRendererFactory.getAssetEntry(
				${capFirstModel}.class.getName(), entry.getPrimaryKey());
	}
	private final AssetEntry _assetEntry;
	private final ${capFirstModel} _entry;
	
}
