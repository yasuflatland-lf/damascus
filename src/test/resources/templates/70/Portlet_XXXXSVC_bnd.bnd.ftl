<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-service/bnd.bnd">
Bundle-Name: ${capFirstModel}-service
Bundle-SymbolicName: ${application.packageName}.service
Bundle-Version: 1.0.0
Export-Package:\
${application.packageName}.service.permission,\
${application.packageName}.service.util
Liferay-Require-SchemaVersion: 1.0.0
Liferay-Service: true

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