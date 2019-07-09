<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/bnd.bnd">
<#assign skipTemplate = !generateWeb>
Bundle-Name: ${dashcaseProjectName}-web
Bundle-SymbolicName: ${packageName}.web
Bundle-Version: 1.0.0
Export-Package:\
	${packageName}.web.asset,\
	${packageName}.web.social

Import-Package:\
	!org.apache.avalon.*,\
	!org.apache.log.*,\
	*

Conditional-Package: \
	com.google.*,\
	org.apache.*

Web-ContextPath: /${dashcaseProjectName}-web

-metatype: *
-dsannotations-options: inherit