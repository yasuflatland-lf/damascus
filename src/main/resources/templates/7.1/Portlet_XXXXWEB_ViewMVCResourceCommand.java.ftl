<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}ViewMVCResourceCommand.java">
<#assign skipTemplate = !generateWeb>
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
* @author Softbless
*/
@Component(
    immediate = true,
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
        "mvc.command.name=/${lowercaseModel}/res"
    },
    service = MVCResourceCommand.class
)
public class ${capFirstModel}ViewMVCResourceCommand implements MVCResourceCommand {

@Override
    public boolean serveResource(
        ResourceRequest resourceRequest, ResourceResponse resourceResponse) {
    	
    	String cmd = ParamUtil.getString(resourceRequest, Constants.CMD, "");
    	
    	<#if exportExcel>
    	if (cmd.equals(Constants.EXPORT)) {
    		${capFirstModel}Configuration ${uncapFirstModel}Configuration =
        	        (${capFirstModel}Configuration) resourceRequest.getAttribute(${capFirstModel}Configuration.class.getName());
        	
        	PortletPreferences portletPreferences = resourceRequest.getPreferences();
        	String dateFormatVal = HtmlUtil.escape(
                    portletPreferences.getValue("dateFormat", 
                    		Validator.isNull(${uncapFirstModel}Configuration) ? "yyyy/MM/dd" : ${uncapFirstModel}Configuration.dateFormat()));
        	
        	SimpleDateFormat dateFormat = new SimpleDateFormat(dateFormatVal);
    	
        	String keywords = ParamUtil.getString(resourceRequest, DisplayTerms.KEYWORDS);
        	String orderByCol = ParamUtil.getString(resourceRequest, SearchContainer.DEFAULT_ORDER_BY_COL_PARAM, "${primaryKeyParam}");
        	String orderByType = ParamUtil.getString(resourceRequest, SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM, "asc");
        	
    		String filename = Constants.EXPORT;
    		
    		SearchContainerResults<${capFirstModel}> searchContainerResults = null;
    		
    		try {
	    	    if (Validator.isNull(keywords)) {
	    	        searchContainerResults = _${uncapFirstModel}ViewHelper.getListFromDB(resourceRequest, -1, -1, 
	    	        		orderByCol, orderByType, new int[] {WorkflowConstants.STATUS_APPROVED});
	    	    } else {
	    	        searchContainerResults = _${uncapFirstModel}ViewHelper.getListFromIndex(resourceRequest, -1, -1, 
	    	        		WorkflowConstants.STATUS_APPROVED);
	    	    }
    		} catch(ParseException | SearchException e) {
				e.printStackTrace();
			}
    		
			try (Workbook workbook = new HSSFWorkbook()){
	            Sheet sheet = workbook.createSheet("data");
	            
	            List<String> headers = new LinkedList<>();
	            
	            <#list application.fields as field >	            	
		            headers.add("${field.name?cap_first}");
	            </#list>	            
            	
            	// Header
	            Row headerRow = sheet.createRow(0);
	            for(int i = 0; i < headers.size(); i++) {
	                Cell cell = headerRow.createCell(i);
	                cell.setCellValue(headers.get(i));
	            }
	            
	            if(!Validator.isNull(searchContainerResults) && searchContainerResults.getTotal() > 0) {
		            List<${capFirstModel}> datas = searchContainerResults.getResults();
		            for(int i = 0; i < searchContainerResults.getTotal(); i++) {
		            	Row row = sheet.createRow(i+1);
		            	for(int j = 0; j < headers.size(); j++) {
		            		Cell cell = row.createCell(j);
		            		switch (j) {
		            		<#assign counter = 0>
		            		<#list application.fields as field >	            	
					            case ${counter}:
					            	<#if field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
										 field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
										>
										cell.setCellValue(dateFormat.format(datas.get(i).get${field.name?cap_first}()));
									<#else>
										cell.setCellValue(datas.get(i).get${field.name?cap_first}());
									</#if>
								break;
								<#assign counter += 1>
				            </#list>								
								default:
									break;
							}
		            	}
		            }
	            } 
	            
	            resourceResponse.setContentType(ContentTypes.APPLICATION_VND_MS_EXCEL);
	            resourceResponse.setProperty("Content-Disposition", "attachment; filename=\""+ filename + ".xls\"");
	            workbook.write(resourceResponse.getPortletOutputStream());
	            
				return true;
			} catch (IOException e) {
				e.printStackTrace();
				return false;
			} 
        }
        </#if>
        
        return false;                
    }

    @Reference(unbind = "-")
    public void setViewHelper(
        ${capFirstModel}ViewHelper ${uncapFirstModel}ViewHelper) {
        _${uncapFirstModel}ViewHelper = ${uncapFirstModel}ViewHelper;
    }

    private ${capFirstModel}ViewHelper _${uncapFirstModel}ViewHelper;
}