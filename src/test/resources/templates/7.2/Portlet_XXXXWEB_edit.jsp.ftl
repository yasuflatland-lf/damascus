<%-- <dmsc:root  templateName="Portlet_XXXXWEB_edit.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/edit.jsp">
<#assign skipTemplate = !generateWeb>
<%-- </dmsc:sync> --%>
<%@ include file="./init.jsp" %>

<%
	PortletURL portletURL = PortletURLUtil.clone(renderResponse.createRenderURL(), liferayPortletResponse);
	boolean fromAsset = ParamUtil.getBoolean(request, "fromAsset", false);
	String CMD = ParamUtil.getString(request, Constants.CMD, Constants.UPDATE);
	${capFirstModel} ${uncapFirstModel} = (${capFirstModel})request.getAttribute("${uncapFirstModel}");
	String redirect = ParamUtil.getString(request, "redirect");
	portletDisplay.setShowBackIcon(true);
	portletDisplay.setURLBack(redirect);
%>

<portlet:actionURL name="/${lowercaseModel}/crud" var="${lowercaseModel}EditURL">
	<portlet:param name="<%= Constants.CMD %>" value="<%= CMD %>" />
	<portlet:param name="redirect" value="<%= portletURL.toString() %>" />
</portlet:actionURL>

<div class="container-fluid-1280">
	<aui:form action="<%= ${lowercaseModel}EditURL %>" method="post" name="${lowercaseModel}Edit">
		<aui:model-context bean="<%= ${uncapFirstModel} %>" model="<%= ${capFirstModel}.class %>" />
		<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= CMD %>" />
		<aui:input name="fromAsset" type="hidden" value="<%= fromAsset %>" />
		<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
		<aui:input name="resourcePrimKey" type="hidden" value="<%= ${uncapFirstModel}.getPrimaryKey() %>" />

		<%

		//This tag is only necessary in Asset publisher

		if (fromAsset) {
		%>

		<div class="lfr-form-content">

		<%
		}
		%>

		<c:if test="<%= Constants.ADD.equals(CMD) %>">
			<aui:input name="addGuestPermissions" type="hidden" value="true" />
			<aui:input name="addGroupPermissions" type="hidden" value="true" />
		</c:if>
<%-- <dmsc:sync id="asset-title-and-summary" >  --%>
					<#-- ---------------- -->
					<#--      Assets      -->
					<#-- ---------------- -->
					<#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
						<liferay-ui:error key="duplicated-url-title"
												  message="duplicated-url-title" />
						<aui:input name="${application.asset.assetTitleFieldName}" label="title" />
					</#if>
					<#if application.asset.assetSummaryFieldName?? && application.asset.assetSummaryFieldName != "" >
						<aui:input name="${application.asset.assetSummaryFieldName}" label="summary" />
					</#if>
<%-- </dmsc:sync> --%>

		<%
			String requiredLabel = "";
		%>
<%-- <dmsc:sync id="main-input-fields" >  --%>
		<#-- ---------------- -->
		<#-- field loop start -->
		<#-- ---------------- -->
		<#list application.fields as field >
			<#-- primary key check -->
			<#if field.primary?? && field.primary == true >
				<#continue>
			</#if>
			<#if field.required?? && field.required == true>
		<%
			requiredLabel = "*";
		%>
		<liferay-ui:error key="${lowercaseModel}-${field.name?lower_case}-required"
						  message="${lowercaseModel}-${field.name?lower_case}-required" />
			<#else>
		<%
			requiredLabel = "";
		%>
			</#if>

			<#-- ---------------- -->
			<#--     Long         -->
			<#--     Varchar      -->
			<#--     Date         -->
			<#--     DateTime     -->
			<#--     Boolean      -->
			<#--     Double       -->
			<#--     Integer      -->
			<#--     Text         -->
			<#-- ---------------- -->
			<#if
				field.type?string == "com.liferay.damascus.cli.json.fields.Long"     ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
				field.type?string == "com.liferay.damascus.cli.json.fields.DateTime" ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Boolean"  ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Double"   ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Integer"  ||
				field.type?string == "com.liferay.damascus.cli.json.fields.Text"
			>
				<#if field.validation?? && field.validation.className??>
					<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
					<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
					<#assign uppercaseValidationModel = "${field.validation.className?upper_case}">

					<#assign fieldName = "PrimaryKey">
					<#if field.validation.fieldName??>
						<#assign fieldName = "${field.validation.fieldName?cap_first}">
					</#if>

					<#assign orderByField = "PrimaryKey">
					<#if field.validation.orderByField??>
						<#assign orderByField = "${field.validation.orderByField?uncap_first}">
					</#if>
					<%
					${capFirstValidationModel}ViewHelper ${uncapFirstValidationModel}ViewHelper = (${capFirstValidationModel}ViewHelper) request
							.getAttribute(${capFirstValidationModel}WebKeys.${uppercaseValidationModel}_VIEW_HELPER);

					SearchContainerResults<${capFirstValidationModel}> ${uncapFirstValidationModel}Results = ${uncapFirstValidationModel}ViewHelper.getListFromDB(
							renderRequest, -1, -1, "${orderByField?uncap_first}", "asc", new int[] {WorkflowConstants.STATUS_APPROVED});
					%>
					<liferay-ui:error key="${lowercaseModel}-${field.name?lower_case}-not-found"
									  message="${lowercaseModel}-${field.name?lower_case}-not-found" />

					<aui:select name="${field.name}"
						label='<%=LanguageUtil.get(request, "${lowercaseModel}-${field.name?lower_case}")
								+ requiredLabel%>'>
						<aui:option value=""><%=LanguageUtil.get(request, "please-select") %></aui:option>
						<% for(${capFirstValidationModel} ${uncapFirstValidationModel} : ${uncapFirstValidationModel}Results.getResults()) { %>
						<aui:option value="<%= ${uncapFirstValidationModel}.get${fieldName}() %>"><%=${uncapFirstValidationModel}.get${orderByField?cap_first}() %></aui:option>
						<% } %>
					</aui:select>

				<#else>
					<aui:input name="${field.name}" disabled="false"
						label='<%=LanguageUtil.get(request, "${lowercaseModel}-${field.name?lower_case}")
						+ requiredLabel%>'
					/>
				</#if>
			</#if>
			<#-- ---------------- -->
			<#-- Document Library -->
			<#-- ---------------- -->
			<#if field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" >
					<aui:input name="${field.name}" disabled="false"
						 readonly="true" type="text" label='<%=LanguageUtil.get(request,
						"${lowercaseModel}-${field.name?lower_case}") + requiredLabel%>' />
					<%
					String ${field.name}Click = renderResponse.getNamespace() + "dlBrowse('${field.name} Files select','" +
					renderResponse.getNamespace()+"${field.name}')";
					%>

					<aui:button onClick="<%=${field.name}Click%>" value="select" />
			</#if>
			<#-- ---------------- -->
			<#--     RichText     -->
			<#-- ---------------- -->
			<#if field.type?string == "com.liferay.damascus.cli.json.fields.RichText" >
					<aui:field-wrapper
						label="<%=LanguageUtil.get(request,\"${lowercaseModel}-${field.name?lower_case}\") + requiredLabel%>">
						<liferay-ui:input-editor name="${field.name}Editor"
												 initMethod="init${field.name}Editor" />
					</aui:field-wrapper>
					<aui:input disabled="false" name="${field.name}" type="hidden" />
			</#if>
			</#list>
<%-- </dmsc:sync> --%>

		<%
			if (${uncapFirstModel}.getPrimaryKey() != 0) {
		%>

		<liferay-ui:ratings
			className="<%= ${capFirstModel}.class.getName() %>"
			classPK="<%= ${uncapFirstModel}.getPrimaryKey() %>"
			type="stars"
		/>

		<%
			}
		%>

		<aui:fieldset-group markupView="lexicon">
			<aui:fieldset collapsed="<%= true %>" collapsible="<%= true %>" label="categorization">
				<aui:input name="categories" type="assetCategories" />

				<aui:input name="tags" type="assetTags" />
			</aui:fieldset>
		</aui:fieldset-group>

		<%
		if (${uncapFirstModel}.getPrimaryKey() != 0 && false == fromAsset) {
		%>

		<aui:fieldset-group markupView="lexicon">
			<aui:fieldset collapsed="<%= true %>" collapsible="<%= true %>" label="related-assets">
				<liferay-asset:input-asset-links
					className="<%= ${capFirstModel}.class.getName() %>"
					classPK="<%= ${uncapFirstModel}.getPrimaryKey() %>"
				/>
			</aui:fieldset>
		</aui:fieldset-group>

		<%
		}
		%>

		<%

		//This tag is only necessary in Asset publisher

		if (fromAsset) {
		%>

		</div>

		<%
		}
		%>

		<aui:button-row>

			<%
				String publishButtonLabel = "submit";
			%>

			<%
				if (WorkflowDefinitionLinkLocalServiceUtil
					.hasWorkflowDefinitionLink(themeDisplay.getCompanyId(), scopeGroupId, ${capFirstModel}.class.getName())) {

						publishButtonLabel = "submit-for-publication";
				}
			%>

			<aui:button
				cssClass="btn-lg"
				onClick='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "saveEditors();" %>'
				primary="<%= false %>"
				type="submit"
				value="<%= publishButtonLabel %>"
			/>

			<%
				if (!fromAsset) {
			%>

			&nbsp;&nbsp;&minus; <liferay-ui:message key="or" /> &minus;
			<aui:button onClick="<%= redirect %>" type="cancel" />

			<%
				}
			%>

		</aui:button-row>
	</aui:form>

	<%
	if (${uncapFirstModel}.getPrimaryKey() != 0 && false == fromAsset) {
	%>

	<liferay-ui:panel-container
		extended="<%= false %>"
		id="${uncapFirstModel}CommentsPanelContainer"
		persistState="<%= true %>"
	>
		<liferay-ui:panel
			collapsible="<%= true %>"
			extended="<%= true %>"
			id="${uncapFirstModel}CommentsPanel"
			persistState="<%= true %>"
			title='<%= LanguageUtil.get(request, "comments") %>'
		>
			<portlet:actionURL name="invokeTaglibDiscussion" var="discussionURL" />

			<liferay-comment:discussion
				className="<%= ${capFirstModel}.class.getName() %>"
				classPK="<%= ${uncapFirstModel}.getPrimaryKey() %>"
				formName="fm2"
				ratingsEnabled="<%= true %>"
				redirect="<%= currentURL %>"
				userId="<%= ${uncapFirstModel}.getUserId() %>"
			/>
		</liferay-ui:panel>
	</liferay-ui:panel-container>

	<%
	}
	%>

</div>

<%-- <dmsc:sync id="rich-text-editor-functions" >  --%>
<#list application.fields as field >
	<#if field.type?string == "com.liferay.damascus.cli.json.fields.RichText" >
<aui:script>
	function <portlet:namespace />init${field.name}Editor() {
		return '<%=UnicodeFormatter.toString(${uncapFirstModel}.get${field.name?cap_first}())%>';
	}
</aui:script>
	</#if>
</#list>
<%-- </dmsc:sync> --%>

<aui:script>
	function <portlet:namespace />saveEditors() {
<%-- <dmsc:sync id="rich-text-editor-save-editors" >  --%>
<#list application.fields as field >
	<#if field.type?string == "com.liferay.damascus.cli.json.fields.RichText" >
		document.<portlet:namespace />${lowercaseModel}Edit.<portlet:namespace />${field.name}.value =
		window.<portlet:namespace />${field.name}Editor.getHTML();
	</#if>
</#list>
<%-- </dmsc:sync> --%>
		submitForm(document.<portlet:namespace />${lowercaseModel}Edit);
	}
</aui:script>

<%-- <dmsc:sync id="document-and-media-functions" >  --%>
<#list application.fields as field >
    <#if field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" >
<%
${capFirstModel}ItemSelectorHelper ${uncapFirstModel}ItemSelectorHelper = (${capFirstModel}ItemSelectorHelper)request
	.getAttribute(${capFirstModel}WebKeys.${uppercaseModel}_ITEM_SELECTOR_HELPER);
RequestBackedPortletURLFactory requestBackedPortletURLFactory = RequestBackedPortletURLFactoryUtil
	.create(liferayPortletRequest);
String selectItemName = liferayPortletResponse.getNamespace()
		+ "selectItem";
%>

<aui:script>
	function <portlet:namespace />dlBrowse (title, inputField) {
		var itemSrc = $('#'+inputField);
		AUI().use(
			'liferay-item-selector-dialog',
			function(A) {
				var itemSelectorDialog = new A.LiferayItemSelectorDialog(
					{
						eventName: '<%= selectItemName %>',
						on: {
							selectedItemChange: function(event) {
								var selectedItem = event.newVal;

								if (selectedItem) {
									var itemValue = JSON.parse(
										selectedItem.value
									);
									itemSrc.val(itemValue.url);
								}
							}
						},
						title: title,
						url: '<%= ${uncapFirstModel}ItemSelectorHelper.getItemSelectorURL(
						requestBackedPortletURLFactory, themeDisplay, selectItemName) %>'
					}
				);
				itemSelectorDialog.open();
			}
		);
	}
</aui:script>
			<#break>
    </#if>
</#list>
<%-- </dmsc:sync> --%>
