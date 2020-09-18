<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/bnd.bnd">
<#assign skipTemplate = !generateWeb>
Bundle-Name: ${dashcaseProjectName}-web
Bundle-SymbolicName: ${packageName}.web
Bundle-Version: 1.0.0

Import-Package:\
	!com.google.*,\
	!org.checkerframework.* ,\
	!org.apache.commons.*,\
	*

Export-Package:\
	${packageName}.web.asset,\
	${packageName}.web.social
	
-includeresource:\
	@guava-*.jar,\
	@error_prone_annotations-*.jar,\
	@commons-digester-*.jar,\
	@commons-validator-*.jar,\
	@commons-io-*.jar,\
	@commons-lang3-*.jar

Web-ContextPath: /${dashcaseProjectName}-web

-metatype: *
-dsannotations-options: inherit