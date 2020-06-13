// <dmsc:root templateName="Portlet_XXXXWEB_AdminCrudMVCActionCommand.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}AdminCrudMVCActionCommand.java">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
package ${packageName}.web.portlet.action;

import com.liferay.asset.display.page.portlet.AssetDisplayPageEntryFormProcessor;
import com.liferay.petra.reflect.ReflectionUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.TrashedModel;
import com.liferay.portal.kernel.portlet.bridges.mvc.BaseMVCActionCommand;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCActionCommand;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.PortalUtil;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.exception.${capFirstModel}ValidateException;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;
import ${packageName}.service.${capFirstModel}Service;
import com.liferay.trash.service.TrashEntryService;

import java.io.IOException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
		"mvc.command.name=/${lowercaseModel}/crud"
	},
	service = MVCActionCommand.class
)
public class ${capFirstModel}AdminCrudMVCActionCommand extends BaseMVCActionCommand {

	/**
	 * Add Entry
	 *
	 * @param request
	 * @param response
	 * @throws ${capFirstModel}ValidateException, Exception
	 */
	public void addEntry(ActionRequest request, ActionResponse response)
		throws Exception, ${capFirstModel}ValidateException {

		long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);

		${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}FromRequest(
			primaryKey, request);

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			${capFirstModel}.class.getName(), request);

		// Add entry

		_${uncapFirstModel}Service.addEntry(entry, serviceContext);

		_assetDisplayPageEntryFormProcessor.process(
			${capFirstModel}.class.getName(), entry.getPrimaryKey(), request);

		SessionMessages.add(request, "${lowercaseModel}AddedSuccessfully");
	}

	/**
	 * Delte Entry
	 *
	 * @param request
	 * @param response
	 * @param moveToTrash true to move to trush.
	 * @throws PortalException
	 * @throws Exception
	 */
	public void deleteEntry(
			ActionRequest request, ActionResponse response, boolean moveToTrash)
		throws PortalException {

		long[] deleteEntryIds = null;
		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(
			WebKeys.THEME_DISPLAY);

		long entryId = ParamUtil.getLong(request, "resourcePrimKey", 0L);

		if (entryId > 0) {
			deleteEntryIds = new long[] {entryId};
		}
		else {
			deleteEntryIds = StringUtil.split(
				ParamUtil.getString(request, "deleteEntryIds"), 0L);
		}

		List<TrashedModel> trashedModels = new ArrayList<>();

		for (long deleteEntryId : deleteEntryIds) {
			try {
				if (moveToTrash) {
					${capFirstModel} entry = _${uncapFirstModel}Service.moveEntryToTrash(
						deleteEntryId);

					trashedModels.add(entry);
				}
				else {
					_${uncapFirstModel}Service.deleteEntry(deleteEntryId);
				}
			}
			catch (PortalException pe) {
				ReflectionUtil.throwException(pe);
			}
		}

		if (moveToTrash && !trashedModels.isEmpty()) {
			Map<String, Object> data = new HashMap<>();

			data.put("trashedModels", trashedModels);

			addDeleteSuccessData(request, data);
		}
	}

	/**
	 * Restore Entries
	 *
	 * @param actionRequest
	 * @throws Exception
	 */
	public void restoreTrashEntries(ActionRequest actionRequest)
		throws Exception {

		long[] restoreTrashEntryIds = StringUtil.split(
			ParamUtil.getString(actionRequest, "restoreTrashEntryIds"), 0L);

		for (long restoreTrashEntryId : restoreTrashEntryIds) {
			_trashEntryService.restoreEntry(restoreTrashEntryId);
		}
	}

	/**
	 * Update Entry
	 *
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void updateEntry(ActionRequest request, ActionResponse response)
		throws Exception {

		long primaryKey = ParamUtil.getLong(request, "resourcePrimKey", 0);

		${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}FromRequest(
			primaryKey, request);

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
			${capFirstModel}.class.getName(), request);

		//Update entry
		_${uncapFirstModel}Service.updateEntry(entry, serviceContext);

		_assetDisplayPageEntryFormProcessor.process(
			${capFirstModel}.class.getName(), entry.getPrimaryKey(), request);

		SessionMessages.add(request, "${lowercaseModel}UpdatedSuccessfully");
	}

	/**
	 * Single Delete
	 *
	 * @param entry
	 * @param moveToTrash
	 * @param trashedModels
	 */
	protected void _deleteEntry(
		${capFirstModel} entry, boolean moveToTrash, List<TrashedModel> trashedModels) {

		try {
			if (moveToTrash) {
				trashedModels.add(
					_${uncapFirstModel}Service.moveEntryToTrash(entry.getPrimaryKey()));
			}
			else {
				_${uncapFirstModel}Service.deleteEntry(entry.getPrimaryKey());
			}
		}
		catch (PortalException pe) {
			ReflectionUtil.throwException(pe);
		}
	}

	@Override
	protected void doProcessAction(
			ActionRequest request, ActionResponse response)
		throws IOException {

		try {

			// Fetch command

			String cmd = ParamUtil.getString(request, Constants.CMD);

			if (cmd.equals(Constants.ADD)) {
				addEntry(request, response);
			}
			else if (cmd.equals(Constants.UPDATE)) {
				updateEntry(request, response);
			}
			else if (cmd.equals(Constants.DELETE)) {
				deleteEntry(request, response, false);
			}
			else if (cmd.equals(Constants.MOVE_TO_TRASH)) {
				deleteEntry(request, response, true);
			}
			else if (cmd.equals(Constants.RESTORE)) {
				restoreTrashEntries(request);
			}
		}
		catch (${capFirstModel}ValidateException ssbve) {
			for (String error : ssbve.getErrors()) {
				SessionErrors.add(request, error);
			}

			PortalUtil.copyRequestParameters(request, response);
			response.setRenderParameter(
				"mvcRenderCommandName", "/${lowercaseModel}/crud");
			hideDefaultSuccessMessage(request);
		}
		catch (Exception t) {
			_log.error(t.getLocalizedMessage(), t);
			SessionErrors.add(request, PortalException.class);
			hideDefaultSuccessMessage(request);
		}

		//For access from Asset Publisher
		String redirect = ParamUtil.getString(request, "redirect");
		Boolean fromAsset = ParamUtil.getBoolean(request, "fromAsset", false);

		if (Validator.isNotNull(redirect) && (true == fromAsset)) {
			sendRedirect(request, response, redirect);
		}
	}

	@Reference(unbind = "-")
	protected void set${capFirstModel}LocalService(
		${capFirstModel}LocalService ${uncapFirstModel}LocalService) {

		_${uncapFirstModel}LocalService = ${uncapFirstModel}LocalService;
	}

	@Reference(unbind = "-")
	protected void set${capFirstModel}Service(${capFirstModel}Service ${uncapFirstModel}Service) {
		_${uncapFirstModel}Service = ${uncapFirstModel}Service;
	}

	private static Logger _log = LoggerFactory.getLogger(
		${capFirstModel}AdminCrudMVCActionCommand.class);

	@Reference
	private AssetDisplayPageEntryFormProcessor
		_assetDisplayPageEntryFormProcessor;

	private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
	private ${capFirstModel}Service _${uncapFirstModel}Service;

	@Reference
	private TrashEntryService _trashEntryService;

}