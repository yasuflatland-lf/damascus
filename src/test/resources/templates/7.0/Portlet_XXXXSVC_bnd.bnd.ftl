<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/bnd.bnd">
Bundle-Name: ${dashcaseProjectName}-service
Bundle-SymbolicName: ${packageName}.service
Bundle-Version: 1.0.0

Import-Package:\
	!com.google.*,\
	!org.checkerframework.* ,\
	!org.apache.commons.*,\
	*
	
Export-Package:\
${packageName}.service.permission,\
${packageName}.service.util
Liferay-Require-SchemaVersion: 1.0.0
Liferay-Service: true
-dsannotations-options: inherit

-includeresource:\
	@guava-*.jar,\
	@error_prone_annotations-*.jar,\
	@commons-digester-*.jar,\
	@commons-validator-*.jar,\
	@commons-io-*.jar,\
	@commons-lang3-*.jar