// <dmsc:root templateName="Portlet_XXXXWEB_DisplayContext.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/internal/display/context/${capFirstModel}DisplayContext.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
package ${packageName}.web.internal.display.context;

import com.liferay.portal.kernel.dao.search.DisplayTerms;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.dao.search.SearchContainerResults;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.PortalPreferences;
import com.liferay.portal.kernel.portlet.PortletPreferencesFactoryUtil;
import com.liferay.portal.kernel.portlet.PortletURLUtil;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.web.internal.security.permission.resource.${capFirstModel}EntryPermission;
import ${packageName}.web.util.${capFirstModel}ViewHelper;
import com.liferay.trash.TrashHelper;

import java.text.ParseException;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.PortletException;
import javax.portlet.PortletURL;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * ${capFirstModel} Display Context
 *
 * @author ${damascus_author}
 */
public class ${capFirstModel}DisplayContext {

	public ${capFirstModel}DisplayContext(
		LiferayPortletRequest liferayPortletRequest,
		LiferayPortletResponse liferayPortletResponse, TrashHelper trashHelper,
		${capFirstModel}ViewHelper ${uncapFirstModel}ViewHelper) {

		_liferayPortletRequest = liferayPortletRequest;
		_liferayPortletResponse = liferayPortletResponse;
		_trashHelper = trashHelper;

		_portalPreferences = PortletPreferencesFactoryUtil.getPortalPreferences(
			liferayPortletRequest);

		_httpServletRequest = _liferayPortletRequest.getHttpServletRequest();
		_${uncapFirstModel}ViewHelper = ${uncapFirstModel}ViewHelper;
	}

	public List<String> getAvailableActions(${capFirstModel} entry)
		throws PortalException {

		ThemeDisplay themeDisplay =
			(ThemeDisplay)_httpServletRequest.getAttribute(
				WebKeys.THEME_DISPLAY);

		if (${capFirstModel}EntryPermission.contains(
				themeDisplay.getPermissionChecker(), entry,
				ActionKeys.DELETE)) {

			return Collections.singletonList("deleteEntries");
		}

		return Collections.emptyList();
	}

	public Map<String, Object> getComponentContext() throws PortalException {
		ThemeDisplay themeDisplay =
			(ThemeDisplay)_httpServletRequest.getAttribute(
				WebKeys.THEME_DISPLAY);

		return new HashMap<String, Object>() {
			{
				put(
					"trashEnabled",
					_trashHelper.isTrashEnabled(
						themeDisplay.getScopeGroupId()));
			}
		};
	}

	public String getDisplayStyle() {
		String displayStyle = ParamUtil.getString(
			_httpServletRequest, "displayStyle");

		if (Validator.isNull(displayStyle)) {
			return _portalPreferences.getValue(
				${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, "entries-display-style",
				"icon");
		}

		_portalPreferences.setValue(
			${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN, "entries-display-style",
			displayStyle);

		_httpServletRequest.setAttribute(
			WebKeys.SINGLE_PAGE_APPLICATION_CLEAR_CACHE, Boolean.TRUE);

		return displayStyle;
	}

	public SearchContainer<${capFirstModel}> getSearchContainer()
		throws ParseException, PortalException, PortletException {

		PortletURL navigationPortletURL =
			_liferayPortletResponse.createRenderURL();

		String keywords = ParamUtil.getString(
			_httpServletRequest, DisplayTerms.KEYWORDS);
		int cur = ParamUtil.getInteger(
			_httpServletRequest, SearchContainer.DEFAULT_CUR_PARAM);
		String orderByCol = ParamUtil.getString(
			_httpServletRequest, SearchContainer.DEFAULT_ORDER_BY_COL_PARAM,
			"${lowercaseModel}Id");
		String orderByType = ParamUtil.getString(
			_httpServletRequest, SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM,
			"asc");

		navigationPortletURL.setParameter(DisplayTerms.KEYWORDS, keywords);
		navigationPortletURL.setParameter(
			SearchContainer.DEFAULT_CUR_PARAM, String.valueOf(cur));
		navigationPortletURL.setParameter(
			"mvcRenderCommandName", "/${lowercaseModel}/view");
		navigationPortletURL.setParameter(
			SearchContainer.DEFAULT_ORDER_BY_COL_PARAM, orderByCol);
		navigationPortletURL.setParameter(
			SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM, orderByType);

		SearchContainer<${capFirstModel}> _searchContainer = new SearchContainer<>(
			_liferayPortletRequest,
			PortletURLUtil.clone(navigationPortletURL, _liferayPortletResponse),
			null, "no-records-were-found");

		_searchContainer.setId("entryList");
		_searchContainer.setDeltaConfigurable(true);

		_searchContainer.setOrderByCol(orderByCol);
		_searchContainer.setOrderByType(orderByType);

		SearchContainerResults<${capFirstModel}> searchContainerResults = null;

		if (Validator.isNull(keywords)) {
			searchContainerResults = _${uncapFirstModel}ViewHelper.getListFromDB(
				_liferayPortletRequest, _searchContainer,
				new int[] {WorkflowConstants.STATUS_APPROVED});
		}
		else {
			searchContainerResults = _${uncapFirstModel}ViewHelper.getListFromIndex(
				_liferayPortletRequest, _searchContainer,
				WorkflowConstants.STATUS_APPROVED);
		}

		_searchContainer.setTotal(searchContainerResults.getTotal());
		_searchContainer.setResults(searchContainerResults.getResults());

		return _searchContainer;
	}

	private static final Logger _log = LoggerFactory.getLogger(
		${capFirstModel}DisplayContext.class);

	private final HttpServletRequest _httpServletRequest;
	private final LiferayPortletRequest _liferayPortletRequest;
	private final LiferayPortletResponse _liferayPortletResponse;
	private final PortalPreferences _portalPreferences;
	private ${capFirstModel}ViewHelper _${uncapFirstModel}ViewHelper;
	private final TrashHelper _trashHelper;

}