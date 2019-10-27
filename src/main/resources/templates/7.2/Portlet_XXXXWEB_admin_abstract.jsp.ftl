<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_abstract.jsp.ftl" /> --%>

<%@ include file="../init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<portlet:defineObjects />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>