<#assign capFirstModel = "${application.model?cap_first}">
<#assign uncapFirstModel = "${application.model?uncap_first}">
<#assign lowercaseModel = "${application.model?lower_case}">
<#assign uppercaseModel = "${application.model?upper_case}">
<#assign packagePath = "${application.packageName?replace(\".\", \"/\")}">
<#assign packageSnake = "${application.packageName?replace(\".\", \"_\")}">

<#assign primaryKeyParam = "">
<#list application.fields as field >
    <#if field.primaly?? && field.primaly == true >
        <#assign primaryKeyParam = "${field.name}">
    </#if>
</#list>