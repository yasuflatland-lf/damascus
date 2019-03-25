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
	lib/poi.jar,\
	lib/poi-ooxml.jar,\
	lib/poi-ooxml-schemas.jar,\
	lib/xmlbeans.jar,\
	lib/commons-collections4.jar,\
	lib/commons-compress.jar,\
	lib/commons-digester.jar,\
	lib/commons-validator.jar,\
	lib/commons-io.jar,\
	lib/commons-lang3.jar
Import-Package:\
	!com.graphbuilder.*,\
	!org.apache.commons.math3.*,\
	!org.apache.jcp.xml.dsig.internal.dom,\
	!org.bouncycastle.*,\
	!com.microsoft.schemas.*,\
	!org.etsi.uri.*,\
	!org.openxmlformats.schemas.*,\
	!org.w3.*,\
	!com.sun.*,\
	!com.github.luben.*,\
	!org.brotli.*,\
	!org.tukaani.*,\
	*
	
-includeresource:\
	lib/guava.jar=guava-[0-9]*.jar,\
	lib/error_prone_annotations.jar=error_prone_annotations-[0-9]*.jar,\
	lib/poi.jar=poi-[0-9]*.jar,\
	lib/poi-ooxml.jar=poi-ooxml-[0-9]*.jar,\
	lib/poi-ooxml-schemas.jar=poi-ooxml-schemas-[0-9]*.jar,\
	lib/xmlbeans.jar=xmlbeans-[0-9]*.jar,\
	lib/commons-collections4.jar=commons-collections4-[0-9]*.jar,\
	lib/commons-compress.jar=commons-compress-[0-9]*.jar,\
	lib/commons-digester.jar=commons-digester-[0-9]*.jar,\
	lib/commons-validator.jar=commons-validator-[0-9]*.jar,\
	lib/commons-io.jar=commons-io-[0-9]*.jar,\
	lib/commons-lang3.jar=commons-lang[0-9]*.jar

Web-ContextPath: /${dashcaseProjectName}-web

-metatype: *
-dsannotations-options: inherit