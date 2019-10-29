<%-- <dmsc:root  templateName="Portlet_XXXXWEB_full_content.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/sample_sb/asset/full_content.jsp">
<%-- </dmsc:sync> --%>
<%@ include file="/sample_sb/init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>