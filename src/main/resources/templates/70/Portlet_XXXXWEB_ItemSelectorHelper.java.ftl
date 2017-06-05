<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/upload/${capFirstModel}ItemSelectorHelper.java">

package ${application.packageName}.web.upload;

import com.liferay.item.selector.*;
import com.liferay.item.selector.criteria.*;
import com.liferay.item.selector.criteria.file.criterion.*;
import com.liferay.item.selector.criteria.image.criterion.*;
import com.liferay.portal.kernel.portlet.*;
import com.liferay.portal.kernel.theme.*;

import javax.portlet.*;
import java.util.*;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;
import org.osgi.service.component.annotations.ReferencePolicy;
import org.osgi.service.component.annotations.ReferencePolicyOption;

/**
 * @author Yasuyuki Takeo
 */
@Component(service = ${capFirstModel}ItemSelectorHelper.class)
public class ${capFirstModel}ItemSelectorHelper {

    public String getItemSelectorURL(
        RequestBackedPortletURLFactory requestBackedPortletURLFactory,
        ThemeDisplay themeDisplay, String itemSelectedEventName) {

        List<ItemSelectorReturnType> desiredItemSelectorReturnTypes =
            new ArrayList<>();
        desiredItemSelectorReturnTypes.add(new FileEntryItemSelectorReturnType());

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
