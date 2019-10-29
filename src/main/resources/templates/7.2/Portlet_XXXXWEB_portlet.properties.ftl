# <dmsc:root templateName="Portlet_XXXXWEB_portlet.properties.ftl"  />
# <dmsc:sync id="head-common" > #
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/portlet.properties">
# </dmsc:sync> #
include-and-override=portlet-ext.properties

language.bundle=content.Language

#
# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
resource.actions.configs=resource-actions/default.xml