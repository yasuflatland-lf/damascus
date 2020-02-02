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
	compile group: "com.google.guava", name: "guava", version: "28.1-jre", transitive: false
	compile group: "com.liferay", name: "com.liferay.friendly.url.api", version: "2.0.0"
	compile group: "com.liferay", name: "com.liferay.petra.function", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.petra.lang", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.petra.string", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.portal.aop.api", version: "1.0.0"
	compile group: "com.liferay", name: "com.liferay.portal.search.api", version: "3.7.0"
	compile group: "com.liferay", name: "com.liferay.portal.search.spi", version: "3.2.0"
	compile group: "com.liferay", name: "com.liferay.trash.api", version: "2.0.0"
	compile group: "com.liferay.portal", name: "com.liferay.portal.kernel", version: "4.13.0"
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
	compileOnly group: 'org.slf4j', name: 'slf4j-api', version: '1.7.26'
	compile project(":${dashcaseProjectName}-api")
}

buildscript {
    dependencies {
        classpath group: "com.liferay", name: "com.liferay.gradle.plugins.service.builder", version: "2.2.+"
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