<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/util/${capFirstModel}ViewHelper.java">
<#assign skipTemplate = !generateWeb>
package ${packageName}.web.util;

import com.google.common.collect.Lists;
import com.liferay.portal.kernel.dao.search.DisplayTerms;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.dao.search.SearchContainerResults;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.search.Document;
import com.liferay.portal.kernel.search.Field;
import com.liferay.portal.kernel.search.Hits;
import com.liferay.portal.kernel.search.Indexer;
import com.liferay.portal.kernel.search.IndexerRegistryUtil;
import com.liferay.portal.kernel.search.SearchContext;
import com.liferay.portal.kernel.search.SearchContextFactory;
import com.liferay.portal.kernel.search.SearchException;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.GetterUtil;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.kernel.util.OrderByComparatorFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;
import ${packageName}.web.portlet.action.${capFirstModel}Configuration;

import java.util.List;

import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
* @author Yasuyuki Takeo
* @author ${damascus_author}
*/
@Component(service = ${capFirstModel}ViewHelper.class)
public class ${capFirstModel}ViewHelper {
    /**
     * Order string to boolean
     *
     * @param order
     * @return if true if order is "asc" or false
     */
    protected boolean getOrder(String order) {
        return ("asc".equalsIgnoreCase(order)) ? true : false;
    }

    /**
     *
     * Order Comparetor
     *
     * @param searchContainer
     * @return OrderByComparator
     */
    public OrderByComparator<${capFirstModel}> getOrderByComparator(
        SearchContainer<?> searchContainer) {

        if (_log.isDebugEnabled()) {
            _log.debug("searchContainer.getOrderByCol()"
                           + (null != searchContainer.getOrderByCol()
                ? searchContainer.getOrderByCol()
                : "null"));
            _log.debug("searchContainer.getOrderByType()"
                           + (null != searchContainer.getOrderByType()
                ? searchContainer.getOrderByType()
                : "null"));
        }

        return OrderByComparatorFactoryUtil.create("${capFirstModel}_${capFirstModel}",
                                                   searchContainer.getOrderByCol(),
                                                   getOrder(searchContainer.getOrderByType()));
    }

    /**
     * Get Data list from Database
     *
     * @param request PortletRequest
     * @param searchContainer SearchContainer<?>
     * @return SearchContainerResults<${capFirstModel}>
     */
    public SearchContainerResults<${capFirstModel}> getListFromDB(
        PortletRequest request, SearchContainer<?> searchContainer, int state) {

        ThemeDisplay themeDisplay = (ThemeDisplay) request
            .getAttribute(WebKeys.THEME_DISPLAY);
        PortletPreferences portletPreferences = request.getPreferences();

        // Filter type
        String prefsViewType = portletPreferences.getValue(
            ${capFirstModel}Configuration.CONF_PREFS_VIEW_TYPE,
            ${capFirstModel}Configuration.PREFS_VIEW_TYPE_DEFAULT);

        long groupId = themeDisplay.getScopeGroupId();
        int containerStart = searchContainer.getStart();
        int containerEnd = searchContainer.getEnd();

        List<${capFirstModel}> results = null;
        int total = 0;

        // Get Order
        OrderByComparator<${capFirstModel}> orderByComparator = getOrderByComparator(
            searchContainer);

        if (prefsViewType
            .equals(${capFirstModel}Configuration.PREFS_VIEW_TYPE_DEFAULT)) {
            results = _${uncapFirstModel}LocalService.findAllInGroup(groupId,
                                                           containerStart, containerEnd, orderByComparator, state);
            total = _${uncapFirstModel}LocalService.countAllInGroup(groupId, state);

        } else if (prefsViewType
            .equals(${capFirstModel}Configuration.PREFS_VIEW_TYPE_USER)) {
            results = _${uncapFirstModel}LocalService.findAllInUser(
                themeDisplay.getUserId(), containerStart, containerEnd,
                orderByComparator, state);
            total = _${uncapFirstModel}LocalService
                .countAllInUser(themeDisplay.getUserId(), state);

        } else {
            results = _${uncapFirstModel}LocalService.findAllInUserAndGroup(
                themeDisplay.getUserId(), groupId, containerStart, containerEnd,
                orderByComparator, state);
            total = _${uncapFirstModel}LocalService
                .countAllInUserAndGroup(themeDisplay.getUserId(), groupId, state);

        }

        return new SearchContainerResults<>(results, total);
    }

    /**
     * Get Data list from Index
     *
     * @param request PortletRequest
     * @return searchContainer SearchContainer<?>
     * @throws SearchException
     */
    public SearchContainerResults<${capFirstModel}> getListFromIndex(
        PortletRequest request, SearchContainer<?> searchContainer, int state)
        throws SearchException {

        // Search Key
        String searchFilter = ParamUtil.getString(request,
                                                  DisplayTerms.KEYWORDS);

        Indexer<${capFirstModel}> indexer = IndexerRegistryUtil
            .nullSafeGetIndexer(${capFirstModel}.class);

        SearchContext searchContext = SearchContextFactory
            .getInstance(PortalUtil.getHttpServletRequest(request));

        // TODO : When WorkflowConstants.STATUS_ANY, this parameter should be set to display all records in the list
        //searchContext.setAndSearch(true);
        searchContext.setAttribute(Field.STATUS, state);

        searchContext.setKeywords(searchFilter);
        searchContext.setStart(searchContainer.getStart());
        searchContext.setEnd(searchContainer.getEnd());

        // Search in index
        Hits results = indexer.search(searchContext);

        // Initialize return values
        int total = results.getLength();
        List<${capFirstModel}> tempResults = Lists.newArrayList();

        for (int i = 0; i < results.getDocs().length; i++) {
            Document doc = results.doc(i);

            ${capFirstModel} resReg = null;

            // Entry
            long entryId = GetterUtil.getLong(doc.get(Field.ENTRY_CLASS_PK));

            try {
                resReg = _${uncapFirstModel}LocalService.get${capFirstModel}(entryId);

                resReg = resReg.toEscapedModel();

                tempResults.add(resReg);
            } catch (Exception e) {
                if (_log.isWarnEnabled()) {
                    _log.warn(
                        "${capFirstModel} search index is stale and contains entry "
                            + entryId);
                }

                continue;
            }
        }

        return new SearchContainerResults<>(tempResults, total);
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(
        ${capFirstModel}LocalService ${uncapFirstModel}LocalService) {
        _${uncapFirstModel}LocalService = ${uncapFirstModel}LocalService;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;

    private static Log _log = LogFactoryUtil
        .getLog(${capFirstModel}ViewHelper.class);
}
