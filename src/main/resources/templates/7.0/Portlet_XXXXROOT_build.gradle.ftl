<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/build.gradle">
buildscript {
	dependencies {
		classpath group: "com.liferay", name: "com.liferay.gradle.plugins", version: "3.1.3"
		classpath group: "com.liferay", name: "com.liferay.gradle.plugins.defaults", version: "latest.release"
	}

	repositories {
		mavenLocal()

		maven {
			url "https://cdn.lfrs.sl/repository.liferay.com/nexus/content/groups/public"

		}
	}
}

subprojects {
	apply plugin: "com.liferay.plugin"

	repositories {
		mavenLocal()

		maven {
			url "https://cdn.lfrs.sl/repository.liferay.com/nexus/content/groups/public"
		}
	}
}