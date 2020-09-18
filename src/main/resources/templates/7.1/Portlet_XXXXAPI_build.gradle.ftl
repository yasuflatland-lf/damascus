<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/build.gradle">
apply plugin: 'java'
apply plugin: 'groovy'
apply plugin: 'idea'
apply plugin: 'eclipse'

dependencies {
    compileOnly group: "biz.aQute.bnd", name: "biz.aQute.bndlib", version: "3.1.0"
    compileOnly group: "com.liferay", name: "com.liferay.osgi.util"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel"<#if useTP?? && false == useTP>, version: "3.0.0"</#if>
    compileOnly group: "javax.portlet", name: "portlet-api"<#if useTP?? && false == useTP>, version: "2.0"</#if>
    compileOnly group: "javax.servlet", name: "javax.servlet-api"<#if useTP?? && false == useTP>, version: "3.0.1"</#if>
    compileOnly group: "org.osgi", name: "org.osgi.core"<#if useTP?? && false == useTP>, version: "6.0.0"</#if>
}