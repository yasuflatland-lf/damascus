<%-- <dmsc:root  templateName="Portlet_XXXXWEB_abstract.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/sample_sb/asset/abstract.jsp">
<%-- </dmsc:sync> --%>
<%@ include file="/sample_sb/init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>