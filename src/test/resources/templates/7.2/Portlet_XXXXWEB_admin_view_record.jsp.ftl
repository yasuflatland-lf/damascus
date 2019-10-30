<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_view_record.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}_admin/view_record.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>
<%@ include file="./init.jsp" %>

<%
${capFirstModel} ${uncapFirstModel} = (${capFirstModel})request.getAttribute("${uncapFirstModel}");
String redirect = ParamUtil.getString(request, "redirect");
boolean fromAsset = ParamUtil.getBoolean(request, "fromAsset", false);
portletDisplay.setShowBackIcon(true);
portletDisplay.setURLBack(redirect);
%>

<div class="container-fluid-1280 entry-body">
	<div class="lfr-form-content">
		<aui:fieldset-group markupView="lexicon">
			<aui:fieldset>
				<aui:fieldset>
<%-- <dmsc:sync id="view-search-rows" > --%>

			        <#-- ---------------- -->
			        <#--      Assets      -->
			        <#-- ---------------- -->
			        <#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
			        <div class="form-group">
			            <h3><liferay-ui:message key="asset-title" /></h3>
			            <p class="form-control"><%=${uncapFirstModel}.get${application.asset.assetTitleFieldName?cap_first}()%></p>
			        </div>
			        </#if>
			        <#if application.asset.assetSummaryFieldName?? && application.asset.assetSummaryFieldName != "" >
			        <div class="form-group">
			            <h3><liferay-ui:message key="asset-title" /></h3>
			            <p class="form-control"><%=${uncapFirstModel}.get${application.asset.assetSummaryFieldName?cap_first}()%></p>
			        </div>
			        </#if>

			        <#-- ---------------- -->
			        <#-- field loop start -->
			        <#-- ---------------- -->
			        <#list application.fields as field >
			    	<div class="form-group">
			            <h3><liferay-ui:message key="${lowercaseModel}-${field.name}" /></h3>
			        	<#if field.validation?? && field.validation.className??>
							<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
							<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">

							<#assign fieldName = "PrimaryKey">
							<#if field.validation.fieldName??>
								<#assign fieldName = "${field.validation.fieldName?cap_first}">
							</#if>

							<#assign orderByField = "PrimaryKey">
							<#if field.validation.orderByField??>
								<#assign orderByField = "${field.validation.orderByField?cap_first}">
							</#if>
						<%
						String ${field.name}Text = "";
						try {
							${capFirstValidationModel} ${uncapFirstValidationModel} = ${uncapFirstValidationModel}LocalService.get${capFirstValidationModel}(GetterUtil.getLong(${uncapFirstModel}.get${field.name?cap_first}()));
							${field.name}Text = ${uncapFirstValidationModel}.get${orderByField}();
						} catch(Exception e) {}
						%>
						<p class="form-control"><%=${field.name}Text%></p>
						<#else>
						<p class="form-control"><%=${uncapFirstModel}.get${field.name?cap_first}()%></p>
						</#if>
					</div>
			        </#list>
			        <#-- ---------------- -->
			        <#--  field loop end  -->
			        <#-- ---------------- -->
<%-- </dmsc:sync> --%>
					
				</aui:fieldset>
			</aui:fieldset>
		</aui:fieldset-group>
	</div>
</div>