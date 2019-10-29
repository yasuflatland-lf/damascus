// <dmsc:root templateName="Portlet_XXXXWEB_ExportMVCResourceCommand.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}ExportMVCResourceCommand.java">
// </dmsc:sync> //
package ${packageName}.web.portlet.action;

import com.liferay.portal.kernel.dao.search.DisplayTerms;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.dao.search.SearchContainerResults;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.search.SearchException;
import com.liferay.portal.kernel.util.Constants;
import com.liferay.portal.kernel.util.ContentTypes;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.web.util.${capFirstModel}ViewHelper;

import java.io.IOException;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.LinkedList;
import java.util.List;

import javax.portlet.PortletPreferences;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * Export Resource Command
 *
 * @author Softbless
 */
@Component(
	immediate = true,
	property = {
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
		"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
		"mvc.command.name=/${lowercaseModel}/export"
	},
	service = MVCResourceCommand.class
)
public class ${capFirstModel}ExportMVCResourceCommand implements MVCResourceCommand {

	@Override
	public boolean serveResource(
		ResourceRequest resourceRequest, ResourceResponse resourceResponse) {

		String cmd = ParamUtil.getString(resourceRequest, Constants.CMD, "");

		if (!cmd.equals(Constants.EXPORT)) {
			return false;
		}

		${capFirstModel}Configuration ${uncapFirstModel}Configuration =
			(${capFirstModel}Configuration)resourceRequest.getAttribute(
				${capFirstModel}Configuration.class.getName());

		PortletPreferences portletPreferences =
			resourceRequest.getPreferences();

		String dateFormatVal = HtmlUtil.escape(
			portletPreferences.getValue(
				"dateFormat",
				Validator.isNull(${uncapFirstModel}Configuration) ? "yyyy/MM/dd" :
				${uncapFirstModel}Configuration.dateFormat()));

		SimpleDateFormat dateFormat = new SimpleDateFormat(dateFormatVal);

		String keywords = ParamUtil.getString(
			resourceRequest, DisplayTerms.KEYWORDS);
		String orderByCol = ParamUtil.getString(
			resourceRequest, SearchContainer.DEFAULT_ORDER_BY_COL_PARAM,
			"${lowercaseModel}Id");
		String orderByType = ParamUtil.getString(
			resourceRequest, SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM,
			"asc");

		String filename = Constants.EXPORT;

		SearchContainerResults<${capFirstModel}> searchContainerResults = null;

		try {
			if (Validator.isNull(keywords)) {
				searchContainerResults = _${uncapFirstModel}ViewHelper.getListFromDB(
					resourceRequest, -1, -1, orderByCol, orderByType,
					new int[] {WorkflowConstants.STATUS_APPROVED});
			}
			else {
				searchContainerResults = _${uncapFirstModel}ViewHelper.getListFromIndex(
					resourceRequest, -1, -1, WorkflowConstants.STATUS_APPROVED);
			}
		}
		catch (ParseException | SearchException e) {
			e.printStackTrace();
		}

		try (Workbook workbook = new HSSFWorkbook()) {
			Sheet sheet = workbook.createSheet("data");

			List<String> headers = new LinkedList<>();

			headers.add("SamplesbId");
			headers.add("Title");
			headers.add("SamplesbBooleanStat");
			headers.add("SamplesbDateTime");
			headers.add("SamplesbDocumentLibrary");
			headers.add("SamplesbDouble");
			headers.add("SamplesbInteger");
			headers.add("SamplesbRichText");
			headers.add("SamplesbText");

			// Header

			Row headerRow = sheet.createRow(0);

			for (int i = 0; i < headers.size(); i++) {
				Cell cell = headerRow.createCell(i);

				cell.setCellValue(headers.get(i));
			}

			if (Validator.isNotNull(searchContainerResults) &&
				(searchContainerResults.getTotal() > 0)) {

				List<${capFirstModel}> datas = searchContainerResults.getResults();

				for (int i = 0; i < searchContainerResults.getTotal(); i++) {
					Row row = sheet.createRow(i + 1);

					for (int j = 0; j < headers.size(); j++) {
						Cell cell = row.createCell(j);
						switch (j) {
							case 0:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbId());

								break;
							case 1:
								cell.setCellValue(
									datas.get(
										i
									).getTitle());

								break;
							case 2:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbBooleanStat());

								break;
							case 3:
								cell.setCellValue(
									dateFormat.format(
										datas.get(
											i
										).getSamplesbDateTime()));

								break;
							case 4:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbDocumentLibrary());

								break;
							case 5:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbDouble());

								break;
							case 6:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbInteger());

								break;
							case 7:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbRichText());

								break;
							case 8:
								cell.setCellValue(
									datas.get(
										i
									).getSamplesbText());

								break;
							default:

								break;
						}
					}
				}
			}

			resourceResponse.setContentType(
				ContentTypes.APPLICATION_VND_MS_EXCEL);
			resourceResponse.setProperty(
				"Content-Disposition",
				"attachment; filename=\"" + filename + ".xls\"");
			workbook.write(resourceResponse.getPortletOutputStream());

			return true;
		}
		catch (IOException ioe) {
			ioe.printStackTrace();
		}

		return false;
	}

	@Reference(unbind = "-")
	public void setViewHelper(${capFirstModel}ViewHelper ${uncapFirstModel}ViewHelper) {
		_${uncapFirstModel}ViewHelper = ${uncapFirstModel}ViewHelper;
	}

	private ${capFirstModel}ViewHelper _${uncapFirstModel}ViewHelper;

}