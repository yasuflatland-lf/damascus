// <dmsc:root templateName="Portlet_XXXXSVC_build.gradle.ftl"  />
// <dmsc:sync id="head-common" >  //
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/build.gradle">
// </dmsc:sync> //
apply plugin: 'eclipse'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'java'


//Need for Windows
def defaultEncoding = 'UTF-8'

repositories {
	mavenCentral()
	jcenter()
	maven {
		url "http://repository.jboss.org/nexus/content/groups/public-jboss" // JBoss
		url "http://repository.apache.org/content/groups/public"            // Apache
		url "http://repository.springsource.com/maven/bundles/release"      // SpringSource
		url "http://repository.codehaus.org"                                // Codehaus
		url "http://download.java.net/maven/2"                              // Java.NET
		url "http://download.java.net/maven/glassfish"                      // Glassfish
		url "http://m2repo.spockframework.org/snapshots"                    // Spock Snapshot
		url "http://repository.sonatype.org/content/groups/public"
		url "https://mvnrepository.com/artifact/com.sun/tools"
	}
}

dependencies {
	compile group: "com.google.guava", name: "guava"<#if useTP?? && false == useTP>, version: "28.1-jre"</#if>, transitive: false
	compileOnly group: "com.liferay", name: "com.liferay.friendly.url.api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.function"<#if useTP?? && false == useTP>, version: "4.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.lang"<#if useTP?? && false == useTP>, version: "4.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.string"<#if useTP?? && false == useTP>, version: "4.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.sql.dsl.api"<#if useTP?? && false == useTP>, version: "1.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.portal.aop.api"<#if useTP?? && false == useTP>, version: "2.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.portal.search.api"<#if useTP?? && false == useTP>, version: "4.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.portal.search.spi"<#if useTP?? && false == useTP>, version: "4.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.trash.api"<#if useTP?? && false == useTP>, version: "3.2.+"</#if>
	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel"<#if useTP?? && false == useTP>, version: "7.2.0"</#if>
	compileOnly group: "commons-io", name: "commons-io"<#if useTP?? && false == useTP>, version: "2.6"</#if>
	compile group: "commons-validator", name: "commons-validator"<#if useTP?? && false == useTP>, version: "1.6"</#if>
	compileOnly group: "javax.portlet", name: "portlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
	compileOnly group: "javax.servlet", name: "javax.servlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
	compileOnly group: "javax.servlet.jsp", name: "jsp-api"<#if useTP?? && false == useTP>, version: "2.1"</#if>
	compile group: "org.apache.commons", name: "commons-lang3", version: "3.9"
	compile group: "org.apache.felix", name: "org.apache.felix.http.servlet-api", version: "1.1.2"
	compileOnly group: "org.osgi", name: "org.osgi.annotation.versioning"<#if useTP?? && false == useTP>, version: "1.1.0"</#if>
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations"<#if useTP?? && false == useTP>, version: "1.3.0"</#if>
	compile group: "org.osgi", name: "osgi.core", version: "6.0.0"
	compileOnly group: 'org.slf4j', name: 'slf4j-api', version: '1.7.26'
	compile project(":${dashcaseProjectName}-api")
}

buildscript {
    dependencies {
        classpath group: "com.liferay", name: "com.liferay.gradle.plugins.service.builder", version: "4.0.+"
    }

    repositories {
        maven {
            url "https://repository-cdn.liferay.com/nexus/content/groups/public"
        }
    }
}

apply plugin: "com.liferay.portal.tools.service.builder"

buildService {
	apiDir = "../${dashcaseProjectName}-api/src/main/java"
}

group = "${packageName}"