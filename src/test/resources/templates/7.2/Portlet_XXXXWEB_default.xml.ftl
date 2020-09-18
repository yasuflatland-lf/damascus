<?xml version="1.0"?>
<!DOCTYPE resource-action-mapping PUBLIC "-//Liferay//DTD Resource Action Mapping 7.0.0//EN" "http://www.liferay.com/dtd/liferay-resource-action-mapping_7_0_0.dtd">
<!-- <dmsc:root templateName="Portlet_XXXXWEB_default.xml.ftl"  /> -->
<!-- <dmsc:sync id="head-common" > -->
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/resource-actions/default.xml">
<#assign skipTemplate = !generateWeb>
<!-- </dmsc:sync> -->
<resource-action-mapping>
<!-- <dmsc:sync id="model-definitions" >  -->
<#list damascus.applications as app >
	<portlet-resource>
		<portlet-name>${packageSnake}_web_${app.model?cap_first}Portlet</portlet-name>
		<permissions>
			<supports>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_TO_PAGE</action-key>
				<action-key>CONFIGURATION</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>PERMISSIONS</action-key>
				<action-key>VIEW</action-key>
			</supports>
			<site-member-defaults>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_TO_PAGE</action-key>
				<action-key>CONFIGURATION</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>VIEW</action-key>
			</site-member-defaults>
			<guest-defaults>
				<action-key>VIEW</action-key>
			</guest-defaults>
			<guest-unsupported>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_TO_PAGE</action-key>
				<action-key>CONFIGURATION</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>PERMISSIONS</action-key>
			</guest-unsupported>
		</permissions>
	</portlet-resource>
	<portlet-resource>
		<portlet-name>${packageSnake}_web_${app.model?cap_first}AdminPortlet</portlet-name>
		<permissions>
			<supports>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_TO_PAGE</action-key>
				<action-key>CONFIGURATION</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>PERMISSIONS</action-key>
				<action-key>VIEW</action-key>
			</supports>
			<site-member-defaults>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_TO_PAGE</action-key>
				<action-key>CONFIGURATION</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>VIEW</action-key>
			</site-member-defaults>
			<guest-defaults>
				<action-key>VIEW</action-key>
			</guest-defaults>
			<guest-unsupported>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_TO_PAGE</action-key>
				<action-key>CONFIGURATION</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>PERMISSIONS</action-key>
			</guest-unsupported>
		</permissions>
	</portlet-resource>
</#list>
<!-- </dmsc:sync> -->
</resource-action-mapping>
