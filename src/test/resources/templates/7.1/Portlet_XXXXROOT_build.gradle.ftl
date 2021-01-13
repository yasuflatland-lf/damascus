<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/build.gradle">
buildscript {
	dependencies {
		classpath group: "com.liferay", name: "com.liferay.gradle.plugins", version: "3.13.26"
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