<%-- <dmsc:root templateName="Portlet_XXXXWEB_init.jsp.ftl"  /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/init.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/asset" prefix="liferay-asset" %><%@
taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/clay" prefix="clay" %><%@
taglib uri="http://liferay.com/tld/comment" prefix="liferay-comment" %><%@
taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %><%@
taglib uri="http://liferay.com/tld/item-selector" prefix="liferay-item-selector" %><%@
taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/security" prefix="liferay-security" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/trash" prefix="liferay-trash" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %><%@
taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>

<%@ page import="com.liferay.asset.constants.AssetWebKeys" %><%@
page import="com.liferay.asset.util.AssetHelper" %><%@
page import="com.liferay.portal.kernel.dao.search.*" %><%@
page import="com.liferay.portal.kernel.language.*" %><%@
page import="com.liferay.portal.kernel.portlet.*" %><%@
page import="com.liferay.portal.kernel.security.permission.ActionKeys" %><%@
page import="com.liferay.portal.kernel.service.WorkflowDefinitionLinkLocalServiceUtil" %><%@
page import="com.liferay.portal.kernel.util.*" %><%@
page import="${packageName}.model.${capFirstModel}" %><%@
page import="${packageName}.web.constants.*" %><%@
page import="${packageName}.web.constants.${capFirstModel}WebKeys" %><%@
page import="${packageName}.web.internal.display.context.*" %><%@
page import="${packageName}.web.internal.security.permission.resource.*" %><%@
page import="${packageName}.web.portlet.action.${capFirstModel}Configuration" %><%@
page import="${packageName}.web.upload.${capFirstModel}ItemSelectorHelper" %><%@
page import="com.liferay.trash.TrashHelper" %><%@
page import="com.liferay.trash.util.TrashWebKeys" %>

<%@ page import="javax.portlet.PortletPreferences" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map"%>

<%@ page import="javax.portlet.PortletURL" %>

<%-- <dmsc:sync id="import-model-related" > --%>
<#list application.fields as field >
    <#if field.validation?? && field.validation.className??>
<%@page import="${packageName}.model.${field.validation.className}"%>
<%@page import="${packageName}.web.constants.${field.validation.className}WebKeys"%>
<%@page import="${packageName}.web.util.${field.validation.className}ViewHelper"%>
<%@page import="${packageName}.service.${field.validation.className}LocalService"%>
    </#if>
</#list>
<%-- </dmsc:sync> --%>

<liferay-frontend:defineObjects />
<liferay-theme:defineObjects />
<portlet:defineObjects />

<%
AssetHelper assetHelper = (AssetHelper)request.getAttribute(AssetWebKeys.ASSET_HELPER);
TrashHelper trashHelper = (TrashHelper)request.getAttribute(TrashWebKeys.TRASH_HELPER);

${capFirstModel}Configuration ${uncapFirstModel}Configuration =
(${capFirstModel}Configuration)
	renderRequest.getAttribute(${capFirstModel}Configuration.class.getName());

String prefsViewType = StringPool.BLANK;
String dateFormatVal = StringPool.BLANK;
String datetimeFormatVal = StringPool.BLANK;
String datePickerFormatVal = StringPool.BLANK;

if (Validator.isNotNull(${uncapFirstModel}Configuration)) {
prefsViewType = HtmlUtil.escape(portletPreferences.getValue("prefsViewType", String.valueOf(${uncapFirstModel}Configuration.prefsViewType())));

dateFormatVal = HtmlUtil.escape(portletPreferences.getValue("dateFormat", ${uncapFirstModel}Configuration.dateFormat()));

datetimeFormatVal = HtmlUtil.escape(portletPreferences.getValue("datetimeFormat", ${uncapFirstModel}Configuration.datetimeFormat()));

datePickerFormatVal = HtmlUtil.escape(portletPreferences.getValue("datePickerFormat", ${uncapFirstModel}Configuration.datePickerFormat()));
}
%>
