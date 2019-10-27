# <dmsc:root templateName="Portlet_XXXXSVC_bnd.bnd.ftl"  />
Bundle-Name: ${snakecaseModel}-service
Bundle-SymbolicName: ${packageName}.service
Bundle-Version: 1.0.0
Import-Package:\
	!com.google.*,\
	!org.checkerframework.* ,\
	*
Liferay-Require-SchemaVersion: 1.0.0
Liferay-Service: true
-dsannotations-options: inherit
-includeresource:\
	@guava-*.jar,\
	@commons-lang3-*.jar