<?xml version="1.0"?>

<!-- <dmsc:root templateName="Portlet_XXXXSVC_portlet-model-hints.xml.ftl"  /> -->
<!-- <dmsc:sync id="head-common" >  -->
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/resources/META-INF/portlet-model-hints.xml">
<!-- </dmsc:sync> -->

<model-hints>
	<model name="${packageName}.model.${capFirstModel}">
		<field name="uuid" type="String" />
		<field name="${lowercaseModel}Id" type="long" />
		<field name="title" type="String">
			<hint name="max-length">80</hint>
		</field>
		<field name="${lowercaseModel}BooleanStat" type="boolean" />
		<field name="${lowercaseModel}DateTime" type="Date" />
		<field name="${lowercaseModel}DocumentLibrary" type="String">
			<hint name="display-width">60</hint>
			<hint name="max-length">512</hint>
		</field>
		<field name="${lowercaseModel}Double" type="double" />
		<field name="${lowercaseModel}Integer" type="int" />
		<field name="${lowercaseModel}RichText" type="String">
			<hint-collection name="TEXTAREA" />
			<hint name="max-length">4001</hint>
		</field>
		<field name="${lowercaseModel}Text" type="String">
			<hint-collection name="TEXTAREA" />
			<hint name="max-length">4001</hint>
		</field>
		<field name="groupId" type="long" />
		<field name="companyId" type="long" />
		<field name="userId" type="long" />
		<field name="userName" type="String" />
		<field name="createDate" type="Date" />
		<field name="modifiedDate" type="Date" />
		<field name="urlTitle" type="String" />
		<field name="${lowercaseModel}TitleName" type="String">
			<hint name="display-width">200</hint>
			<hint name="max-length">255</hint>
		</field>
		<field name="${lowercaseModel}SummaryName" type="String">
			<hint-collection name="TEXTAREA" />
			<hint name="max-length">4001</hint>
		</field>
		<field name="status" type="int" />
		<field name="statusByUserId" type="long" />
		<field name="statusByUserName" type="String" />
		<field name="statusDate" type="Date" />
	</model>
</model-hints>