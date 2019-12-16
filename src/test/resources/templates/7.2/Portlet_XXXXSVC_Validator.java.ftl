// <dmsc:root templateName="Portlet_XXXXSVC_Validator.java.ftl"  />
/* <dmsc:sync id="head-common" >  */
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/service/util/${capFirstModel}Validator.java">
/* </dmsc:sync> */ 

package ${packageName}.service.util;

import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.model.ModelHintsUtil;
import com.liferay.portal.kernel.repository.model.ModelValidator;
import com.liferay.portal.kernel.util.Validator;
import ${packageName}.exception.${capFirstModel}ValidateException;
import ${packageName}.model.${capFirstModel};

/* <dmsc:sync id="import-services" >  */
<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
import ${packageName}.service.${capFirstValidationModel}LocalServiceUtil;
	</#if>
</#list>
/* </dmsc:sync> */ 

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

/**
 * ${capFirstModel} Validator 
 * 
 * @author ${damascus_author}
 *
 */
public class ${capFirstModel}Validator implements ModelValidator<${capFirstModel}> {

	@Override
	public void validate(${capFirstModel} entry) throws PortalException {
/* <dmsc:sync id="validate-calls" >  */
    <#-- ---------------- -->
    <#-- field loop start -->
    <#-- ---------------- -->
    <#list application.fields as field >
        // Field ${field.name}
        validate${field.name?cap_first}(entry.get${field.name?cap_first}());

    </#list>
    <#-- ---------------- -->
    <#-- field loop ends  -->
    <#-- ---------------- -->
/* </dmsc:sync> */
        validate${application.asset.assetTitleFieldName?cap_first}(entry.get${application.asset.assetTitleFieldName?cap_first}());

		if (0 < _errors.size()) {
			throw new ${capFirstModel}ValidateException(_errors);
		}
		
	}

    /**
    * ${application.asset.assetTitleFieldName} field Validation
    *
    * @param ${application.asset.assetTitleFieldName}
    */
    protected void validate${application.asset.assetTitleFieldName?cap_first}(String ${application.asset.assetTitleFieldName}) {
        if (Validator.isNotNull(${application.asset.assetTitleFieldName})) {
            int ${application.asset.assetTitleFieldName}MaxLength = ModelHintsUtil.getMaxLength(
                ${capFirstModel}.class.getName(), "${application.asset.assetTitleFieldName}");

            if (${application.asset.assetTitleFieldName}.length() > ${application.asset.assetTitleFieldName}MaxLength) {
                _errors.add("${application.asset.assetTitleFieldName} has more than " + ${application.asset.assetTitleFieldName}MaxLength +
                " characters");
            }
        }
    }

/* <dmsc:sync id="validate-methods" >  */
    <#-- ---------------- -->
    <#-- field loop start -->
    <#-- ---------------- -->
    <#list application.fields as field >
    /**
    * ${field.name} field Validation
    *
    * @param field ${field.name}
    */
    protected void validate${field.name?cap_first}(${templateUtil?api.getTypeParameter(field.type?string)} field) {
        //TODO : This validation needs to be implemented. Add error message key into _errors when an error occurs.
        <#if field.primary?? && field.primary == false >
            <#if field.required == true >
                <#if
                field.type?string == "com.liferay.damascus.cli.json.fields.Text" ||
                field.type?string == "com.liferay.damascus.cli.json.fields.RichText" ||
                field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" ||
                field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"
                >
        if (!StringUtils.isNotEmpty(field)) {
            _errors.add("${lowercaseModel}-${field.name?lower_case}-required");
        }
                </#if>
                <#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Long" ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Integer"
				>
	                <#if field.validation?? && field.validation.className??>
						<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
						<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
		if(field <= 0) {
    		_errors.add("${lowercaseModel}-${field.name?lower_case}-required");
    	}
					</#if>
				</#if>
            </#if>

            <#if field.validation?? && field.validation.className??>
				<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
				<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
    	try {
    		${capFirstValidationModel}LocalServiceUtil.get${capFirstValidationModel}(field);
    	} catch(PortalException e) {
    		_errors.add("${lowercaseModel}-${field.name?lower_case}-not-found");
    	}
			</#if>
        </#if>
    }

    </#list>
    <#-- ---------------- -->
    <#-- field loop ends  -->
    <#-- ---------------- -->
/* </dmsc:sync> */ 	
	

	protected List<String> _errors = new ArrayList<>();

}
