<#include "./valuables.ftl">
<#assign createPath = "${entityWebResourcesPath}/asset/full_content.jsp">

<%@include file="../init.jsp" %>
<%@ page import="${application.packageName}.model.${capFirstModel}" %>

<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="com.liferay.portal.kernel.util.HttpUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>

<jsp:useBean id="${uncapFirstModel}" type="${application.packageName}.model.${capFirstModel}" scope="request"/>

<portlet:defineObjects />

<#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
<%= ${uncapFirstModel}.get${application.asset.assetTitleFieldName?cap_first}() %>
</#if>