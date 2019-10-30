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
	compile group: "javax.portlet", name: "portlet-api", version: "3.0.1"
	compile group: "javax.servlet", name: "javax.servlet-api", version: "3.0.1"

	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel", version: "4.13.0"
	compileOnly group: "org.osgi", name: "org.osgi.annotation.versioning", version: "1.1.0"
	compileOnly group: "org.osgi", name: "org.osgi.core", version: "6.0.0"
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations", version: "1.3.0"
}