<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_edit.jsp.ftl" /> --%>

<%@ include file="./init.jsp" %>

<%
PortletURL portletURL = PortletURLUtil.clone(renderResponse.createRenderURL(), liferayPortletResponse);
boolean fromAsset = ParamUtil.getBoolean(request, "fromAsset", false);
String CMD = ParamUtil.getString(request, Constants.CMD, Constants.UPDATE);
${capFirstModel} ${uncapFirstModel} = (${capFirstModel})request.getAttribute("${uncapFirstModel}");
String redirect = ParamUtil.getString(request, "redirect");
%>

<liferay-frontend:info-bar
	fixed="<%= true %>"
>
</liferay-frontend:info-bar>

<portlet:actionURL name="/${lowercaseModel}/crud" var="${lowercaseModel}EditURL">
	<portlet:param name="<%= Constants.CMD %>" value="<%= CMD %>" />
	<portlet:param name="redirect" value="<%= portletURL.toString() %>" />
</portlet:actionURL>

<div class="container-fluid-1280 entry-body">
	<aui:form action="<%= ${lowercaseModel}EditURL %>" method="post" name="${lowercaseModel}Edit">
		<aui:model-context bean="<%= ${uncapFirstModel} %>" model="<%= ${capFirstModel}.class %>" />
		<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= CMD %>" />
		<aui:input name="fromAsset" type="hidden" value="<%= fromAsset %>" />
		<aui:input name="redirect" type="hidden" value="<%= redirect %>" />
		<aui:input name="resourcePrimKey" type="hidden" value="<%= ${uncapFirstModel}.getPrimaryKey() %>" />

		<div class="lfr-form-content">
			<aui:fieldset-group markupView="lexicon">
				<aui:fieldset>
					<c:if test="<%= Constants.ADD.equals(CMD) %>">
						<aui:input name="addGuestPermissions" type="hidden" value="true" />
						<aui:input name="addGroupPermissions" type="hidden" value="true" />
					</c:if>

					<aui:input label="title" name="${lowercaseModel}TitleName" />
					<aui:input label="summary" name="${lowercaseModel}SummaryName" />

					<%
					String requiredLabel = "";
					%>

					<%
					requiredLabel = "*";
					%>

					<liferay-ui:error
						key="${lowercaseModel}TitleRequired"
						message="${lowercaseModel}-title-required"
					/>

					<aui:input name="title" disabled="false"
						label='<%= LanguageUtil.get(request, "${lowercaseModel}-title")
						+ requiredLabel %>'
					/>

					<%
					requiredLabel = "";
					%>

					<aui:input name="${lowercaseModel}BooleanStat" disabled="false"
						label='<%= LanguageUtil.get(request, "${lowercaseModel}-${lowercaseModel}booleanstat")
						+ requiredLabel %>'
					/>

					<%
					requiredLabel = "";
					%>

					<aui:input name="${lowercaseModel}DateTime" disabled="false"
						label='<%= LanguageUtil.get(request, "${lowercaseModel}-${lowercaseModel}datetime")
						+ requiredLabel %>'
					/>

					<%
					requiredLabel = "";
					%>

					<aui:input name="${lowercaseModel}DocumentLibrary" disabled="false"
						readonly="true" type="text" label='<%= LanguageUtil.get(request,
						"${lowercaseModel}-${lowercaseModel}documentlibrary") + requiredLabel %>'
					/>

					<%
					String ${lowercaseModel}DocumentLibraryClick = renderResponse.getNamespace() + "dlBrowse('${lowercaseModel}DocumentLibrary Files select','" +
					renderResponse.getNamespace()+"${lowercaseModel}DocumentLibrary')";
					%>

					<aui:button onClick="<%= ${lowercaseModel}DocumentLibraryClick %>" value="select" />

					<%
					requiredLabel = "";
					%>

					<aui:input name="${lowercaseModel}Double" disabled="false"
						label='<%= LanguageUtil.get(request, "${lowercaseModel}-${lowercaseModel}double")
						+ requiredLabel %>'
					/>

					<%
					requiredLabel = "";
					%>

					<aui:input name="${lowercaseModel}Integer" disabled="false"
						label='<%= LanguageUtil.get(request, "${lowercaseModel}-${lowercaseModel}integer")
						+ requiredLabel %>'
					/>

					<%
					requiredLabel = "";
					%>

					<aui:field-wrapper
						label="<%= LanguageUtil.get(request, \"${lowercaseModel}-${lowercaseModel}richtext\") + requiredLabel %>"
					>
						<liferay-ui:input-editor
							initMethod="init${lowercaseModel}RichTextEditor"
							name="${lowercaseModel}RichTextEditor"
						/>
					</aui:field-wrapper>

					<aui:input disabled="false" name="${lowercaseModel}RichText" type="hidden" />

					<%
					requiredLabel = "";
					%>

					<aui:input name="${lowercaseModel}Text" disabled="false"
						label='<%= LanguageUtil.get(request, "${lowercaseModel}-${lowercaseModel}text")
						+ requiredLabel %>'
					/>

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

				</aui:fieldset>
			</aui:fieldset-group>
		</div> <!-- lfr-form-content -->
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

<aui:script>
	function <portlet:namespace />init${lowercaseModel}RichTextEditor() {
		return '<%= UnicodeFormatter.toString(${uncapFirstModel}.getSamplesbRichText()) %>';
	}
</aui:script>

<aui:script>
	function <portlet:namespace />saveEditors() {
		document.<portlet:namespace />${lowercaseModel}Edit.<portlet:namespace />${lowercaseModel}RichText.value =
		window.<portlet:namespace />${lowercaseModel}RichTextEditor.getHTML();
		submitForm(document.<portlet:namespace />${lowercaseModel}Edit);
	}
</aui:script>

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