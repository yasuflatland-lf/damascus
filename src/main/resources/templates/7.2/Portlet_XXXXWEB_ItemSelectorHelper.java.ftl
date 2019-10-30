// <dmsc:root templateName="Portlet_XXXXWEB_ItemSelectorHelper.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/upload/${capFirstModel}ItemSelectorHelper.java">
// </dmsc:sync> //
package ${packageName}.web.upload;

import com.liferay.item.selector.ItemSelector;
import com.liferay.item.selector.ItemSelectorReturnType;
import com.liferay.item.selector.criteria.FileEntryItemSelectorReturnType;
import com.liferay.item.selector.criteria.file.criterion.FileItemSelectorCriterion;
import com.liferay.portal.kernel.portlet.RequestBackedPortletURLFactory;
import com.liferay.portal.kernel.theme.ThemeDisplay;

import java.util.ArrayList;
import java.util.List;

import javax.portlet.PortletURL;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;
import org.osgi.service.component.annotations.ReferencePolicy;
import org.osgi.service.component.annotations.ReferencePolicyOption;

/**
 * Item Selector Helper
 *
 * This is used for Documents and Media related operations (such as uploading assets, selecting assets, e.g)
 *
 * @author ${damascus_author}
 */
@Component(service = ${capFirstModel}ItemSelectorHelper.class)
public class ${capFirstModel}ItemSelectorHelper {

	public String getItemSelectorURL(
		RequestBackedPortletURLFactory requestBackedPortletURLFactory,
		ThemeDisplay themeDisplay, String itemSelectedEventName) {

		List<ItemSelectorReturnType> desiredItemSelectorReturnTypes =
			new ArrayList<>();
		desiredItemSelectorReturnTypes.add(
			new FileEntryItemSelectorReturnType());

		FileItemSelectorCriterion fileItemSelectorCriterion =
			new FileItemSelectorCriterion();

		fileItemSelectorCriterion.setDesiredItemSelectorReturnTypes(
			desiredItemSelectorReturnTypes);

		PortletURL itemSelectorURL = _itemSelector.getItemSelectorURL(
			requestBackedPortletURLFactory, itemSelectedEventName,
			fileItemSelectorCriterion);

		return itemSelectorURL.toString();
	}

	@Reference(
		cardinality = ReferenceCardinality.OPTIONAL,
		policy = ReferencePolicy.DYNAMIC,
		policyOption = ReferencePolicyOption.GREEDY
	)
	public void setItemSelector(ItemSelector itemSelector) {
		_itemSelector = itemSelector;
	}

	public void unsetItemSelector(ItemSelector itemSelector) {
		_itemSelector = null;
	}

	private ItemSelector _itemSelector;

}