// <dmsc:root templateName="Portlet_XXXXAPI_build.gradle.ftl"  />

dependencies {
	compile group: "javax.portlet", name: "portlet-api", version: "3.0.1"
	compile group: "javax.servlet", name: "javax.servlet-api", version: "3.0.1"

	compileOnly group: "com.liferay.portal", name: "com.liferay.portal.kernel"
	compileOnly group: "org.osgi", name: "org.osgi.annotation.versioning"
	compileOnly group: "org.osgi", name: "org.osgi.core"
	compileOnly group: "org.osgi", name: "org.osgi.service.component.annotations"
}