// <dmsc:root templateName="Portlet_XXXXWEB_build.gradle.ftl"  />
// <dmsc:sync id="head-common" >  //
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/build.gradle">
<#assign skipTemplate = !generateWeb>
// </dmsc:sync> //
apply plugin: 'java'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'eclipse'

sourceCompatibility = 1.8
targetCompatibility = 1.8

//Need for Windows
def defaultEncoding = 'UTF-8'

dependencies {
	compile group: "biz.aQute.bnd", name: "biz.aQute.bndlib", version: "3.5.0"
	compile group: "org.apache.poi", name: "poi"<#if useTP?? && false == useTP>, version: "4.0.1"</#if>
	compile group: "org.apache.poi", name: "poi-ooxml"<#if useTP?? && false == useTP>, version: "4.0.1"</#if>
	compile group: "org.apache.poi", name: "poi-ooxml-schemas"<#if useTP?? && false == useTP>, version: "4.0.1"</#if>

	compileOnly group: "com.liferay", name: "com.liferay.application.list.api"<#if useTP?? && false == useTP>, version: "4.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.asset.api"<#if useTP?? && false == useTP>, version: "2.1.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.asset.display.page.api"<#if useTP?? && false == useTP>, version: "5.1.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.asset.display.page.item.selector.api"<#if useTP?? && false == useTP>, version: "2.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.asset.info.display.api"<#if useTP?? && false == useTP>, version: "2.1.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.asset.taglib"<#if useTP?? && false == useTP>, version: "4.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.comment.taglib"<#if useTP?? && false == useTP>, version: "2.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib"<#if useTP?? && false == useTP>, version: "4.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib.clay"<#if useTP?? && false == useTP>, version: "2.1.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib.soy"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib.util"<#if useTP?? && false == useTP>, version: "2.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.info.api"<#if useTP?? && false == useTP>, version: "4.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.item.selector.api"<#if useTP?? && false == useTP>, version: "4.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.item.selector.criteria.api"<#if useTP?? && false == useTP>, version: "4.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.item.selector.taglib"<#if useTP?? && false == useTP>, version: "3.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.reflect"<#if useTP?? && false == useTP>, version: "3.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.string"<#if useTP?? && false == useTP>, version: "3.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.function"<#if useTP?? && false == useTP>, version: "3.0.+"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.trash.api"<#if useTP?? && false == useTP>, version: "2.0.+"</#if>
	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel"<#if useTP?? && false == useTP>, version: "4.13.0"</#if>
	compileOnly group: "com.liferay.portal", name: "com.liferay.util.taglib"<#if useTP?? && false == useTP>, version: "4.1.0"</#if>
	compileOnly group: "javax.portlet", name: "portlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
	compileOnly group: "javax.servlet.jsp", name: "jsp-api"<#if useTP?? && false == useTP>, version: "2.1"</#if>
	compileOnly group: "jstl", name: "jstl"<#if useTP?? && false == useTP>, version: "1.2"</#if>
	compileOnly group: "org.apache.felix", name: "org.apache.felix.http.servlet-api", version: "1.1.+"
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations", version: "1.3.0"
	compileOnly group: 'org.slf4j', name: 'slf4j-api', version: '1.7.+'
	compileOnly project(":${dashcaseProjectName}-api")
	compileOnly project(":${dashcaseProjectName}-service")
}