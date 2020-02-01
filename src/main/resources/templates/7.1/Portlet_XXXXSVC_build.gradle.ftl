<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/build.gradle">
apply plugin: 'java'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'eclipse'


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
	compile 'com.google.errorprone:error_prone_annotations:2.0.19'
	compile 'commons-digester:commons-digester<#if useTP?? && false == useTP>:1.8.1</#if>'
	compile "com.google.guava:guava<#if useTP?? && false == useTP>:21.0</#if>"
	compile "commons-io:commons-io<#if useTP?? && false == useTP>:2.5</#if>"
	compile "commons-validator:commons-validator<#if useTP?? && false == useTP>:1.6</#if>"
	compile "org.apache.commons:commons-lang3:3.5"

	compileOnly group: "biz.aQute.bnd", name: "biz.aQute.bndlib", version: "3.1.0"
	compileOnly group: "com.liferay", name: "com.liferay.portal.spring.extender.api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.osgi.util"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.lang"<#if useTP?? && false == useTP>, version: "1.0.0"</#if>
	compileOnly group: "com.liferay", name: "com.liferay.petra.string"<#if useTP?? && false == useTP>, version: "1.0.0"</#if>
	compileOnly group: "javax.portlet", name: "portlet-api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
	compileOnly group: "javax.servlet", name: "javax.servlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations"<#if useTP?? && false == useTP>, version: "1.3.0"</#if>
	compile project(":${dashcaseProjectName}-api")
}

buildscript {
    dependencies {
        classpath group: "com.liferay", name: "com.liferay.gradle.plugins.service.builder", version: "2.1.66"
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