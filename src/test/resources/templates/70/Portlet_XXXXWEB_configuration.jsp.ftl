<#include "./valuables.ftl">
<#assign createPath = "${entityWebResourcesPath}/configuration.jsp">

<%@ include file="/init.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<liferay-portlet:actionURL portletConfiguration="<%= true %>"
                           var="configurationActionURL"
/>

<liferay-portlet:renderURL portletConfiguration="<%= true %>"
                           var="configurationRenderURL" />
<aui:form action="<%= configurationActionURL %>" method="post" name="fm">
    <div class="portlet-configuration-body-content">
        <div class="container-fluid-1280">
            <aui:fieldset-group markupView="lexicon">
                <aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
                <aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />

                <aui:fieldset>
                    <aui:input type="text" name="dateFormat" value="<%= dateFormatVal %>" size="45" required="<%= true %>" />
                    <aui:input type="text" name="datetimeFormat" value="<%= datetimeFormatVal %>" size="45" required="<%= true %>" />
                    <aui:select name="prefsViewType">
                        <aui:option value="0" selected="<%= (prefsViewType.equals("0")) %>" label="<%= LanguageUtil.get(resourceBundle, "prefs-view-type-default") %>" />
                        <aui:option value="1" selected="<%= (prefsViewType.equals("1")) %>" label="<%= LanguageUtil.get(resourceBundle, "prefs-view-type-user") %>" />
                        <aui:option value="2" selected="<%= (prefsViewType.equals("2")) %>" label="<%= LanguageUtil.get(resourceBundle, "prefs-view-type-user-group") %>" />
                    </aui:select>
                    <br />
                    <br />
                </aui:fieldset>

                <aui:button-row>
                    <aui:button type="submit"></aui:button>
                </aui:button-row>
            </aui:fieldset-group>
        </div>
    </div>
</aui:form>
