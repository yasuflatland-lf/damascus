<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_abstract.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/sample_sb_admin/asset/abstract.jsp">
<%-- </dmsc:sync> --%>
<%@ include file="../init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<portlet:defineObjects />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>