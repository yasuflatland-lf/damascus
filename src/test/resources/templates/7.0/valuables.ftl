<#assign void><#-- Just to prevent unexpected whitespace or line breaks -->

<#assign packageName = "${damascus.packageName}">
<#assign packagePath = "${packageName?replace(\".\", \"/\")}">
<#assign packageSnake = "${packageName?replace(\".\", \"_\")}">

<#assign camelcaseProjectName = "${damascus.projectName?replace(\"-\", \"\")}">
<#assign dashcaseProjectName = "${caseUtil.camelCaseToDashCase(camelcaseProjectName)}">
<#assign apiModulePath = "${createPath_val}/${dashcaseProjectName}-api">
<#assign serviceModulePath = "${createPath_val}/${dashcaseProjectName}-service">
<#assign webModulePath = "${createPath_val}/${dashcaseProjectName}-web">

<#if application?exists>
<#assign capFirstModel = "${application.model?cap_first}">
<#assign uncapFirstModel = "${application.model?uncap_first}">
<#assign lowercaseModel = "${application.model?lower_case}">
<#assign uppercaseModel = "${application.model?upper_case}">
<#assign snakecaseModel = "${caseUtil.camelCaseToSnakeCase(application.model)}">

<#assign categories = application.asset?exists && application.asset.categories>
<#assign discussion = application.asset?exists && application.asset.discussion>
<#assign ratings = application.asset?exists && application.asset.ratings>
<#assign tags = application.asset?exists && application.asset.tags>
<#assign relatedAssets = application.asset?exists && application.asset.relatedAssets>
<#assign generateActivity = application.asset?exists && application.asset.generateActivity>
<#assign generateWeb = application.web?exists && application.web>
<#assign anyGeneratedWeb = damascus.isWebExist()>

<#assign entityWebResourcesPath = "${webModulePath}/src/main/resources/META-INF/resources/${snakecaseModel}">

<#assign primaryKeyParam = "">
<#list application.fields as field >
    <#if field.primary?? && field.primary == true >
        <#assign primaryKeyParam = "${field.name}">
    </#if>
</#list>
</#if>

</#assign>
