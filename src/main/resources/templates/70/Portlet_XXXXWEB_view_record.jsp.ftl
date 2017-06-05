<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/resources/META-INF/resources/view_record.jsp">

<%@ include file="/init.jsp"%>
<%
    ${capFirstModel} ${uncapFirstModel} = (${capFirstModel}) request.getAttribute("${uncapFirstModel}");
    String redirect = ParamUtil.getString(request, "redirect");
%>

<div class="container-fluid-1280">
    <aui:fieldset>
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
            <p class="form-control"><%=${uncapFirstModel}.get${field.name?cap_first}()%></p>
        </div>

        </#list>
        <#-- ---------------- -->
        <#--  field loop end  -->
        <#-- ---------------- -->
        <aui:button-row>
            <aui:button cssClass="btn-lg" href="<%=redirect%>" name="backToList"
                        primary="<%=true%>" value="back-to-list" />
        </aui:button-row>
    </aui:fieldset>
</div>
