// <dmsc:root templateName="Portlet_XXXXROOT_build.gradle.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/build.gradle">
// </dmsc:sync> //

buildscript {
	dependencies {
		classpath group: "com.liferay", name: "com.liferay.gradle.plugins", version: "4.4.49"
	}

	repositories {
		maven {
			url "https://repository-cdn.liferay.com/nexus/content/groups/public"
		}
	}
}

subprojects {
	apply plugin: "com.liferay.plugin"

	repositories {
		maven {
			url "https://repository-cdn.liferay.com/nexus/content/groups/public"
		}
	}
}