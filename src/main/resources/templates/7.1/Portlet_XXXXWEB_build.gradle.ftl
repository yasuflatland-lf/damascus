<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/build.gradle">
<#assign skipTemplate = !generateWeb>
apply plugin: 'java'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'eclipse'

sourceCompatibility = 1.8
targetCompatibility = 1.8

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

// TODO : This can be removed once you set up IDE. When you import this project into a IDE, you may be asked
// a path to the gradle root. Then you run "gradle getHomeDir" and use the path for the IDE.
task getHomeDir << {
    println gradle.gradleHomeDir
}

dependencies {
    <#if useTP?? && true == useTP>
    // needed because of an issue with 7.1's 3rd party boms.
    implementation enforcedPlatform(group: "javax.servlet", name: "javax.servlet-api", version: "3.0.1")

    </#if>
    compile 'com.google.errorprone:error_prone_annotations:2.0.19'
    compile 'commons-digester:commons-digester:1.8.1'
    compile "com.google.guava:guava:21.0"
    compile "commons-io:commons-io<#if useTP?? && false == useTP>:2.5</#if>"
    compile "commons-validator:commons-validator:1.6"
    compile "org.apache.commons:commons-lang3:3.5"
	compile group: "biz.aQute.bnd", name: "biz.aQute.bndlib", version: "3.1.0"
	compile group: "com.liferay", name: "com.liferay.portal.spring.extender.api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay", name: "com.liferay.application.list.api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay", name: "com.liferay.frontend.taglib"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay", name: "com.liferay.item.selector.api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay", name: "com.liferay.item.selector.criteria.api"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay", name: "com.liferay.item.selector.taglib"<#if useTP?? && false == useTP>, version: "1.0.0"</#if>
    compile group: "com.liferay", name: "com.liferay.trash.taglib"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay.portal", name: "com.liferay.portal.kernel"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay.portal", name: "com.liferay.portal.impl"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "com.liferay.portal", name: "com.liferay.util.taglib"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compile group: "javax.portlet", name: "portlet-api"<#if useTP?? && false == useTP>, version: "2.0"</#if>
    compile group: "javax.servlet", name: "javax.servlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
    compile group: "jstl", name: "jstl"<#if useTP?? && false == useTP>, version: "1.2"</#if>
    compile group: "org.osgi", name: "osgi.cmpn"<#if useTP?? && false == useTP>, version: "6.0.0"</#if>
    compile group: "org.osgi", name: "org.osgi.service.component.annotations"<#if useTP?? && false == useTP>, version: "1.3.0"</#if>
	compile group: 'org.apache.poi', name: 'poi-ooxml', version: '4.0.1'
	compile group: 'org.apache.poi', name: 'poi', version: '4.0.1'
	compile group: 'org.apache.poi', name: 'poi-ooxml-schemas', version: '4.0.1'	
	compile group: 'org.apache.xmlbeans', name: 'xmlbeans', version: '3.0.2'
	compile group: 'org.apache.commons', name: 'commons-collections4', version: '4.2'
	compile group: 'org.apache.commons', name: 'commons-compress', version: '1.18'
	
    compileOnly project(":${dashcaseProjectName}-api")
    compileOnly project(":${dashcaseProjectName}-service")
}