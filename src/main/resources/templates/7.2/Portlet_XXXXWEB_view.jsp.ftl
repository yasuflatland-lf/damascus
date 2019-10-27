<%-- <dmsc:root  templateName="Portlet_XXXXWEB_view.jsp.ftl" /> --%>

<%@ include file="./init.jsp" %>

<%
String iconChecked = "checked";
String iconUnchecked = "unchecked";
SimpleDateFormat dateFormat = new SimpleDateFormat(dateFormatVal);
SimpleDateFormat dateTimeFormat = new SimpleDateFormat(datetimeFormatVal);

${capFirstModel}DisplayContext ${uncapFirstModel}DisplayContext = (${capFirstModel}DisplayContext)request.getAttribute(${capFirstModel}WebKeys.${uppercaseModel}_DISPLAY_CONTEXT);

String displayStyle = ${uncapFirstModel}DisplayContext.getDisplayStyle();
SearchContainer entriesSearchContainer = ${uncapFirstModel}DisplayContext.getSearchContainer();

PortletURL portletURL = entriesSearchContainer.getIteratorURL();

${capFirstModel}ManagementToolbarDisplayContext ${uncapFirstModel}ManagementToolbarDisplayContext = new ${capFirstModel}ManagementToolbarDisplayContext(liferayPortletRequest, liferayPortletResponse, request, entriesSearchContainer, trashHelper, displayStyle);
%>

<clay:management-toolbar
	actionDropdownItems="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getActionDropdownItems() %>"
	clearResultsURL="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getSearchActionURL() %>"
	componentId="${uncapFirstModel}ManagementToolbar"
	creationMenu="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getCreationMenu() %>"
	disabled="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.isDisabled() %>"
	filterDropdownItems="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getFilterDropdownItems() %>"
	itemsTotal="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getItemsTotal() %>"
	searchActionURL="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getSearchActionURL() %>"
	searchContainerId="${uncapFirstModel}"
	searchFormName="fm"
	showSearch="true"
	sortingOrder="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getOrderByType() %>"
	sortingURL="<%= ${uncapFirstModel}ManagementToolbarDisplayContext.getSortingURL() %>"
/>

<portlet:actionURL name="/${lowercaseModel}/crud" var="restoreTrashEntriesURL">
	<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.RESTORE %>" />
</portlet:actionURL>

<liferay-trash:undo
	portletURL="<%= restoreTrashEntriesURL %>"
/>

<div class="container-fluid container-fluid-max-xl main-content-body">
	<aui:form action="<%= portletURL.toString() %>" method="get" name="fm">
		<aui:input name="<%= Constants.CMD %>" type="hidden" />
		<aui:input name="redirect" type="hidden" value="<%= portletURL.toString() %>" />
		<aui:input name="deleteEntryIds" type="hidden" />
		<aui:input name="selectAll" type="hidden" value="<%= false %>" />

		<liferay-ui:search-container
			emptyResultsMessage="no-record-was-found"
			id="${uncapFirstModel}"
			rowChecker="<%= new EmptyOnClickRowChecker(renderResponse) %>"
			searchContainer="<%= entriesSearchContainer %>"
		>
			<liferay-ui:search-container-row
				className="${packageName}.model.${capFirstModel}"
				escapedModel="<%= true %>"
				keyProperty="${lowercaseModel}Id"
				modelVar="${uncapFirstModel}"
			>
				<liferay-ui:search-container-column-text
					align="left"
					name="SamplesbId"
					orderable="true"
					orderableProperty="${lowercaseModel}Id"
					property="${lowercaseModel}Id"
				/>

				<liferay-ui:search-container-column-text
					align="left"
					name="Title"
					orderable="true"
					orderableProperty="title"
					property="title"
				>
					<span class="text-default">
						<aui:workflow-status markupView="lexicon" showIcon="<%= false %>" showLabel="<%= false %>" status="<%= ${uncapFirstModel}.getStatus() %>" />
					</span>
				</liferay-ui:search-container-column-text>

				<liferay-ui:search-container-column-text
					align="left"
					name="SamplesbBooleanStat"
					orderable="true"
					orderableProperty="${lowercaseModel}BooleanStat"
					property="${lowercaseModel}BooleanStat"
				/>

				<liferay-ui:search-container-column-text
					align="left"
					name="SamplesbDateTime"
					orderable="true"
					orderableProperty="${lowercaseModel}DateTime"
					value="<%= dateFormat.format(${uncapFirstModel}.getSamplesbDateTime()) %>"
				/>

				<liferay-ui:search-container-column-text
					align="left"
					name="SamplesbDocumentLibrary"
					orderable="true"
					orderableProperty="${lowercaseModel}DocumentLibrary"
					property="${lowercaseModel}DocumentLibrary"
				/>

				<liferay-ui:search-container-column-text
					align="left"
					name="SamplesbDouble"
					orderable="true"
					orderableProperty="${lowercaseModel}Double"
					property="${lowercaseModel}Double"
				/>

				<liferay-ui:search-container-column-text
					align="left"
					name="SamplesbInteger"
					orderable="true"
					orderableProperty="${lowercaseModel}Integer"
					property="${lowercaseModel}Integer"
				/>

				<liferay-ui:search-container-column-text
					align="center"
					name="SamplesbRichText"
				>

					<%
					String ${lowercaseModel}RichTextIcon = iconUnchecked;
					String ${lowercaseModel}RichText = ${uncapFirstModel}.getSamplesbRichText();

					if (!${lowercaseModel}RichText.equals("")) {
						${lowercaseModel}RichTextIcon = iconChecked;
					}
					%>

					<liferay-ui:icon image="<%= ${lowercaseModel}RichTextIcon %>" />
				</liferay-ui:search-container-column-text>

				<liferay-ui:search-container-column-text
					align="center"
					name="SamplesbText"
				>

					<%
					String ${lowercaseModel}TextIcon = iconUnchecked;
					String ${lowercaseModel}Text = ${uncapFirstModel}.getSamplesbText();

					if (!${lowercaseModel}Text.equals("")) {
						${lowercaseModel}TextIcon = iconChecked;
					}
					%>

					<liferay-ui:icon image="<%= ${lowercaseModel}TextIcon %>" />
				</liferay-ui:search-container-column-text>

				<liferay-ui:search-container-column-jsp
					align="right"
					path="/sample_sb/edit_actions.jsp"
				/>
			</liferay-ui:search-container-row>

			<liferay-ui:search-iterator displayStyle="list" markupView="lexicon" />
		</liferay-ui:search-container>
	</aui:form>
</div>

<aui:script>
	function <portlet:namespace />deleteEntries() {
		if (<%=trashHelper.isTrashEnabled(scopeGroupId) %> || confirm('<%=UnicodeLanguageUtil.get(request, "are-you-sure-you-want-to-delete-the-selected-entries") %>')) {
			var form = AUI.$(document.<portlet:namespace />fm);

			form.attr('method', 'post');
			form.fm('<%=Constants.CMD%>').val('<%=trashHelper.isTrashEnabled(scopeGroupId) ? Constants.MOVE_TO_TRASH : Constants.DELETE%>');
			form.fm('deleteEntryIds').val(Liferay.Util.listCheckedExcept(form, '<portlet:namespace />allRowIds'));

			submitForm(form, '<portlet:actionURL name="/${lowercaseModel}/crud" />');
		}
	}
</aui:script>