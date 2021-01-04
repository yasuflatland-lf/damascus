<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/settings.gradle">
include "${dashcaseProjectName}-api", "${dashcaseProjectName}-service"<#if anyGeneratedWeb>, "${dashcaseProjectName}-web"</#if>
