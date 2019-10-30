<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_full_content.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}_admin/asset/full_content.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>

<%@ include file="../init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<portlet:defineObjects />

<%-- <dmsc:sync id="asset-title" > --%>
<#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
<%= ${uncapFirstModel}.get${application.asset.assetTitleFieldName?cap_first}()
</#if>
<%-- </dmsc:sync> --%>