// <dmsc:root templateName="Portlet_XXXXWEB_ManagementToolbarDisplayContext.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/internal/display/context/${capFirstModel}ManagementToolbarDisplayContext.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
package ${packageName}.web.internal.display.context;

import com.liferay.frontend.taglib.clay.servlet.taglib.display.context.SearchContainerManagementToolbarDisplayContext;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.CreationMenu;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItem;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItemList;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.ViewTypeItem;
import com.liferay.portal.kernel.dao.search.DisplayTerms;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.web.util.${capFirstModel}ViewHelper;
import ${packageName}.web.internal.security.permission.resource.${capFirstModel}Permission;
import com.liferay.trash.TrashHelper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.portlet.ActionRequest;
import javax.portlet.PortletURL;
import javax.portlet.ResourceURL;

import javax.servlet.http.HttpServletRequest;

/**
 * ${capFirstModel} Management Toolbar Display Context
 *
 * @author ${damascus_author}
 */
public class ${capFirstModel}ManagementToolbarDisplayContext
	extends SearchContainerManagementToolbarDisplayContext {

	public ${capFirstModel}ManagementToolbarDisplayContext(
		LiferayPortletRequest liferayPortletRequest,
		LiferayPortletResponse liferayPortletResponse,
		HttpServletRequest httpServletRequest,
		SearchContainer<?> searchContainer, TrashHelper trashHelper,
		String displayStyle) {

		super(
			liferayPortletRequest, liferayPortletResponse, httpServletRequest,
			searchContainer);

		_trashHelper = trashHelper;
		_displayStyle = displayStyle;

		_themeDisplay = (ThemeDisplay)httpServletRequest.getAttribute(
			WebKeys.THEME_DISPLAY);
	}

	/**
	 * Order Dropdown items
	 *
	 * @return
	 */
	public List<DropdownItem> _getOrderByDropdownItems() {
		return new DropdownItemList() {
			{
// <dmsc:sync id="sort-order" > //
<#list application.fields as field >
	<#if field.primary?? && field.primary == false >
		add(
			dropdownItem -> {
				dropdownItem.setActive(
					Objects.equals(getOrderByCol(), "${field.name}"));
				dropdownItem.setHref(
					_getCurrentSortingURL(), "orderByCol", "${field.name}");
				dropdownItem.setLabel(
					LanguageUtil.get(request, "${field.name}"));
			});
	</#if>
</#list>
// </dmsc:sync> //				
			}
		};
	}

	/**
	 * Action Items
	 */
	@Override
	public List<DropdownItem> getActionDropdownItems() {
		return new DropdownItemList() {
			{

				// Delete action

				add(
					dropdownItem -> {
						dropdownItem.putData("action", "deleteEntries");
						dropdownItem.setHref(
							"javascript:" +
								liferayPortletResponse.getNamespace() +
									"deleteEntries();");

						boolean trashEnabled = _trashHelper.isTrashEnabled(
							_themeDisplay.getScopeGroupId());

						dropdownItem.setIcon(
							trashEnabled ? "trash" : "times-circle");

						String label = "delete";

						if (trashEnabled) {
							label = "move-to-recycle-bin";
						}

						dropdownItem.setLabel(LanguageUtil.get(request, label));

						dropdownItem.setQuickAction(true);
					});
// <dmsc:sync id="export-action" > //
<#if exportExcel>
				// Export Action

				add(
					dropdownItem -> {
						dropdownItem.setHref(_getExportResourceURL());

						dropdownItem.setIcon("download");

						dropdownItem.setLabel(
							LanguageUtil.get(request, "download"));

						dropdownItem.setQuickAction(true);
					});
</#if>
// </dmsc:sync> //				
			}
		};
	}

	@Override
	public String getClearResultsURL() {
		return getSearchActionURL();
	}

	public Map<String, Object> getComponentContext() throws PortalException {
		Map<String, Object> context = new HashMap<>();

		String cmd = Constants.DELETE;

		if (_trashHelper.isTrashEnabled(_themeDisplay.getScopeGroup())) {
			cmd = Constants.MOVE_TO_TRASH;
		}

		context.put(Constants.CMD, cmd);

		PortletURL deleteEntriesURL = liferayPortletResponse.createActionURL();

		deleteEntriesURL.setParameter(
			ActionRequest.ACTION_NAME, "/${lowercaseModel}/crud");

		context.put("deleteEntryIds", deleteEntriesURL.toString());

		context.put(
			"trashEnabled",
			_trashHelper.isTrashEnabled(_themeDisplay.getScopeGroupId()));

		return context;
	}

	@Override
	public CreationMenu getCreationMenu() {
		if (!${capFirstModel}Permission.contains(
				_themeDisplay.getPermissionChecker(),
				_themeDisplay.getScopeGroupId(), ActionKeys.ADD_ENTRY)) {

			return null;
		}

		return new CreationMenu() {
			{
				addDropdownItem(
					dropdownItem -> {
						dropdownItem.setHref(
							liferayPortletResponse.createRenderURL(),
							Constants.CMD, Constants.ADD,
							"mvcRenderCommandName", "/${lowercaseModel}/crud",
							"redirect", currentURLObj.toString());
						dropdownItem.setLabel(
							LanguageUtil.get(request, "add-${lowercaseModel}"));
					});
			}
		};
	}

	/**
	 * Returns the filter menu options.
	 *
	 * @return menu options list
	 */
	@Override
	public List<DropdownItem> getFilterDropdownItems() {
		return new DropdownItemList() {
			{
				addGroup(
					dropdownGroupItem -> {
						dropdownGroupItem.setDropdownItems(
							_getOrderByDropdownItems());
						dropdownGroupItem.setLabel(
							LanguageUtil.get(request, "order-by"));
					});
			}
		};
	}

	public String getOrderByType() {
		return searchContainer.getOrderByType();
	}

	@Override
	public String getSearchActionURL() {
		PortletURL searchURL = liferayPortletResponse.createRenderURL();

		searchURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/view");

		String navigation = ParamUtil.getString(
			request, "navigation", "entries");

		searchURL.setParameter("navigation", navigation);

		searchURL.setParameter("orderByCol", getOrderByCol());
		searchURL.setParameter("orderByType", getOrderByType());

		return searchURL.toString();
	}

	@Override
	public String getSortingURL() {
		PortletURL sortingURL = _getCurrentSortingURL();

		sortingURL.setParameter(
			"orderByType",
			Objects.equals(getOrderByType(), "asc") ? "desc" : "asc");

		return sortingURL.toString();
	}

	@Override
	public List<ViewTypeItem> getViewTypeItems() {
		return null;

		// TODO : Configure if you need to switch view type

		//		return new ViewTypeItemList(getPortletURL(), getDisplayStyle()) {

		//			{
		//				if (ArrayUtil.contains(getDisplayViews(), "icon")) {
		//					addCardViewTypeItem();
		//				}
		//
		//				if (ArrayUtil.contains(getDisplayViews(), "descriptive")) {
		//					addListViewTypeItem();
		//				}
		//
		//				if (ArrayUtil.contains(getDisplayViews(), "list")) {
		//					addTableViewTypeItem();
		//				}
		//			}
		//		};

	}

	/**
	 * Export Resource URL
	 *
	 * @return Export resource URL
	 */
	protected String _getExportResourceURL() {
		String keywords = ParamUtil.getString(request, DisplayTerms.KEYWORDS);

		ResourceURL exportResourceURL =
			liferayPortletResponse.createResourceURL(
				_themeDisplay.getPortletDisplay(
				).getId());

		exportResourceURL.setParameter(Constants.CMD, Constants.EXPORT);
		exportResourceURL.setParameter(DisplayTerms.KEYWORDS, keywords);
		exportResourceURL.setResourceID("/${lowercaseModel}/export");
		exportResourceURL.setParameter(
			SearchContainer.DEFAULT_ORDER_BY_COL_PARAM,
			searchContainer.getOrderByCol());
		exportResourceURL.setParameter(
			SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM,
			searchContainer.getOrderByType());

		return exportResourceURL.toString();
	}

	/**
	 * Search Sort URL
	 *
	 * @return Search filter URL string
	 */
	private PortletURL _getCurrentSortingURL() {
		String keywords = ParamUtil.getString(request, DisplayTerms.KEYWORDS);
		int cur = ParamUtil.getInteger(
			request, SearchContainer.DEFAULT_CUR_PARAM);
		int delta = ParamUtil.getInteger(
			request, SearchContainer.DEFAULT_DELTA_PARAM);
		String orderByCol = ParamUtil.getString(
			request, SearchContainer.DEFAULT_ORDER_BY_COL_PARAM, "${lowercaseModel}Id");
		String orderByType = ParamUtil.getString(
			request, SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM, "asc");

		PortletURL navigationPortletURL =
			liferayPortletResponse.createRenderURL();

		navigationPortletURL.setParameter(
			SearchContainer.DEFAULT_CUR_PARAM, String.valueOf(cur));
		navigationPortletURL.setParameter(
			"mvcRenderCommandName", "/${lowercaseModel}/view");
		navigationPortletURL.setParameter(
			SearchContainer.DEFAULT_ORDER_BY_COL_PARAM, orderByCol);
		navigationPortletURL.setParameter(
			SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM, orderByType);

<#if advancedSearch>
		Map<String, String> advSearchKeywords = ${capFirstModel}ViewHelper.getAdvSearchKeywords(liferayPortletRequest);
		
		for(String key : advSearchKeywords.keySet()) {
			navigationPortletURL.setParameter(key, advSearchKeywords.get(key));
		}

		if (advSearchKeywords.isEmpty()) {
</#if>
		
		if (Validator.isNotNull(keywords)) {
			navigationPortletURL.setParameter(DisplayTerms.KEYWORDS, keywords);
		}

<#if advancedSearch>
		}
</#if>

		return navigationPortletURL;
	}

	private final String _displayStyle;
	private final ThemeDisplay _themeDisplay;
	private final TrashHelper _trashHelper;

}