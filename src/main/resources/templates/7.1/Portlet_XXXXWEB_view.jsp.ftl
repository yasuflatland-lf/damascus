<#include "./valuables.ftl">
<#assign createPath = "${entityWebResourcesPath}/view.jsp">
<#assign skipTemplate = !generateWeb>
<%@ include file="/${snakecaseModel}/init.jsp"%>
<%
	String iconChecked = "checked";
	String iconUnchecked = "unchecked";
	SimpleDateFormat dateFormat = new SimpleDateFormat(dateFormatVal);
	SimpleDateFormat dateTimeFormat = new SimpleDateFormat(datetimeFormatVal);

	PortletURL navigationPortletURL = renderResponse.createRenderURL();
	PortletURL portletURL = PortletURLUtil.clone(navigationPortletURL, liferayPortletResponse);

	${capFirstModel}ViewHelper ${uncapFirstModel}ViewHelper = (${capFirstModel}ViewHelper) request
			.getAttribute(${capFirstModel}WebKeys.${uppercaseModel}_VIEW_HELPER);

<#list application.fields as field >
	<#if field.validation?? && field.validation.className??>
		<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
		<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">
		<#assign uppercaseValidationModel = "${field.validation.className?upper_case}">
	${capFirstValidationModel}LocalService ${uncapFirstValidationModel}LocalService = (${capFirstValidationModel}LocalService) request
			.getAttribute(${capFirstModel}WebKeys.${uppercaseValidationModel}_LOCAL_SERVICE);
	</#if>
</#list>

<#if advancedSearch>
	Map<String, String> advSearchKeywords = ${uncapFirstModel}ViewHelper.getAdvSearchKeywords(renderRequest, dateFormat);

	Calendar today = Calendar.getInstance();
</#if>

	String keywords = ParamUtil.getString(request, DisplayTerms.KEYWORDS);
	int cur = ParamUtil.getInteger(request, SearchContainer.DEFAULT_CUR_PARAM);
	int delta = ParamUtil.getInteger(request, SearchContainer.DEFAULT_DELTA_PARAM);
	String orderByCol = ParamUtil.getString(request, SearchContainer.DEFAULT_ORDER_BY_COL_PARAM, "${primaryKeyParam}");
	String orderByType = ParamUtil.getString(request, SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM, "asc");
	String[] orderColumns = new String[] {
	"${primaryKeyParam}"
<#list application.fields as field >
	<#if field.primary?? && field.primary == false >
    ,"${field.name}"
	</#if>
</#list>
	};

<#if advancedSearch>
	for(String key : advSearchKeywords.keySet()) {
		navigationPortletURL.setParameter(key, advSearchKeywords.get(key));
	}
</#if>

	navigationPortletURL.setParameter(DisplayTerms.KEYWORDS, keywords);
	navigationPortletURL.setParameter(SearchContainer.DEFAULT_CUR_PARAM, String.valueOf(cur));
	navigationPortletURL.setParameter("mvcRenderCommandName", "/${lowercaseModel}/view");
	navigationPortletURL.setParameter(SearchContainer.DEFAULT_ORDER_BY_COL_PARAM, orderByCol);
	navigationPortletURL.setParameter(SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM, orderByType);

	SearchContainer _searchContainer = new SearchContainer(renderRequest, PortletURLUtil.clone(navigationPortletURL, liferayPortletResponse), null, "no-records-were-found");
	_searchContainer.setId("entryList");
	_searchContainer.setDeltaConfigurable(true);

	_searchContainer.setOrderByCol(orderByCol);
    _searchContainer.setOrderByType(orderByType);

    SearchContainerResults<${capFirstModel}> searchContainerResults = null;
    if (Validator.isNull(keywords)) {
        searchContainerResults = ${uncapFirstModel}ViewHelper.getListFromDB(renderRequest, _searchContainer, new int[] {WorkflowConstants.STATUS_APPROVED});
    } else {
        searchContainerResults = ${uncapFirstModel}ViewHelper.getListFromIndex(renderRequest, _searchContainer, WorkflowConstants.STATUS_APPROVED);
    }

    _searchContainer.setTotal(searchContainerResults.getTotal());
    _searchContainer.setResults(searchContainerResults.getResults());

	boolean managementCheckboxEnabled = false;
	List<${capFirstModel}> results = _searchContainer.getResults();
	if (results != null && results.size() > 0) {
		for(${capFirstModel} result: results) {
			if (${capFirstModel}PermissionChecker.contains(permissionChecker, result, ActionKeys.DELETE)) {
				managementCheckboxEnabled = true;
				break;
			}
		}
	}
	if (managementCheckboxEnabled) {
		EmptyOnClickRowChecker rowChecker = new EmptyOnClickRowChecker(renderResponse);
		_searchContainer.setRowChecker(rowChecker);
	}
%>

<portlet:renderURL var="${lowercaseModel}AddURL">
	<portlet:param name="mvcRenderCommandName" value="/${lowercaseModel}/crud" />
	<portlet:param name="<%=Constants.CMD%>" value="<%=Constants.ADD%>" />
	<portlet:param name="redirect" value="<%=portletURL.toString()%>" />
</portlet:renderURL>
<#if exportExcel>
<portlet:resourceURL id="/${lowercaseModel}/res" var="exportExcelURL" >
	<portlet:param name="<%=Constants.CMD%>" value="<%=Constants.EXPORT%>" />
	<portlet:param name="<%=DisplayTerms.KEYWORDS%>" value="<%=keywords%>" />
	<portlet:param name="<%=SearchContainer.DEFAULT_ORDER_BY_COL_PARAM%>" value="<%=orderByCol%>" />
	<portlet:param name="<%=SearchContainer.DEFAULT_ORDER_BY_TYPE_PARAM%>" value="<%=orderByType%>" />
</portlet:resourceURL>
</#if>
    <div class="container-fluid-1280 icons-container lfr-meta-actions">
		<div class="add-record-button-container pull-left">
			<c:if test="<%= ${capFirstModel}ResourcePermissionChecker.contains(permissionChecker, themeDisplay.getScopeGroupId(), ActionKeys.ADD_ENTRY) %>">
            <aui:button href="<%=${lowercaseModel}AddURL%>" cssClass="btn btn-default"
                icon="icon-plus" value="add-${lowercaseModel}" />
			</c:if>
			<#if exportExcel>
			<aui:button href="<%=exportExcelURL%>" cssClass="btn btn-default"
                icon="icon-plus" value="export-to-excel" />
            </#if>
        </div>
		<div class="lfr-icon-actions">
			<c:if test="<%= ${capFirstModel}ResourcePermissionChecker.contains(permissionChecker, themeDisplay.getScopeGroupId(), ActionKeys.PERMISSIONS) %>">
				<liferay-security:permissionsURL
					modelResource="${packageName}"
					modelResourceDescription="<%= HtmlUtil.escape(themeDisplay.getScopeGroupName()) %>"
					resourcePrimKey="<%= String.valueOf(themeDisplay.getScopeGroupId()) %>"
					var="modelPermissionsURL"
				/>
				<liferay-ui:icon
					cssClass="lfr-icon-action pull-right"
					icon="cog"
					label="<%= true %>"
					markupView="lexicon"
					message="permissions"
					url="<%= modelPermissionsURL %>"
				/>
			</c:if>
		</div>
    </div>

<aui:nav-bar cssClass="collapse-basic-search" markupView="lexicon">
	<aui:form action="<%=portletURL.toString()%>" name="searchFm">
		<aui:nav-bar-search>
			<liferay-ui:input-search markupView="lexicon" />
		</aui:nav-bar-search>
	</aui:form>
</aui:nav-bar>

<#if advancedSearch>
<liferay-ui:panel-container cssClass="container-fluid-1280" extended="<%= false %>" persistState="<%= true %>" markupView="lexicon">
<liferay-ui:panel title="Advance Search" markupView="lexicon" collapsible="<%= true %>" extended="<%= false %>" iconCssClass="icon-plus-sign" id="advanceSearchPanel" persistState="<%= true %>">
	<style>
		#advanceSearchPanel {
			margin-bottom: 4px;
		}
    </style>
	<aui:form action="<%=portletURL.toString()%>" name="advanceSearchForm">
		<aui:container fluid="false">
			<#-- ---------------- -->
			<#-- field loop start -->
			<#-- ---------------- -->
			<#assign dateExist = false>
			<#assign counter = 1>
			<#list application.fields as field >
				<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.Long"     		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Double"   		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Integer"			||
					field.type?string == "com.liferay.damascus.cli.json.fields.Date"     		||
					field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
					field.type?string == "com.liferay.damascus.cli.json.fields.RichText" 		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Text"
					>

					<#if counter % 2 != 0>
						<aui:row>
					</#if>
					<aui:col span="6">
					<#if
						field.type?string == "com.liferay.damascus.cli.json.fields.Long"     		||
						field.type?string == "com.liferay.damascus.cli.json.fields.Double"   		||
						field.type?string == "com.liferay.damascus.cli.json.fields.Integer"
						>
						<aui:input name="search${field.name?cap_first}Start" label="search${field.name?cap_first}Range" type="text"
							inlineField="true">
							<aui:validator name="number" />
						</aui:input>
						<div class="form-group form-group-inline">
							<label class="form-control" style="border-bottom: 0px; display: table-cell; vertical-align: middle;">
								<%= LanguageUtil.get(request, "until") %>
							</label>
						</div>
						<aui:input name="search${field.name?cap_first}End" label="" inlineLabel="true" inlineField="true" type="text">
							<aui:validator name="number" />
						</aui:input>
					</#if>
					<#if
						field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
						field.type?string == "com.liferay.damascus.cli.json.fields.RichText" 		||
						field.type?string == "com.liferay.damascus.cli.json.fields.Text"
						>
						<aui:input  name="search${field.name?cap_first}" type="text"/>
					</#if>

					<#if
						field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
						field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
						>
						<#assign dateExist = true>
						<aui:input name="search${field.name?cap_first}Start" label="search${field.name?cap_first}Range" cssClass="date" type="text"
							placeholder="<%= dateFormatVal %>" inlineField="true" >
							<aui:validator name="date" />
						</aui:input>
						<div class="form-group form-group-inline">
							<label class="form-control" style="border-bottom: 0px; display: table-cell; vertical-align: middle;">
								<%= LanguageUtil.get(request, "until") %>
							</label>
						</div>
						<aui:input name="search${field.name?cap_first}End" label="" inlineLabel="true" inlineField="true"
							cssClass="date" type="text" placeholder="<%= dateFormatVal %>" >
							<aui:validator name="date" />
						</aui:input>
					</#if>
					</aui:col>
					<#if counter % 2 == 0 || field?is_last>
						</aui:row>
					</#if>
					<#assign counter += 1>
				</#if>
				<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.Boolean"  		||
					field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary"
				>
					<#if field?is_last && counter % 2 == 0>
						</aui:row>
					</#if>
				</#if>
			</#list>
			<#-- ---------------- -->
			<#-- field loop ends  -->
			<#-- ---------------- -->

			<#if dateExist>
				<aui:script>
				    AUI().use(
				        'aui-datepicker',
				        function(A) {
				            new A.DatePicker({
				                trigger: '.date',
				                mask: '<%= datePickerFormatVal %>',
				                popover: {
				                    zIndex: 1000
				                }
				            });
				        }
				    );
				</aui:script>
			</#if>
			<style>.center-text { text-align: center; }</style>
			<aui:button-row id="searchButton" cssClass="center-text">
				<aui:button name="searchSubmit" type="submit" value="search" />
				<aui:button name="searchReset" type="cancel" value="reset"
					onClick='<%= portletDisplay.getNamespace() + "resetAdvanceSearch()" %>'>
					<aui:script>
						function <portlet:namespace />resetAdvanceSearch() {
							$('#<portlet:namespace />advanceSearchForm input').each(function() {
								$(this).val('');
							});
						}
					</aui:script>
				</aui:button>
			</aui:button-row>
		</aui:container>
	</aui:form>
</liferay-ui:panel>
</liferay-ui:panel-container>
</#if>

<liferay-frontend:management-bar includeCheckBox="<%=true%>"
	searchContainerId="entryList">

	<liferay-frontend:management-bar-filters>
		<liferay-frontend:management-bar-sort orderByCol="<%=orderByCol%>"
			orderByType="<%=orderByType%>" orderColumns='<%=orderColumns%>'
			portletURL="<%=navigationPortletURL%>" />
	</liferay-frontend:management-bar-filters>

	<liferay-frontend:management-bar-action-buttons>
		<liferay-frontend:management-bar-button
			href='<%="javascript:" + renderResponse.getNamespace() + "deleteEntries();"%>'
			icon='<%=TrashUtil.isTrashEnabled(scopeGroupId) ? "trash" : "times"%>'
			label='<%=TrashUtil.isTrashEnabled(scopeGroupId) ? "recycle-bin" : "delete"%>' />
	</liferay-frontend:management-bar-action-buttons>

</liferay-frontend:management-bar>

<div class="container-fluid-1280"
	id="<portlet:namespace />formContainer">

	<aui:form action="<%=navigationPortletURL.toString()%>" method="get"
		name="fm">
		<aui:input name="<%=Constants.CMD%>" type="hidden" />
		<aui:input name="redirect" type="hidden"
			value="<%=navigationPortletURL.toString()%>" />
		<aui:input name="deleteEntryIds" type="hidden" />

		<liferay-ui:success key="${lowercaseModel}-added-successfully"
							message="${lowercaseModel}-added-successfully" />
        <liferay-ui:success key="${lowercaseModel}-updated-successfully"
                            message="${lowercaseModel}-updated-successfully" />
        <liferay-ui:success key="${lowercaseModel}-deleted-successfully"
                            message="${lowercaseModel}-deleted-successfully" />

		<liferay-ui:error exception="<%=PortletException.class%>"
			message="there-was-an-unexpected-error.-please-refresh-the-current-page" />

		<liferay-ui:search-container searchContainer='<%=_searchContainer%>'>

			<liferay-ui:search-container-row
				className="${packageName}.model.${capFirstModel}"
				escapedModel="<%= true %>" keyProperty="${primaryKeyParam}"
				rowIdProperty="${primaryKeyParam}" modelVar="${uncapFirstModel}">

			<c:choose>
				<c:when test="<%= ${capFirstModel}PermissionChecker.contains(permissionChecker, ${uncapFirstModel}, ActionKeys.VIEW) %>">
			<#-- ---------------- -->
			<#-- field loop start -->
			<#-- ---------------- -->
			<#list application.fields as field >
				<#-- ---------------- -->
				<#--     Long         -->
				<#--     Varchar      -->
				<#--     Boolean      -->
				<#--     Double       -->
				<#-- Document Library -->
				<#--     Integer      -->
				<#-- ---------------- -->
					<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.Long"     		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Varchar"  		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Boolean"  		||
					field.type?string == "com.liferay.damascus.cli.json.fields.Double"   		||
					field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" ||
					field.type?string == "com.liferay.damascus.cli.json.fields.Integer"
					>

						<#if field.validation?? && field.validation.className??>
							<#assign capFirstValidationModel = "${field.validation.className?cap_first}">
							<#assign uncapFirstValidationModel = "${field.validation.className?uncap_first}">

							<#assign fieldName = "PrimaryKey">
							<#if field.validation.fieldName??>
								<#assign fieldName = "${field.validation.fieldName?cap_first}">
							</#if>

							<#assign orderByField = "PrimaryKey">
							<#if field.validation.orderByField??>
								<#assign orderByField = "${field.validation.orderByField?cap_first}">
							</#if>
				<%
				String ${field.name}Text = "";
				try {
					${capFirstValidationModel} ${uncapFirstValidationModel} = ${uncapFirstValidationModel}LocalService.get${capFirstValidationModel}(GetterUtil.getLong(${uncapFirstModel}.get${field.name?cap_first}()));
					${field.name}Text = ${uncapFirstValidationModel}.get${orderByField}();
				} catch(Exception e) {}
				%>
				<liferay-ui:search-container-column-text name="${field.name?cap_first}"
														 align="center" value="<%= ${field.name}Text %>" />
						<#else>
				<liferay-ui:search-container-column-text name="${field.name?cap_first}"
														 property="${field.name}" orderable="true" orderableProperty="${field.name}"
														 align="left" />
						</#if>
					</#if>
				<#-- ---------------- -->
				<#--     Date         -->
				<#--     DateTime     -->
				<#-- ---------------- -->
					<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.Date"     ||
					field.type?string == "com.liferay.damascus.cli.json.fields.DateTime"
					>
				<liferay-ui:search-container-column-text name="${field.name?cap_first}"
														 value="<%= dateFormat.format(${uncapFirstModel}.get${field.name?cap_first}()) %>"
														 orderable="true" orderableProperty="${field.name}" align="left" />
					</#if>

				<#-- ---------------- -->
				<#--     RichText     -->
				<#--       Text       -->
				<#-- ---------------- -->
					<#if
					field.type?string == "com.liferay.damascus.cli.json.fields.RichText" ||
					field.type?string == "com.liferay.damascus.cli.json.fields.Text"
					>
				<liferay-ui:search-container-column-text name="${field.name?cap_first}"
														 align="center">
					<%
					String ${field.name}Icon = iconUnchecked;
					String ${field.name} = ${uncapFirstModel}.get${field.name?cap_first}();
					if (!${field.name}.equals("")) {
						${field.name}Icon= iconChecked;
					}
					%>
					<liferay-ui:icon image="<%= ${field.name}Icon %>" />
				</liferay-ui:search-container-column-text>
					</#if>
			</#list>
			<#-- ---------------- -->
			<#-- field loop ends  -->
			<#-- ---------------- -->

				<liferay-ui:search-container-column-jsp align="right"
					path="/${snakecaseModel}/edit_actions.jsp" />
			</c:when>
			<c:otherwise>
				<%
					row.setCssClass("hidden");
				%>
			</c:otherwise>
			</c:choose>

			</liferay-ui:search-container-row>
			<liferay-ui:search-iterator displayStyle="list" markupView="lexicon" />
		</liferay-ui:search-container>
	</aui:form>
</div>

<aui:script>
	function <portlet:namespace />deleteEntries() {
		if (<%=TrashUtil.isTrashEnabled(scopeGroupId)%> || confirm('<%=UnicodeLanguageUtil.get(request, "are-you-sure-you-want-to-delete-the-selected-entries")%>')) {
			var form = AUI.$(document.<portlet:namespace />fm);

			form.attr('method', 'post');
			form.fm('<%=Constants.CMD%>').val('<%=TrashUtil.isTrashEnabled(scopeGroupId) ? Constants.MOVE_TO_TRASH : Constants.DELETE%>');
			form.fm('deleteEntryIds').val(Liferay.Util.listCheckedExcept(form, '<portlet:namespace />allRowIds'));

			submitForm(form, '<portlet:actionURL name="/${lowercaseModel}/crud" />');
		}
	}
</aui:script>
