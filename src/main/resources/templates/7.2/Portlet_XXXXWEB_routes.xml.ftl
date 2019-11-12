<?xml version="1.0"?>
<!DOCTYPE routes PUBLIC "-//Liferay//DTD Friendly URL Routes 7.0.0//EN" "http://www.liferay.com/dtd/liferay-friendly-url-routes_7_0_0.dtd">
<!-- <dmsc:root templateName="Portlet_XXXXWEB_routes.xml.ftl"  /> -->
<!-- <dmsc:sync id="head-common" > -->
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/META-INF/friendly-url-routes/routes.xml">
<#assign skipTemplate = !generateWeb>
<!-- </dmsc:sync> -->
<routes>
	<route>
		<pattern></pattern>
		<implicit-parameter name="mvcRenderCommandName">/${lowercaseModel}/view</implicit-parameter>
		<implicit-parameter name="p_p_lifecycle">0</implicit-parameter>
		<implicit-parameter name="p_p_state">normal</implicit-parameter>
	</route>
	<route>
		<pattern>/maximized</pattern>
		<implicit-parameter name="mvcRenderCommandName">/${lowercaseModel}/view</implicit-parameter>
		<implicit-parameter name="p_p_lifecycle">0</implicit-parameter>
		<implicit-parameter name="p_p_state">maximized</implicit-parameter>
	</route>
	<route>
		<pattern>/{resourcePrimKey:\d+}</pattern>
		<implicit-parameter name="categoryId"></implicit-parameter>
		<implicit-parameter name="mvcRenderCommandName">/${lowercaseModel}/crud</implicit-parameter>
		<implicit-parameter name="p_p_lifecycle">0</implicit-parameter>
		<implicit-parameter name="p_p_state">normal</implicit-parameter>
		<implicit-parameter name="tag"></implicit-parameter>
	</route>
	<route>
		<pattern>/{urlTitle}</pattern>
		<implicit-parameter name="categoryId"></implicit-parameter>
		<implicit-parameter name="mvcRenderCommandName">/${lowercaseModel}/crud</implicit-parameter>
		<implicit-parameter name="p_p_lifecycle">0</implicit-parameter>
		<implicit-parameter name="p_p_state">normal</implicit-parameter>
		<implicit-parameter name="tag"></implicit-parameter>
	</route>
	<route>
		<pattern>/{resourcePrimKey:\d+}/{p_p_state}</pattern>
		<implicit-parameter name="categoryId"></implicit-parameter>
		<implicit-parameter name="mvcRenderCommandName">/${lowercaseModel}/crud</implicit-parameter>
		<implicit-parameter name="p_p_lifecycle">0</implicit-parameter>
		<implicit-parameter name="tag"></implicit-parameter>
	</route>
	<route>
		<pattern>/{urlTitle}/{p_p_state}</pattern>
		<implicit-parameter name="categoryId"></implicit-parameter>
		<implicit-parameter name="mvcRenderCommandName">/${lowercaseModel}/crud</implicit-parameter>
		<implicit-parameter name="p_p_lifecycle">0</implicit-parameter>
		<implicit-parameter name="tag"></implicit-parameter>
	</route>
</routes>