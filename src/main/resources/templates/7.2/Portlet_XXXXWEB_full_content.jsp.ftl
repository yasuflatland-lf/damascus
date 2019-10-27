<%-- <dmsc:root  templateName="Portlet_XXXXWEB_full_content.jsp.ftl" /> --%>
<%@ include file="/sample_sb/init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>