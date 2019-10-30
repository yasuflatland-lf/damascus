<%-- <dmsc:root  templateName="Portlet_XXXXWEB_full_content.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/asset/full_content.jsp">
<%-- </dmsc:sync> --%>
<%@ include file="/${snakecaseModel}/init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<%= ${uncapFirstModel}.get${application.asset.assetTitleFieldName?cap_first}() %>