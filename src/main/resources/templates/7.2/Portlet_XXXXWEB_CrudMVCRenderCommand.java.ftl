// <dmsc:root templateName="Portlet_XXXXWEB_CrudMVCRenderCommand.java.ftl"  />

/**
 *  Copyright (C) 2017 ${damascus_author} All rights reserved.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Lesser General Public License for more details.
 */

package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCRenderCommand;
import com.liferay.portal.kernel.security.permission.ActionKeys;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.exception.${capFirstModel}ValidateException;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}Service;
import ${packageName}.web.constants.${capFirstModel}WebKeys;
import ${packageName}.web.internal.security.permission.resource.${capFirstModel}EntryPermission;
import ${packageName}.web.upload.${capFirstModel}ItemSelectorHelper;

import java.util.ArrayList;
import java.util.List;

import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * CRUD Render
 *
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
		"mvc.command.name=/${lowercaseModel}/crud"
	},
	service = MVCRenderCommand.class
)
public class ${capFirstModel}CrudMVCRenderCommand implements MVCRenderCommand {

	/**
	 * Edit Page JSP file
	 */
	public String getEditPageJSP() {
		return ${capFirstModel}WebKeys.EDIT_JSP;
	}

	/**
	 * View Page JSP file
	 */
	public String getViewPageJSP() {
		return ${capFirstModel}WebKeys.VIEW_JSP;
	}

	/**
	 * View Record JSP file
	 */
	public String getViewRecordPageJSP() {
		return ${capFirstModel}WebKeys.VIEW_RECORD_JSP;
	}

	@Override
	public String render(RenderRequest request, RenderResponse response)
		throws PortletException {

		String renderJSP = getViewPageJSP();

		// Fetch command

		String cmd = ParamUtil.getString(request, Constants.CMD);

		// Fetch primary key

		long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(
			WebKeys.THEME_DISPLAY);

		try {
			if (cmd.equalsIgnoreCase(Constants.UPDATE)) {
				renderJSP = update(request, themeDisplay, primaryKey);
			}
			else if (cmd.equalsIgnoreCase(Constants.VIEW)) {
				renderJSP = view(request, themeDisplay, primaryKey);
			}
			else {
				renderJSP = add(request, themeDisplay, primaryKey);
			}
		}
		catch (PortalException pe) {
			throw new PortletException(pe.getMessage());
		}

		request.setAttribute(
			${capFirstModel}WebKeys.${uppercaseModel}_ITEM_SELECTOR_HELPER,
			_${uncapFirstModel}ItemSelectorHelper);

		return renderJSP;
	}

	/**
	 * Add record
	 *
	 * @param request
	 * @param themeDisplay
	 * @param primaryKey
	 * @return JSP file path
	 * @throws PortalException
	 * @throws ${capFirstModel}ValidateException
	 * @throws PortletException
	 */
	protected String add(
			RenderRequest request, ThemeDisplay themeDisplay, long primaryKey)
		throws PortalException, PortletException, ${capFirstModel}ValidateException {

		${capFirstModel} record = null;

		if (Validator.isNull(request.getParameter("addErrors"))) {
			record = _${uncapFirstModel}Service.getInitialized${capFirstModel}(
				primaryKey, request);
		}
		else {
			record = _${uncapFirstModel}Service.get${capFirstModel}FromRequest(
				primaryKey, request);
		}

		request.setAttribute("${uncapFirstModel}", record);

		return getEditPageJSP();
	}

	/**
	 * Update record
	 *
	 * @param request
	 * @param themeDisplay
	 * @param primaryKey
	 * @return JSP file path to open
	 * @throws PortalException
	 * @throws ${capFirstModel}ValidateException
	 */
	protected String update(
			RenderRequest request, ThemeDisplay themeDisplay, long primaryKey)
		throws PortalException, ${capFirstModel}ValidateException {

		${capFirstModel} record = _${uncapFirstModel}Service.get${capFirstModel}(primaryKey);

		if (!${capFirstModel}EntryPermission.contains(
				themeDisplay.getPermissionChecker(), record,
				ActionKeys.UPDATE)) {

			List<String> error = new ArrayList<>();
			error.add("permission-error");

			throw new ${capFirstModel}ValidateException(error);
		}

		request.setAttribute("${uncapFirstModel}", record);

		return getEditPageJSP();
	}

	/**
	 * View record
	 *
	 * @param request
	 * @param themeDisplay
	 * @param primaryKey
	 * @return
	 * @throws PortalException
	 * @throws ${capFirstModel}ValidateException
	 */
	protected String view(
			RenderRequest request, ThemeDisplay themeDisplay, long primaryKey)
		throws PortalException, ${capFirstModel}ValidateException {

		${capFirstModel} record = _${uncapFirstModel}Service.get${capFirstModel}(primaryKey);

		if (!${capFirstModel}EntryPermission.contains(
				themeDisplay.getPermissionChecker(), record, ActionKeys.VIEW)) {

			List<String> error = new ArrayList<>();
			error.add("permission-error");

			throw new ${capFirstModel}ValidateException(error);
		}

		request.setAttribute("${uncapFirstModel}", record);

		return getViewRecordPageJSP();
	}

	@Reference
	private ${capFirstModel}ItemSelectorHelper _${uncapFirstModel}ItemSelectorHelper;

	@Reference
	private ${capFirstModel}Service _${uncapFirstModel}Service;

}