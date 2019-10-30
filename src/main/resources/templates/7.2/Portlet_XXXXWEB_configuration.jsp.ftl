<%-- <dmsc:root  templateName="Portlet_XXXXWEB_configuration.jsp.ftl" /> --%>
<%-- <dmsc:sync id="head-common" > --%>
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}/configuration.jsp">
<%-- </dmsc:sync> --%>
<%@ include file="./init.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<liferay-portlet:actionURL
	portletConfiguration="<%= true %>"
	var="configurationActionURL"
/>

<liferay-portlet:renderURL
	portletConfiguration="<%= true %>"
	var="configurationRenderURL"
/>

<aui:form action="<%= configurationActionURL %>" method="post" name="fm">
	<div class="portlet-configuration-body-content">
		<div class="container-fluid-1280">
			<aui:fieldset-group markupView="lexicon">
				<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
				<aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />

				<aui:fieldset>
					<aui:input name="dateFormat" required="<%= true %>" size="45" type="text" value="<%= dateFormatVal %>" />
					<aui:input name="datetimeFormat" required="<%= true %>" size="45" type="text" value="<%= datetimeFormatVal %>" />

					<aui:select name="prefsViewType">
						<aui:option label='<%= LanguageUtil.get(resourceBundle, "prefs-view-type-default") %>' selected='<%= (prefsViewType.equals("0")) %>' value="0" />
						<aui:option label='<%= LanguageUtil.get(resourceBundle, "prefs-view-type-user") %>' selected='<%= (prefsViewType.equals("1")) %>' value="1" />
						<aui:option label='<%= LanguageUtil.get(resourceBundle, "prefs-view-type-user-group") %>' selected='<%= (prefsViewType.equals("2")) %>' value="2" />
					</aui:select>

					<br />
					<br />
				</aui:fieldset>
			</aui:fieldset-group>
		</div>
	</div>

	<aui:button-row>
		<aui:button type="submit"></aui:button>
	</aui:button-row>
</aui:form>