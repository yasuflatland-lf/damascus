<%-- <dmsc:root  templateName="Portlet_XXXXWEB_edit_actions.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/edit_actions.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>
<%@ include file="./init.jsp" %>

<%
PortletURL navigationPortletURL = renderResponse.createRenderURL();
PortletURL portletURL = PortletURLUtil.clone(navigationPortletURL, liferayPortletResponse);

ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);
${capFirstModel} ${uncapFirstModel} = (${capFirstModel})row.getObject();

long groupId = ${uncapFirstModel}.getGroupId();
String name = ${capFirstModel}.class.getName();
String primKey = String.valueOf(${uncapFirstModel}.getPrimaryKey());
%>

<liferay-ui:icon-menu
	cssClass='<%= row == null ? "entry-options inline" : StringPool.BLANK %>'
	direction="left-side"
	icon="<%= StringPool.BLANK %>"
	markupView="lexicon"
	message="<%= StringPool.BLANK %>"
	showWhenSingleIcon="<%= true %>"
>
	<c:if test="<%= ${capFirstModel}EntryPermission.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.PERMISSIONS) %>">
		<liferay-security:permissionsURL
			modelResource="${packageName}.model.${capFirstModel}"
			modelResourceDescription="${capFirstModel}"
			resourcePrimKey="<%= String.valueOf(primKey) %>"
			var="permissionsEntryURL"
		/>

		<liferay-ui:icon iconCssClass="icon-lock" label="<%= true %>" markupView="lexicon" message="permissions" url="<%= permissionsEntryURL %>" />
	</c:if>

	<c:if test="<%= ${capFirstModel}EntryPermission.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.VIEW) %>">
		<portlet:renderURL var="view${capFirstModel}URL">
			<portlet:param name="mvcRenderCommandName" value="/${lowercaseModel}/crud" />

			<portlet:param
				name="<%= Constants.CMD %>"
				value="<%= Constants.VIEW %>"
			/>

			<portlet:param name="redirect" value="<%= portletURL.toString() %>" />
			<portlet:param name="resourcePrimKey" value="<%= primKey %>" />
		</portlet:renderURL>

		<liferay-ui:icon iconCssClass="icon-eye-open" label="<%= true %>" markupView="lexicon" message="view" url="<%= view${capFirstModel}URL.toString() %>" />
	</c:if>

	<c:if test="<%= ${capFirstModel}EntryPermission.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.UPDATE) %>">
		<portlet:renderURL var="edit${capFirstModel}URL">
			<portlet:param name="mvcRenderCommandName" value="/${lowercaseModel}/crud" />

			<portlet:param
				name="<%= Constants.CMD %>"
				value="<%= Constants.UPDATE %>"
			/>

			<portlet:param name="redirect" value="<%= portletURL.toString() %>" />
			<portlet:param name="resourcePrimKey" value="<%= primKey %>" />
		</portlet:renderURL>

		<liferay-ui:icon iconCssClass="icon-edit" label="<%= true %>" markupView="lexicon" message="edit" url="<%= edit${capFirstModel}URL.toString() %>" />
	</c:if>

	<c:if test="<%= ${capFirstModel}EntryPermission.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.DELETE) %>">
		<portlet:actionURL name="/${lowercaseModel}/crud" var="delete${capFirstModel}URL">
			<portlet:param
				name="<%= Constants.CMD %>"
				value="<%= Constants.DELETE %>"
			/>

			<portlet:param name="redirect" value="<%= portletURL.toString() %>" />
			<portlet:param name="resourcePrimKey" value="<%= primKey %>" />
		</portlet:actionURL>

		<liferay-ui:icon iconCssClass="icon-remove" label="<%= true %>" markupView="lexicon" message="remove" url="<%= delete${capFirstModel}URL.toString() %>" />
	</c:if>

	<c:if test="<%= ${capFirstModel}EntryPermission.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.DELETE) %>">
		<portlet:actionURL name="/${lowercaseModel}/crud" var="moveToTrash${capFirstModel}URL">
			<portlet:param
				name="<%= Constants.CMD %>"
				value="<%= Constants.MOVE_TO_TRASH %>"
			/>

			<portlet:param name="redirect" value="<%= portletURL.toString() %>" />
			<portlet:param name="resourcePrimKey" value="<%= primKey %>" />
		</portlet:actionURL>

		<liferay-ui:icon iconCssClass="icon-trash" label="<%= true %>" markupView="lexicon" message="trash" url="<%= moveToTrash${capFirstModel}URL.toString() %>" />
	</c:if>
</liferay-ui:icon-menu>