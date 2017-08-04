<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/bnd.bnd">

Bundle-Name: ${dashcaseProjectName}-api
Bundle-SymbolicName: ${packageName}.api
Bundle-Version: 1.0.0
Export-Package:\
	${packageName}.exception,\
	${packageName}.constants,\
	${packageName}.model,\
	${packageName}.service,\
	${packageName}.service.persistence
-includeresource: META-INF/service.xml=../${dashcaseProjectName}-service/service.xml
