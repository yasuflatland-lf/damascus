// <dmsc:root templateName="Portlet_XXXXAPI_build.gradle.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/build.gradle">
// </dmsc:sync> //
apply plugin: 'java'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'eclipse'

//Need for Windows
def defaultEncoding = 'UTF-8'

dependencies {
	compileOnly group: "com.liferay.portal", name: "release.portal.api"
	compileOnly group: "javax.portlet", name: "portlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
	compileOnly group: "javax.servlet", name: "javax.servlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>

	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel"<#if useTP?? && false == useTP>, version: "7.2.0"</#if>
	compileOnly group: "org.osgi", name: "org.osgi.annotation.versioning"<#if useTP?? && false == useTP>, version: "1.1.0"</#if>
	compileOnly group: "org.osgi", name: "org.osgi.core"<#if useTP?? && false == useTP>, version: "6.0.0"</#if>
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations"<#if useTP?? && false == useTP>, version: "1.3.0"</#if>
}