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
	compile group: "org.apache.poi", name: "poi", version: "4.0.1"
	compile group: "org.apache.poi", name: "poi-ooxml", version: "4.0.1"
	compile group: "org.apache.poi", name: "poi-ooxml-schemas", version: "4.0.1"

	compileOnly group: "com.liferay", name: "com.liferay.application.list.api", version: "4.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.asset.api", version: "2.1.+"
	compileOnly group: "com.liferay", name: "com.liferay.asset.display.page.api", version: "5.1.0"
	compileOnly group: "com.liferay", name: "com.liferay.asset.display.page.item.selector.api", version: "2.0.0"
	compileOnly group: "com.liferay", name: "com.liferay.asset.info.display.api", version: "2.1.0"
	compileOnly group: "com.liferay", name: "com.liferay.asset.taglib", version: "4.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.comment.taglib", version: "2.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib", version: "4.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib.clay", version: "2.1.+"
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib.soy", version: "3.0.0"
	compileOnly group: "com.liferay", name: "com.liferay.frontend.taglib.util", version: "2.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.info.api", version: "4.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.item.selector.api", version: "4.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.item.selector.criteria.api", version: "4.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.item.selector.taglib", version: "3.0.+"
	compileOnly group: "com.liferay", name: "com.liferay.petra.reflect", version: "3.0.+"
	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel", version: "4.13.0"
	compileOnly group: "com.liferay.portal", name: "com.liferay.util.taglib", version: "4.1.0"
	compileOnly group: "javax.portlet", name: "portlet-api", version: "3.0.1"
	compileOnly group: "javax.servlet.jsp", name: "javax.servlet.jsp-api", version: "2.3.1"
	compileOnly group: "jstl", name: "jstl", version: "1.2"
	compileOnly group: "org.apache.felix", name: "org.apache.felix.http.servlet-api", version: "1.1.2"
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations", version: "1.3.0"
	compileOnly group: 'org.slf4j', name: 'slf4j-api', version: '1.7.26'
	compileOnly project(":${dashcaseProjectName}-api")
	compileOnly project(":${dashcaseProjectName}-service")
}