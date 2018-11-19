<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/portlet.properties">
<#assign skipTemplate = !generateWeb>
include-and-override=portlet-ext.properties

language.bundle=content.Language

#
# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
resource.actions.configs=resource-actions/default.xml