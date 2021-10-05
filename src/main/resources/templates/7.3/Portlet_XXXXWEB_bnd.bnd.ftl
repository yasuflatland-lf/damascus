# <dmsc:root templateName="Portlet_XXXXWEB_bnd.bnd.ftl"  />
# <dmsc:sync id="head-common" >  #
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/bnd.bnd">
<#assign skipTemplate = !generateWeb>
# </dmsc:sync> #
Bundle-Name: ${dashcaseProjectName}-web
Bundle-SymbolicName: ${packageName}.web
Bundle-Version: 1.0.0
Import-Package:\
	!com.google.*,\
	!com.graphbuilder.*,\
	!com.microsoft.*,\
	!org.apache.*,\
	!org.bouncycastle.*,\
	!org.etsi.uri.*,\
	!org.openxmlformats.*,\
	!com.zaxxer.*,\
	*
Web-ContextPath: /${dashcaseProjectName}-web
-dsannotations-options: inherit
-includeresource:\
	@commons-math3-*.jar,
	@poi-*.jar,\
	@poi-ooxml-*.jar,\
	@poi-ooxml-schemas-*.jar
-metatype: *