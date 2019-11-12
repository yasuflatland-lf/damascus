# <dmsc:root templateName="Portlet_XXXXSVC_portlet.properties.ftl"  />
# <dmsc:sync id="head-common" >  #
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/resources/portlet.properties">
# </dmsc:sync> #

include-and-override=portlet-ext.properties

# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
resource.actions.configs=META-INF/resource-actions/default.xml