<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/resources/META-INF/resources/edit.jsp">
<%@ include file="/init.jsp"%>
<%
	PortletURL portletURL = PortletURLUtil.clone(renderResponse.createRenderURL(), liferayPortletResponse);
	boolean fromAsset = ParamUtil.getBoolean(request,"fromAsset",false);
	String CMD = ParamUtil.getString(request, Constants.CMD, Constants.UPDATE);
	${capFirstModel} ${uncapFirstModel} = (${capFirstModel}) request.getAttribute("${uncapFirstModel}");
	String redirect = ParamUtil.getString(request, "redirect");
%>

<portlet:actionURL name="/${lowercaseModel}/crud" var="${lowercaseModel}EditURL">
	<portlet:param name="<%=Constants.CMD%>" value="<%=CMD%>" />
	<portlet:param name="redirect" value="<%=portletURL.toString()%>" />
</portlet:actionURL>

<div class="container-fluid-1280">
	<aui:form name="${lowercaseModel}Edit" action="<%=${lowercaseModel}EditURL%>"
		method="post">
		<aui:model-context bean="<%=${uncapFirstModel}%>" model="<%=${capFirstModel}.class%>" />
		<aui:input name="<%=Constants.CMD%>" type="hidden" value="<%=CMD%>" />
        <aui:input type="hidden" name="fromAsset" value="<%=fromAsset%>" />
        <aui:input type="hidden" name="redirect" value="<%=redirect%>" />
		<aui:input type="hidden" name="resourcePrimKey" value="<%=${uncapFirstModel}.getPrimaryKey()%>" />
        <%
        //This tags are only necessarily in Asset publisher
        if(fromAsset) {
        %>
        <div class="lfr-form-content">
		<%
		}
		%>
		<c:if test='<%=Constants.ADD.equals(CMD)%>'>
			<aui:input type="hidden" name="addGuestPermissions" value="true" />
			<aui:input type="hidden" name="addGroupPermissions" value="true" />
		</c:if>
		<#-- ---------------- -->
		<#--      Assets      -->
		<#-- ---------------- -->
		<#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
			<aui:input name="${application.asset.assetTitleFieldName}" label="title" />
		</#if>
		<#if application.asset.assetSummaryFieldName?? && application.asset.assetSummaryFieldName != "" >
			<aui:input name="${application.asset.assetSummaryFieldName}" label="summary" />
		</#if>

        <%
        	String requiredLabel = "";
        %>

		<#-- ---------------- -->
		<#-- field loop start -->
		<#-- ---------------- -->
		<#list application.fields as field >
			<#-- primary key check -->
			<#if field.primary?? && field.primary == false >
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
		<aui:input name="${field.name}" disabled="false"
				   label='<%=LanguageUtil.get(request, "${lowercaseModel}-${field.name?lower_case}")
					+ requiredLabel%>' />
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
			</#if> <#-- primary key check -->
		</#list>
		<#-- ---------------- -->
		<#-- field loop ends  -->
		<#-- ---------------- -->

<#if ratings > 
		<%
			if (${uncapFirstModel}.getPrimaryKey() != 0) {
		%>
		<liferay-ui:ratings className="<%=${capFirstModel}.class.getName()%>"
			classPK="<%=${uncapFirstModel}.getPrimaryKey()%>" type="stars" />
		<%
			}
		%>
</#if>		
<#if categories >		
		<aui:input name="categories" type="assetCategories" />
</#if>		
		<aui:input name="tags" type="assetTags" />

		<liferay-ui:panel defaultState="closed" extended="<%=false%>"
			id="${uncapFirstModel}EntryAssetLinksPanel" persistState="<%=true%>"
			title="related-assets">
			<aui:fieldset>
				<liferay-ui:input-asset-links
					className="<%=${capFirstModel}.class.getName()%>"
					classPK="<%=${uncapFirstModel}.getPrimaryKey()%>" />
			</aui:fieldset>
		</liferay-ui:panel>

		<%
		//This tags are only necessarily in Asset publisher
		if(fromAsset) {
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
					.hasWorkflowDefinitionLink(
            		themeDisplay.getCompanyId(), scopeGroupId,
					${capFirstModel}.class.getName())) {
						publishButtonLabel = "submit-for-publication";
				}
			%>
            <aui:button cssClass="btn-lg" type="submit" primary="<%= false %>"
				onClick="<%=renderResponse.getNamespace() +\"saveEditors()\"%>"
				value="<%=publishButtonLabel%>" />
			<%
				if (!fromAsset) {
			%>
            &nbsp;&nbsp;&minus; or &minus;
			<aui:button onClick="<%=redirect%>" type="cancel" />
			<%
				}
			%>
		</aui:button-row>
	</aui:form>
<#if discussion >	
	<%
    if (${uncapFirstModel}.getPrimaryKey() != 0 && false == fromAsset) {
	%>
	<liferay-ui:panel-container extended="<%=false%>"
		id="${uncapFirstModel}CommentsPanelContainer" persistState="<%=true%>">

		<liferay-ui:panel collapsible="<%=true%>" extended="<%=true%>"
			id="${uncapFirstModel}CommentsPanel" persistState="<%=true%>"
			title='<%=LanguageUtil.get(request, "comments")%>'>

			<portlet:actionURL name="invokeTaglibDiscussion" var="discussionURL" />

			<liferay-ui:discussion className="<%=${capFirstModel}.class.getName()%>"
				classPK="<%=${uncapFirstModel}.getPrimaryKey()%>" formName="fm2"
				ratingsEnabled="<%=true%>" redirect="<%=currentURL%>"
				userId="<%=${uncapFirstModel}.getUserId()%>" />
		</liferay-ui:panel>

	</liferay-ui:panel-container>
	<%
	}
	%>
</#if>	
</div>

<#list application.fields as field >
	<#if field.type?string == "com.liferay.damascus.cli.json.fields.RichText" >
<aui:script>
	function <portlet:namespace />init${field.name}Editor() {
		return '<%=UnicodeFormatter.toString(${uncapFirstModel}.get${field.name?cap_first}())%>';
	}
</aui:script>

	</#if>
</#list>

<aui:script>
	function <portlet:namespace />saveEditors() {
<#list application.fields as field >
	<#if field.type?string == "com.liferay.damascus.cli.json.fields.RichText" >
		document.<portlet:namespace />${lowercaseModel}Edit.<portlet:namespace />${field.name}.value =
		window.<portlet:namespace />${field.name}Editor.getHTML();
	</#if>
</#list>
		submitForm(document.<portlet:namespace />${lowercaseModel}Edit);
	}
</aui:script>

<%
	${capFirstModel}ItemSelectorHelper ${uncapFirstModel}ItemSelectorHelper = (${capFirstModel}ItemSelectorHelper) request
		.getAttribute(${capFirstModel}WebKeys.${uppercaseModel}_ITEM_SELECTOR_HELPER);
	RequestBackedPortletURLFactory requestBackedPortletURLFactory = RequestBackedPortletURLFactoryUtil
		.create(liferayPortletRequest);
	String selectItemName = liferayPortletResponse.getNamespace()
			+ "selectItem";
%>

<aui:script>
    function <portlet:namespace />dlBrowse (title, inputField) {
       	event.preventDefault();
       	var itemSrc = $('#'+inputField);
		AUI().use(
			'liferay-item-selector-dialog',
			function(A) {
				var itemSelectorDialog = new A.LiferayItemSelectorDialog(
				    {
				        eventName: '<%=selectItemName%>',
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
				        url: '<%=${uncapFirstModel}ItemSelectorHelper.getItemSelectorURL(
						requestBackedPortletURLFactory, themeDisplay, selectItemName)%>'
				    }
				);
				itemSelectorDialog.open();
			}
		);
    }
</aui:script>