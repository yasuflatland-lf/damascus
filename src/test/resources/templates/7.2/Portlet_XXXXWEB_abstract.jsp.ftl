<%-- <dmsc:root  templateName="Portlet_XXXXWEB_abstract.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/asset/abstract.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>
<%@ include file="/${snakecaseModel}/init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<%-- <dmsc:sync id="asset-title-get" >  --%>
<#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
<%= ${uncapFirstModel}.get${application.asset.assetTitleFieldName?cap_first}() %>
</#if>
<%-- </dmsc:sync> --%>