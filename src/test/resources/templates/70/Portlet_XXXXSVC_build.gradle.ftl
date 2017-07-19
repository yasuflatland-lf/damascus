<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/build.gradle">
apply plugin: "com.liferay.portal.tools.service.builder"

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
	compile 'commons-digester:commons-digester:1.8.1'
	compile "com.google.guava:guava:21.0"
	compile "commons-io:commons-io:2.5"
	compile "commons-validator:commons-validator:1.6"
	compile "org.apache.commons:commons-lang3:3.5"

	compile group: "biz.aQute.bnd", name: "biz.aQute.bndlib", version: "3.1.0"
	compile group: "com.liferay", name: "com.liferay.osgi.util", version: "3.0.0"
	compile group: "com.liferay", name: "com.liferay.portal.spring.extender", version: "2.0.13"
	compile group: "com.liferay.portal", name: "com.liferay.portal.kernel", version: "2.15.0"
	compile group: "javax.portlet", name: "portlet-api", version: "2.0"
	compile group: "javax.servlet", name: "javax.servlet-api", version: "3.0.1"
	compile group: "org.osgi", name: "org.osgi.service.component.annotations", version: "1.3.0"
	compile project(":${dashcaseProjectName}-api")
}

buildService {
	apiDir = "../${dashcaseProjectName}-api/src/main/java"
}

group = "${packageName}"