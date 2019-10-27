<%-- <dmsc:root  templateName="Portlet_XXXXWEB_admin_view_record.jsp.ftl" /> --%>

<%@ include file="./init.jsp" %>

<%
${capFirstModel} ${uncapFirstModel} = (${capFirstModel})request.getAttribute("${uncapFirstModel}");
String redirect = ParamUtil.getString(request, "redirect");
boolean fromAsset = ParamUtil.getBoolean(request, "fromAsset", false);
portletDisplay.setShowBackIcon(true);
portletDisplay.setURLBack(redirect);
%>

<div class="container-fluid-1280 entry-body">
	<div class="lfr-form-content">
		<aui:fieldset-group markupView="lexicon">
			<aui:fieldset>
				<aui:fieldset>
					<div class="form-group">
						<h3><liferay-ui:message key="asset-title" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbTitleName() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="summary" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbSummaryName() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}Id" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbId() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-title" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getTitle() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}BooleanStat" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbBooleanStat() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}DateTime" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbDateTime() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}DocumentLibrary" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbDocumentLibrary() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}Double" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbDouble() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}Integer" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbInteger() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}RichText" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbRichText() %></p>
					</div>

					<div class="form-group">
						<h3><liferay-ui:message key="${lowercaseModel}-${lowercaseModel}Text" /></h3>

						<p class="form-control"><%= ${uncapFirstModel}.getSamplesbText() %></p>
					</div>
				</aui:fieldset>
			</aui:fieldset>
		</aui:fieldset-group>
	</div>
</div>