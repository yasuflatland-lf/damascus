// <dmsc:root templateName="Portlet_XXXXWEB_ViewHelper.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/util/${capFirstModel}ViewHelper.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
package ${packageName}.web.util;

import com.liferay.portal.kernel.dao.search.DisplayTerms;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.dao.search.SearchContainerResults;
import com.liferay.portal.kernel.portlet.LiferayActionRequest;
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
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.search.hits.SearchHit;
import com.liferay.portal.search.hits.SearchHits;
import com.liferay.portal.search.query.BooleanQuery;
import com.liferay.portal.search.query.Queries;
import com.liferay.portal.search.query.Query;
import com.liferay.portal.search.searcher.SearchRequest;
import com.liferay.portal.search.searcher.SearchRequestBuilder;
import com.liferay.portal.search.searcher.SearchRequestBuilderFactory;
import com.liferay.portal.search.searcher.SearchResponse;
import com.liferay.portal.search.searcher.Searcher;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalServiceUtil;
import ${packageName}.web.portlet.action.${capFirstModel}Configuration;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * View Helper
 *
 * @author ${damascus_author}
 */
@Component(immediate = true, service = ${capFirstModel}ViewHelper.class)
public class ${capFirstModel}ViewHelper {

	/**
	 * Get Data list from Database
	 *
	 * @param request     PortletRequest
	 * @param start       int
	 * @param end         int
	 * @param orderByCol  String
	 * @param orderByType String
	 * @return SearchContainerResults<${capFirstModel}>
	 * @throws ParseException
	 */
	public SearchContainerResults<${capFirstModel}> getListFromDB(
			PortletRequest request, int start, int end, String orderByCol,
			String orderByType, int[] state)
		throws ParseException {

		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(
			WebKeys.THEME_DISPLAY);
		PortletPreferences portletPreferences = request.getPreferences();

		// Filter type

		String prefsViewType = portletPreferences.getValue(
			${capFirstModel}Configuration.CONF_PREFS_VIEW_TYPE,
			${capFirstModel}Configuration.PREFS_VIEW_TYPE_DEFAULT);

		long groupId = themeDisplay.getScopeGroupId();
		int containerStart = start;
		int containerEnd = end;

		List<${capFirstModel}> results = new ArrayList<>();

		int total = 0;

		// Get Order

		OrderByComparator<${capFirstModel}> orderByComparator = getOrderByComparator(
			orderByCol, orderByType);

		if (prefsViewType.equals(
				${capFirstModel}Configuration.PREFS_VIEW_TYPE_DEFAULT)) {

			results = ${capFirstModel}LocalServiceUtil.findAllInGroup(
				groupId, containerStart, containerEnd, orderByComparator,
				state);
			total = ${capFirstModel}LocalServiceUtil.countAllInGroup(groupId, state);
		}
		else if (prefsViewType.equals(
					${capFirstModel}Configuration.PREFS_VIEW_TYPE_USER)) {

			results = ${capFirstModel}LocalServiceUtil.findAllInUser(
				themeDisplay.getUserId(), containerStart, containerEnd,
				orderByComparator, state);
			total = ${capFirstModel}LocalServiceUtil.countAllInUser(
				themeDisplay.getUserId(), state);
		}
		else {
			results = ${capFirstModel}LocalServiceUtil.findAllInUserAndGroup(
				themeDisplay.getUserId(), groupId, containerStart, containerEnd,
				orderByComparator, state);
			total = ${capFirstModel}LocalServiceUtil.countAllInUserAndGroup(
				themeDisplay.getUserId(), groupId, state);
		}

		return new SearchContainerResults<>(results, total);
	}

	/**
	 * Get Data list from Database
	 *
	 * @param request         PortletRequest
	 * @param searchContainer SearchContainer<?>
	 * @return SearchContainerResults<${capFirstModel}>
	 * @throws ParseException
	 */
	public SearchContainerResults<${capFirstModel}> getListFromDB(
			PortletRequest request, SearchContainer<?> searchContainer,
			int[] state)
		throws ParseException {

		return getListFromDB(
			request, searchContainer.getStart(), searchContainer.getEnd(),
			searchContainer.getOrderByCol(), searchContainer.getOrderByType(),
			state);
	}

	/**
	 * Get Data list from Index
	 *
	 * @param request PortletRequest
	 * @param start   int
	 * @param end     int
	 * @throws SearchException
	 */
	public SearchContainerResults<${capFirstModel}> getListFromIndex(
			PortletRequest request, int start, int end, int state)
		throws SearchException {
		
		int total = 0;
		List<${capFirstModel}> tempResults = new ArrayList<>();
		
	<#if advancedSearch>
		
		Map<String, Object> advSearchKeywords = new HashMap<>();
		try {			
			advSearchKeywords =	getAdvSearchKeywordsObject(request);
		} catch(ParseException e) {
			e.printStackTrace();
		}
		
		if(!advSearchKeywords.isEmpty()) {
			ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);

			BooleanQuery booleanQuery = getBooleanQuery(advSearchKeywords);
			
			SearchRequestBuilder searchRequestBuilder =
				    searchRequestBuilderFactory.builder();
			searchRequestBuilder.emptySearchEnabled(true);
			
			searchRequestBuilder.withSearchContext(
				    searchContext -> {
						searchContext.setAttribute(Field.STATUS, state);
						searchContext.setStart(start);
						searchContext.setEnd(end);
						searchContext.setEntryClassNames(new String[] {${capFirstModel}.class.getName()});
				        searchContext.setCompanyId(themeDisplay.getCompanyId());
				    });
			
			SearchRequest searchRequest = 
				    searchRequestBuilder.query(booleanQuery).build();
					
			
			SearchResponse searchResponse = searcher.search(searchRequest);
			SearchHits searchHits = searchResponse.getSearchHits();
			List<SearchHit> searchHitsList = searchHits.getSearchHits();
					
			total = GetterUtil.getInteger(searchHits.getTotalHits());
			
			for(SearchHit searchHit : searchHitsList) {
				${capFirstModel} resReg = null;

				// Entry

				long entryId = GetterUtil.getLong(searchHit.getDocument().getLong(Field.ENTRY_CLASS_PK));

				try {
					resReg = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(entryId);

					resReg = resReg.toEscapedModel();

					tempResults.add(resReg);
				}
				catch (Exception e) {
					if (_log.isWarnEnabled()) {
						_log.warn(
							"${capFirstModel} search index is stale and contains entry " +
								entryId);
					}

					continue;
				}
			}
		} else {
		
	</#if>
	
		// Search Key

		String searchFilter = ParamUtil.getString(
			request, DisplayTerms.KEYWORDS);

		Indexer<${capFirstModel}> indexer = IndexerRegistryUtil.nullSafeGetIndexer(
			${capFirstModel}.class);

		SearchContext searchContext = SearchContextFactory.getInstance(
			PortalUtil.getHttpServletRequest(request));

		// TODO : When WorkflowConstants.STATUS_ANY, this parameter should be set to
		// display all records in the list
		// searchContext.setAndSearch(true);

		searchContext.setAttribute(Field.STATUS, state);

		searchContext.setKeywords(searchFilter);
		searchContext.setStart(start);
		searchContext.setEnd(end);

		// Search in index

		Hits results = indexer.search(searchContext);

		// Initialize return values

		total = results.getLength();

		for (int i = 0; i < results.getDocs().length; i++) {
			Document doc = results.doc(i);

			${capFirstModel} resReg = null;

			// Entry

			long entryId = GetterUtil.getLong(doc.get(Field.ENTRY_CLASS_PK));

			try {
				resReg = ${capFirstModel}LocalServiceUtil.get${capFirstModel}(entryId);

				resReg = resReg.toEscapedModel();

				tempResults.add(resReg);
			}
			catch (Exception e) {
				if (_log.isWarnEnabled()) {
					_log.warn(
						"${capFirstModel} search index is stale and contains entry " +
							entryId);
				}

				continue;
			}
		}

<#if advancedSearch>
		}
</#if>

		return new SearchContainerResults<>(tempResults, total);
	}

	/**
	 * Get Data list from Index
	 *
	 * @param request PortletRequest
	 * @return searchContainer SearchContainer<?>
	 * @throws SearchException
	 */
	public SearchContainerResults<${capFirstModel}> getListFromIndex(
			PortletRequest request, SearchContainer<?> searchContainer,
			int state)
		throws SearchException {

		return getListFromIndex(
			request, searchContainer.getStart(), searchContainer.getEnd(),
			state);
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

		return getOrderByComparator(
			searchContainer.getOrderByCol(), searchContainer.getOrderByType());
	}

	/**
	 *
	 * Order Comparetor
	 *
	 * @param orderByCol
	 * @param orderByType
	 * @return OrderByComparator
	 */
	public OrderByComparator<${capFirstModel}> getOrderByComparator(
		String orderByCol, String orderByType) {

		if (_log.isDebugEnabled()) {
			_log.debug(
				"searchContainer.getOrderByCol()" +
					(null != orderByCol ? orderByCol : "null"));
			_log.debug(
				"searchContainer.getOrderByType()" +
					(null != orderByType ? orderByType : "null"));
		}

		return OrderByComparatorFactoryUtil.create(
			"${capFirstModel}_${capFirstModel}", orderByCol, getOrder(orderByType));
	}
	
	public static Map<String, String> getAdvSearchKeywords(LiferayActionRequest request) {
		return getAdvSearchKeywords((PortletRequest) request);
	}
		
	public static Map<String, String> getAdvSearchKeywords(PortletRequest request) {
    	${capFirstModel}Configuration ${uncapFirstModel}Configuration =
				(${capFirstModel}Configuration) request.getAttribute(${capFirstModel}Configuration.class.getName());
				
		PortletPreferences portletPreferences = request.getPreferences();
		
		SimpleDateFormat dateFormat = new SimpleDateFormat(
			HtmlUtil.escape(
                portletPreferences.getValue(
                    "dateFormat", ${uncapFirstModel}Configuration.dateFormat())));
			
    	Map<String, Object> advSearchKeywordsObj = new HashMap<>();
    	
    	try {
    		advSearchKeywordsObj = getAdvSearchKeywordsObject(request);
    	} catch(ParseException e) {
    		e.printStackTrace();
    	}		
		
    	Map<String, String> advSearchKeywords = new HashMap<>();
    	
    	for(String key : advSearchKeywordsObj.keySet()) {
    		if(advSearchKeywordsObj.get(key) instanceof Map) {
    			Map<String, Object> map = (Map<String, Object>) advSearchKeywordsObj.get(key);
    			
    			for(String hashKey : map.keySet()) {
    				if(map.get(hashKey) instanceof Calendar) {
    					advSearchKeywords.put(key + hashKey.substring(0, 1).toUpperCase() + hashKey.substring(1), 
    							dateFormat.format(((Calendar) map.get(hashKey)).getTime()));    					
    				} else if (map.get(hashKey) instanceof Long || 
    						map.get(hashKey) instanceof Double || 
    						map.get(hashKey) instanceof Integer ) {
    					advSearchKeywords.put(key + hashKey.substring(0, 1).toUpperCase() + hashKey.substring(1), 
    							map.get(hashKey).toString());
    				}    				
    			}
    		} else if(advSearchKeywordsObj.get(key) instanceof String) {
    			advSearchKeywords.put(key, (String) advSearchKeywordsObj.get(key));
    		} 
    	}
    	return advSearchKeywords;
    }
	
	protected static Map<String, Object> getAdvSearchKeywordsObject(PortletRequest request) throws ParseException {
    	${capFirstModel}Configuration ${uncapFirstModel}Configuration =
    	        (${capFirstModel}Configuration) request.getAttribute(${capFirstModel}Configuration.class.getName());
    	
    	PortletPreferences portletPreferences = request.getPreferences();
    	String dateFormatVal = HtmlUtil.escape(
                portletPreferences.getValue("dateFormat", 
                		Validator.isNull(${uncapFirstModel}Configuration) ? "yyyy/MM/dd" : ${uncapFirstModel}Configuration.dateFormat()));
    	
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
		    	if(ParamUtil.getLong(request, "search${field.name?cap_first}End", 0) != 0) {
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

<#if advancedSearch>	
	private BooleanQuery getBooleanQuery(Map<String, Object> advSearchKeywords) {
		
    	BooleanQuery booleanQuery = queries.booleanQuery();
    	List<Query> queryList = new ArrayList<>();
    	
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    	
    	for(String key : advSearchKeywords.keySet()) {
    		String column = key.replaceFirst("search","");
    		column = column.substring(0, 1).toLowerCase() + column.substring(1, column.length());
    		
    		if(advSearchKeywords.get(key) instanceof Map) {
    			Map<String, Object> map = (Map<String, Object>) advSearchKeywords.get(key);
    			
    			if(map.get("start") instanceof Calendar && map.get("end") instanceof Calendar) {
    				queryList.add(queries.dateRangeTerm(column, true, true, 
    						sdf.format(((Calendar)map.get("start")).getTime()), 
    						sdf.format(((Calendar)map.get("end")).getTime())));    				
    			} else if((map.get("start") instanceof Long && map.get("end") instanceof Long) || 
    					(map.get("start") instanceof Double && map.get("end") instanceof Double) ||
    					(map.get("start") instanceof Integer && map.get("end") instanceof Integer)) {
    				queryList.add(queries.rangeTerm(column, true, true, map.get("start"), map.get("end")));
        		}
    		} else if(advSearchKeywords.get(key) instanceof String) {
    			queryList.add(queries.match(column, advSearchKeywords.get(key)));
    		}
    	}
    	
    	booleanQuery.addMustQueryClauses(queryList.toArray(new Query[] {}));
    	
    	return booleanQuery;
	}
</#if>

	/**
	 * Order string to boolean
	 *
	 * @param order
	 * @return if true if order is "asc" or false
	 */
	protected boolean getOrder(String order) {
		if ("asc".equalsIgnoreCase(order)) {
			return true;
		}

		return false;
	}

	private static Logger _log = LoggerFactory.getLogger(${capFirstModel}ViewHelper.class);
	
<#if advancedSearch>
	@Reference
	protected Queries queries;

	@Reference
	protected Searcher searcher;
	
	@Reference
	protected SearchRequestBuilderFactory searchRequestBuilderFactory;
</#if>	
}