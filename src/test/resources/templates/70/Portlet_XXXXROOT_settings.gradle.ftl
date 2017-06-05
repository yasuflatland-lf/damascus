<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/settings.gradle">
include "${application.model}-api", "${application.model}-service", "${application.model}-web"