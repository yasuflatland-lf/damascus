<#assign capFirstModel = "${application.model?cap_first}">
<#assign uncapFirstModel = "${application.model?uncap_first}">
<#assign lowercaseModel = "${application.model?lower_case}">
<#assign uppercaseModel = "${application.model?upper_case}">
<#assign snakecaseModel = "${caseUtil.camelCaseToSnakeCase(application.model)}">
<#assign packagePath = "${application.packageName?replace(\".\", \"/\")}">
<#assign packageSnake = "${application.packageName?replace(\".\", \"_\")}">

<#assign categories = application.asset?exists && application.asset.categories>
<#assign discussion = application.asset?exists && application.asset.discussion>
<#assign ratings = application.asset?exists && application.asset.ratings>
<#assign tags = application.asset?exists && application.asset.tags>
<#assign relatedAssets = application.asset?exists && application.asset.relatedAssets>
<#assign generateActivity = application.asset?exists && application.asset.generateActivity>

<#assign entityWebResourcesPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/resources/META-INF/resources/${snakecaseModel}">

<#assign primaryKeyParam = "">
<#list application.fields as field >
    <#if field.primary?? && field.primary == true >
        <#assign primaryKeyParam = "${field.name}">
    </#if>
</#list>