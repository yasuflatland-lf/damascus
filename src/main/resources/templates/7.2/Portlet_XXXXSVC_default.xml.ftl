<?xml version="1.0"?>
<!DOCTYPE resource-action-mapping PUBLIC "-//Liferay//DTD Resource Action Mapping 7.0.0//EN" "http://www.liferay.com/dtd/liferay-resource-action-mapping_7_0_0.dtd">
<!-- <dmsc:root templateName="Portlet_XXXXSVC_default.xml.ftl"  /> -->
<!-- <dmsc:sync id="head-common" >  -->
	<#include "./valuables.ftl">
	<#assign createPath = "${serviceModulePath}/src/main/resources/META-INF/resource-actions/default.xml">
	<!-- </dmsc:sync> -->
	
<resource-action-mapping>

	<model-resource>
		<model-name>${packageName}</model-name>
		<portlet-ref>
			<portlet-name>com_liferay_sb_test_web_${capFirstModel}Portlet</portlet-name>
			<portlet-name>com_liferay_sb_test_web_${capFirstModel}AdminPortlet</portlet-name>
		</portlet-ref>
		<root>true</root>
		<weight>1</weight>
		<permissions>
			<supports>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>UPDATE</action-key>
				<action-key>VIEW</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>PERMISSIONS</action-key>
			</supports>
			<site-member-defaults>
				<action-key>UPDATE</action-key>
				<action-key>VIEW</action-key>
				<action-key>ADD_ENTRY</action-key>
			</site-member-defaults>
			<guest-defaults>
				<action-key>VIEW</action-key>
			</guest-defaults>
			<guest-unsupported>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>UPDATE</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>PERMISSIONS</action-key>
			</guest-unsupported>
		</permissions>
	</model-resource>
	<model-resource>
		<model-name>${packageName}.model.${capFirstModel}</model-name>
		<portlet-ref>
			<portlet-name>com_liferay_sb_test_web_${capFirstModel}Portlet</portlet-name>
			<portlet-name>com_liferay_sb_test_web_${capFirstModel}AdminPortlet</portlet-name>
		</portlet-ref>
		<weight>2</weight>
		<permissions>
			<supports>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>DELETE</action-key>
				<action-key>PERMISSIONS</action-key>
				<action-key>UPDATE</action-key>
				<action-key>VIEW</action-key>
			</supports>
			<site-member-defaults>
				<action-key>UPDATE</action-key>
				<action-key>VIEW</action-key>
				<action-key>ADD_ENTRY</action-key>
			</site-member-defaults>
			<guest-defaults>
				<action-key>VIEW</action-key>
			</guest-defaults>
			<guest-unsupported>
				<action-key>ACCESS_IN_CONTROL_PANEL</action-key>
				<action-key>ADD_ENTRY</action-key>
				<action-key>DELETE</action-key>
				<action-key>PERMISSIONS</action-key>
				<action-key>UPDATE</action-key>
			</guest-unsupported>
		</permissions>
	</model-resource>
</resource-action-mapping>