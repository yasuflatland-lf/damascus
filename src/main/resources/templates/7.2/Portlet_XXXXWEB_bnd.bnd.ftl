# <dmsc:root templateName="Portlet_XXXXWEB_bnd.bnd.ftl"  />
Bundle-Name: ${snakecaseModel}-web
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
Web-ContextPath: /${snakecaseModel}-web
-dsannotations-options: inherit
-includeresource:\
	@poi-*.jar,\
	@poi-ooxml-*.jar,\
	@poi-ooxml-schemas-*.jar
-metatype: *