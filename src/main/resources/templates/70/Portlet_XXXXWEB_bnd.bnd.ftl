<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/bnd.bnd">
<#assign skipTemplate = !generateWeb>
Bundle-Name: ${dashcaseProjectName}-web
Bundle-SymbolicName: ${packageName}.web
Bundle-Version: 1.0.0
Export-Package:\
	${packageName}.web.asset,\
	${packageName}.web.social
Bundle-ClassPath:\
	.,\
	lib/guava.jar,\
	lib/error_prone_annotations.jar,\
	lib/commons-digester.jar,\
	lib/commons-validator.jar,\
	lib/commons-io.jar,\
	lib/commons-lang3.jar

-includeresource:\
	lib/guava.jar=guava-[0-9]*.jar,\
	lib/error_prone_annotations.jar=error_prone_annotations-[0-9]*.jar,\
	lib/commons-digester.jar=commons-digester-[0-9]*.jar,\
	lib/commons-validator.jar=commons-validator-[0-9]*.jar,\
	lib/commons-io.jar=commons-io-[0-9]*.jar,\
	lib/commons-lang3.jar=commons-lang[0-9]*.jar

Web-ContextPath: /${dashcaseProjectName}-web

-metatype: *
-dsannotations-options: inherit