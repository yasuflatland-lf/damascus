<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/resources/META-INF/resources/edit_actions.jsp">

<%@include file="/init.jsp"%>

<%
    PortletURL navigationPortletURL = renderResponse.createRenderURL();
    PortletURL portletURL = PortletURLUtil.clone(navigationPortletURL, liferayPortletResponse);

    ResultRow row = (ResultRow) request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
    ${capFirstModel} ${uncapFirstModel} = (${capFirstModel}) row.getObject();

    long groupId = ${uncapFirstModel}.getGroupId();
    String name = ${capFirstModel}.class.getName();
    String primKey = String.valueOf(${uncapFirstModel}.getPrimaryKey());
%>
<liferay-ui:icon-menu
    cssClass="<%=row == null ? "entry-options inline" : StringPool.BLANK%>"
    direction="left-side" icon="<%=StringPool.BLANK%>" markupView="lexicon"
    message="<%=StringPool.BLANK%>" showWhenSingleIcon="<%=true%>">

    <c:if test="<%= ${capFirstModel}PermissionChecker.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.PERMISSIONS) %>">
        <liferay-security:permissionsURL
            modelResource="${application.packageName}.model.${capFirstModel}"
            modelResourceDescription="${capFirstModel}"
            resourcePrimKey="<%=String.valueOf(primKey)%>"
            var="permissionsEntryURL" />

        <liferay-ui:icon image="permissions" url="<%=permissionsEntryURL%>" />
    </c:if>

    <c:if test="<%= ${capFirstModel}PermissionChecker.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.VIEW) %>">
        <portlet:renderURL var="view${capFirstModel}URL">
            <portlet:param name="mvcRenderCommandName" value="/${lowercaseModel}/crud" />
            <portlet:param name="<%=Constants.CMD%>"
                           value="<%=Constants.VIEW%>" />
            <portlet:param name="redirect" value="<%=portletURL.toString()%>" />
            <portlet:param name="resourcePrimKey" value="<%=primKey%>" />
        </portlet:renderURL>
        <liferay-ui:icon image="view" url="<%=view${capFirstModel}URL.toString()%>" />
    </c:if>

    <c:if test="<%= ${capFirstModel}PermissionChecker.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.UPDATE) %>">
        <portlet:renderURL var="edit${capFirstModel}URL">
            <portlet:param name="mvcRenderCommandName" value="/${lowercaseModel}/crud" />
            <portlet:param name="<%=Constants.CMD%>"
                           value="<%=Constants.UPDATE%>" />
            <portlet:param name="redirect" value="<%=portletURL.toString()%>" />
            <portlet:param name="resourcePrimKey" value="<%=primKey%>" />
        </portlet:renderURL>
        <liferay-ui:icon image="edit" url="<%=edit${capFirstModel}URL.toString()%>" />
    </c:if>

    <c:if test="<%= ${capFirstModel}PermissionChecker.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.DELETE) %>">
        <portlet:actionURL name="/${lowercaseModel}/crud" var="delete${capFirstModel}URL">
            <portlet:param name="<%=Constants.CMD%>"
                           value="<%=Constants.DELETE%>" />
            <portlet:param name="redirect" value="<%=portletURL.toString()%>" />
            <portlet:param name="resourcePrimKey" value="<%=primKey%>" />
        </portlet:actionURL>
        <liferay-ui:icon image="delete" url="<%=delete${capFirstModel}URL.toString()%>" />
    </c:if>

    <c:if test="<%= ${capFirstModel}PermissionChecker.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.DELETE) %>">
        <portlet:actionURL name="/${lowercaseModel}/crud" var="moveToTrash${capFirstModel}URL">
            <portlet:param name="<%=Constants.CMD%>"
                           value="<%=Constants.MOVE_TO_TRASH%>" />
            <portlet:param name="redirect" value="<%=portletURL.toString()%>" />
            <portlet:param name="resourcePrimKey" value="<%=primKey%>" />
        </portlet:actionURL>
        <liferay-ui:icon image="trash" url="<%=moveToTrash${capFirstModel}URL.toString()%>" />
    </c:if>

</liferay-ui:icon-menu>
