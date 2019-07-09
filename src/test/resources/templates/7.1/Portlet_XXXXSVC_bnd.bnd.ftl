<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/bnd.bnd">
Bundle-Name: ${dashcaseProjectName}-service
Bundle-SymbolicName: ${packageName}.service
Bundle-Version: 1.0.0
Export-Package:\
${packageName}.service.permission,\
${packageName}.service.util
Liferay-Require-SchemaVersion: 1.0.0
Liferay-Service: true

Conditional-Package: \
	com.google.*,\
	org.apache.*