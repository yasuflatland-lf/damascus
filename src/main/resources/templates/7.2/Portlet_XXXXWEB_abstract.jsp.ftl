<%-- <dmsc:root  templateName="Portlet_XXXXWEB_abstract.jsp.ftl" /> --%>
<%@ include file="/sample_sb/init.jsp" %>

<jsp:useBean id="${uncapFirstModel}" scope="request" type="${packageName}.model.${capFirstModel}" />

<%= ${uncapFirstModel}.getSamplesbTitleName() %>