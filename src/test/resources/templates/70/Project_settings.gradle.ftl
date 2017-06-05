<#assign createPath = "${createPath_val}/settings.gradle">
<#assign count = 1>
include <#list damascus.applications as application><#if count!=1>, </#if>"${application.model}-api", "${application.model}-service", "${application.model}-web"<#assign count = count + 1></#list>