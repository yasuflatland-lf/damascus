<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${dashcaseProjectName}/settings.gradle">
include "${dashcaseProjectName}-api", "${dashcaseProjectName}-service"<#if anyGeneratedWeb>, "${dashcaseProjectName}-web"</#if>
