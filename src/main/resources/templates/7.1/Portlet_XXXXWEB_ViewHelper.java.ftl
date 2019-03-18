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
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.kernel.util.OrderByComparatorFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;
import ${packageName}.web.portlet.action.${capFirstModel}Configuration;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
     * @throws ParseException
     */
    public SearchContainerResults<${capFirstModel}> getListFromDB(
        PortletRequest request, SearchContainer<?> searchContainer, int[] state) 
        throws ParseException  {

        ThemeDisplay themeDisplay = (ThemeDisplay) request
            .getAttribute(WebKeys.THEME_DISPLAY);
        PortletPreferences portletPreferences = request.getPreferences();

        // Filter type
        String prefsViewType = portletPreferences.getValue(
            ${capFirstModel}Configuration.CONF_PREFS_VIEW_TYPE,
            ${capFirstModel}Configuration.PREFS_VIEW_TYPE_DEFAULT);
		
		// Advance Search Key
        Map<String, Object> advSearchKeywords = getAdvSearchKeywordsObject(request);
		
        long groupId = themeDisplay.getScopeGroupId();
        int containerStart = searchContainer.getStart();
        int containerEnd = searchContainer.getEnd();

        List<${capFirstModel}> results = Lists.newArrayList();
        int total = 0;

        // Get Order
        OrderByComparator<${capFirstModel}> orderByComparator = getOrderByComparator(
            searchContainer);

        if (prefsViewType
            .equals(${capFirstModel}Configuration.PREFS_VIEW_TYPE_DEFAULT)) {
            if(advSearchKeywords.isEmpty()) {
	            results = _${uncapFirstModel}LocalService.findAllInGroup(groupId,
	                                                           containerStart, containerEnd, orderByComparator, state);
	            total = _${uncapFirstModel}LocalService.countAllInGroup(groupId, state);
			} else {
				results.addAll(_${uncapFirstModel}LocalService.advanceSearchInGroup(advSearchKeywords, groupId, 
        				containerStart, containerEnd, orderByComparator, state));
            	total = results.size();
			}
        } else if (prefsViewType
            .equals(${capFirstModel}Configuration.PREFS_VIEW_TYPE_USER)) {
            if(advSearchKeywords.isEmpty()) {
	            results = _${uncapFirstModel}LocalService.findAllInUser(
	                themeDisplay.getUserId(), containerStart, containerEnd,
	                orderByComparator, state);
	            total = _${uncapFirstModel}LocalService
	                .countAllInUser(themeDisplay.getUserId(), state);
			} else {
				results.addAll(_${uncapFirstModel}LocalService.advanceSearchInUser(advSearchKeywords, 
        				themeDisplay.getUserId(), containerStart, containerEnd, orderByComparator, state));
            	total = results.size();
			}
        } else {
        	if(advSearchKeywords.isEmpty()) {
	            results = _${uncapFirstModel}LocalService.findAllInUserAndGroup(
	                themeDisplay.getUserId(), groupId, containerStart, containerEnd,
	                orderByComparator, state);
	            total = _${uncapFirstModel}LocalService
	                .countAllInUserAndGroup(themeDisplay.getUserId(), groupId, state);
			} else {
				results.addAll(_${uncapFirstModel}LocalService.advanceSearchInUserAndGroup(advSearchKeywords, 
        				themeDisplay.getUserId(), groupId, containerStart, containerEnd, orderByComparator, state));
            	total = results.size();
			}
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

	@SuppressWarnings("unchecked")
	public Map<String, String> getAdvSearchKeywords(PortletRequest request, SimpleDateFormat dateFormat) throws ParseException {
    	Map<String, Object> advSearchKeywordsObj = getAdvSearchKeywordsObject(request);
    	Map<String, String> advSearchKeywords = new HashMap<>();
    	
    	for(String key : advSearchKeywordsObj.keySet()) {
    		if(advSearchKeywordsObj.get(key) instanceof Map) {
    			Map<String, Object> map = (Map<String, Object>) advSearchKeywordsObj.get(key);
    			
    			for(String hashKey : map.keySet()) {
    				if(map.get(hashKey) instanceof Calendar) {
    					advSearchKeywords.put(key, dateFormat.format(((Calendar) map.get(hashKey)).getTime()));    					
    				} else if (map.get(hashKey) instanceof Long || 
    						map.get(hashKey) instanceof Double || 
    						map.get(hashKey) instanceof Integer ) {
    					advSearchKeywords.put(key, map.get(hashKey).toString());
    				}    				
    			}
    		} else if(advSearchKeywordsObj.get(key) instanceof String) {
    			advSearchKeywords.put(key, (String) advSearchKeywordsObj.get(key));
    		} 
    	}
    	return advSearchKeywords;
    }

	public Map<String, Object> getAdvSearchKeywordsObject(PortletRequest request) throws ParseException {
    	${capFirstModel}Configuration ${uncapFirstModel}Configuration =
    	        (${capFirstModel}Configuration) request.getAttribute(${capFirstModel}Configuration.class.getName());
    	
    	PortletPreferences portletPreferences = request.getPreferences();
    	String dateFormatVal = HtmlUtil.escape(
                portletPreferences.getValue("dateFormat", ${uncapFirstModel}Configuration.dateFormat()));
    	
    	SimpleDateFormat dateFormat = new SimpleDateFormat(dateFormatVal);
    	
    	Map<String, Object> advSearchKeywords = new HashMap<String, Object>();
    	
		<#list application.fields as field >
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Boolean"  		||
				field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" 
				>
			</#if>
			
			<#if field.type?string == "com.liferay.damascus.cli.json.fields.Long" >
				Map<String, Long> search${field.name?cap_first} = new HashMap<>();		    	
		    	if(ParamUtil.getLong(request, "search${field.name?cap_first}Start", 0) != 0) {
		    		search${field.name?cap_first}.put("start", ParamUtil.getLong(request, "search${field.name?cap_first}Start"));
		    	}
		    	if(ParamUtil.getLong(request, "searchUserdirectoryIdEnd", 0) != 0) {
		    		search${field.name?cap_first}.put("end", ParamUtil.getLong(request, "search${field.name?cap_first}End"));		    		
		    	}		    	
		    	if(!search${field.name?cap_first}.isEmpty()) {
		    		advSearchKeywords.put("search${field.name?cap_first}", search${field.name?cap_first});
		    	}
			</#if>
			<#if field.type?string == "com.liferay.damascus.cli.json.fields.Double" >
				Map<String, Double> search${field.name?cap_first} = new HashMap<>();		    	
		    	if(ParamUtil.getDouble(request, "search${field.name?cap_first}Start", 0) != 0) {
		    		search${field.name?cap_first}.put("start", ParamUtil.getDouble(request, "search${field.name?cap_first}Start"));
		    	}
		    	if(ParamUtil.getDouble(request, "search${field.name?cap_first}End", 0) != 0) {
		    		search${field.name?cap_first}.put("end", ParamUtil.getDouble(request, "search${field.name?cap_first}End"));		    		
		    	}		    	
		    	if(!search${field.name?cap_first}.isEmpty()) {
		    		advSearchKeywords.put("search${field.name?cap_first}", search${field.name?cap_first});
		    	}
			</#if>
			<#if field.type?string == "com.liferay.damascus.cli.json.fields.Integer" >
				Map<String, Integer> search${field.name?cap_first} = new HashMap<>();		    	
		    	if(ParamUtil.getInteger(request, "search${field.name?cap_first}Start", 0) != 0) {
		    		search${field.name?cap_first}.put("start", ParamUtil.getInteger(request, "search${field.name?cap_first}Start"));
		    	}
		    	if(ParamUtil.getInteger(request, "search${field.name?cap_first}End", 0) != 0) {
		    		search${field.name?cap_first}.put("end", ParamUtil.getInteger(request, "search${field.name?cap_first}End"));		    		
		    	}		    	
		    	if(!search${field.name?cap_first}.isEmpty()) {
		    		advSearchKeywords.put("search${field.name?cap_first}", search${field.name?cap_first});
		    	}
			</#if>
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
				field.type?string == "com.liferay.damascus.cli.json.fields.RichText" 		||
				field.type?string == "com.liferay.damascus.cli.json.fields.Text"
				>
				if(!ParamUtil.getString(request, "search${field.name?cap_first}", "").isEmpty()) {
		        	advSearchKeywords.put("search${field.name?cap_first}", ParamUtil.getString(request, "search${field.name?cap_first}"));
		    	}
			</#if>
				
					
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
				field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
				>
				Map<String, Calendar> search${field.name?cap_first} = new HashMap<>();
    	
		    	if(!ParamUtil.getString(request, "search${field.name?cap_first}Start", "").isEmpty()) {
		    		Date start = dateFormat.parse(ParamUtil.getString(request, "search${field.name?cap_first}Start"));
		    		Calendar cal = Calendar.getInstance();
		    		cal.setTime(start);
		    		search${field.name?cap_first}.put("start", cal);
		    	}
		    	if(!ParamUtil.getString(request, "search${field.name?cap_first}End", "").isEmpty()) {
		    		Date end = dateFormat.parse(ParamUtil.getString(request, "search${field.name?cap_first}End"));
		    		Calendar cal = Calendar.getInstance();    		
		    		cal.setTime(end);
		    		cal.set(Calendar.HOUR_OF_DAY, 23);
		    		cal.set(Calendar.MINUTE, 59);
		    		cal.set(Calendar.SECOND, 59);
		    		cal.set(Calendar.MILLISECOND, 0);
		    		search${field.name?cap_first}.put("end", cal);
		    	}
		    	if(!search${field.name?cap_first}.isEmpty()) {
		    		advSearchKeywords.put("search${field.name?cap_first}", search${field.name?cap_first});
		    	}
			</#if>				
		</#list>
		
    	return advSearchKeywords;
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
