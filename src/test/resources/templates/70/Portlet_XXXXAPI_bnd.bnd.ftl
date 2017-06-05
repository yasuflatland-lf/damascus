<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-api/bnd.bnd">

Bundle-Name: ${application.model}-api
Bundle-SymbolicName: ${application.packageName}.api
Bundle-Version: 1.0.0
Export-Package:\
	${application.packageName}.exception,\
	${application.packageName}.constants,\
	${application.packageName}.model,\
	${application.packageName}.service,\
	${application.packageName}.service.persistence
-includeresource: META-INF/service.xml=../${application.model}-service/service.xml
