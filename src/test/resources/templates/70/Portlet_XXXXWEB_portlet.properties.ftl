<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/resources/portlet.properties">

include-and-override=portlet-ext.properties

language.bundle=content.Language

#
# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
resource.actions.configs=resource-actions/default.xml