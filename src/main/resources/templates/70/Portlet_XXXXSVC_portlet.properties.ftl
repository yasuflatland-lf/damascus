<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-service/src/main/resources/portlet.properties">
include-and-override=portlet-ext.properties

# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
resource.actions.configs=META-INF/resource-actions/default.xml