/* <dmsc:sync id="head-common" >  */ 
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/build.gradle">
/* </dmsc:sync> */ 
apply plugin: 'eclipse'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'java'

// <dmsc:root templateName="Portlet_XXXXWEB_build.gradle.ftl"  />

//Need for Windows
def defaultEncoding = 'UTF-8'

dependencies {
	compile group: "com.google.guava", name: "guava", version: "28.1-jre", transitive: false
	compile group: "com.liferay", name: "com.liferay.friendly.url.api", version: "2.0.0"
	compile group: "com.liferay", name: "com.liferay.petra.function", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.petra.lang", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.petra.string", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.portal.aop.api", version: "1.0.0"
	compile group: "com.liferay", name: "com.liferay.portal.search.api"
	compile group: "com.liferay", name: "com.liferay.portal.search.spi"
	compile group: "com.liferay", name: "com.liferay.trash.api", version: "2.0.0"
	compile group: "com.liferay.portal", name: "com.liferay.portal.kernel"
	compile group: "commons-io", name: "commons-io", version: "2.6"
	compile group: "commons-validator", name: "commons-validator", version: "1.6"
	compile group: "javax.portlet", name: "portlet-api", version: "3.0.1"
	compile group: "javax.servlet", name: "javax.servlet-api", version: "3.0.1"
	compile group: "javax.servlet.jsp", name: "javax.servlet.jsp-api", version: "2.3.1"
	compile group: "org.apache.commons", name: "commons-lang3", version: "3.9"
	compile group: "org.apache.felix", name: "org.apache.felix.http.servlet-api", version: "1.1.2"
	compile group: "org.osgi", name: "org.osgi.annotation.versioning", version: "1.1.0"
	compile group: "org.osgi", name: "org.osgi.service.cm", version: "1.5.0"
	compile group: "org.osgi", name: "org.osgi.service.component.annotations", version: "1.3.0"
	compile group: "org.osgi", name: "osgi.core", version: "6.0.0"
	compile project(":modules:${snakecaseModel}:${snakecaseModel}-api")
}

buildService {
	apiDir = "../${snakecaseModel}-api/src/main/java"
}

group = "${packageName}"