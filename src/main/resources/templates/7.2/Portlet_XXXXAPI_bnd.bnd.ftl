# <dmsc:root templateName="Portlet_XXXXAPI_bnd.bnd.ftl"  />
# <dmsc:sync id="head-common" > #
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/bnd.bnd">
#</dmsc:sync> #
Bundle-Name: ${dashcaseProjectName}-api
Bundle-SymbolicName: ${packageName}.api
Bundle-Version: 1.0.0
Export-Package:\
	${packageName}.exception,\
	${packageName}.model,\
	${packageName}.service,\
	${packageName}.service.persistence,\
	${packageName}.constants
-check: EXPORTS
-includeresource: META-INF/service.xml=../${dashcaseProjectName}-service/service.xml