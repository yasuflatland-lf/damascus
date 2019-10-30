# <dmsc:root templateName="Portlet_XXXXWEB_bnd.bnd.ftl"  />
# <dmsc:sync id="head-common" >  #
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/bnd.bnd">
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
	*
Web-ContextPath: /${dashcaseProjectName}-web
-dsannotations-options: inherit
-includeresource:\
	@poi-*.jar,\
	@poi-ooxml-*.jar,\
	@poi-ooxml-schemas-*.jar
-metatype: *