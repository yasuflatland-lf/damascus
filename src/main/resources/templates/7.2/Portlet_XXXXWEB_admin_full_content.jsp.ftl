<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_full_content.jsp.ftl" /> --%>

<%@ include file="../init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<portlet:defineObjects />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>