<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/content/Language.properties">

model.resource.${packageName}=${damascus.projectName}

<#list damascus.applications as application>
javax.portlet.short-title.${application.model?lower_case}web=${camelcaseProjectName}Web
javax.portlet.title.${application.model?lower_case}web=${camelcaseProjectName}Web
model.resource.${packageName}.model.${application.model?cap_first}=${application.model?cap_first}
    <#list application.fields as field >
${application.model?lower_case}-${field.name?lower_case}=${field.title}
${field.name?lower_case}=${field.title}
        <#if field.required?? && field.required == true>
${application.model?lower_case}-${field.name?lower_case}-required=The field ${field.title} must be filled!
        </#if>
    </#list>
add-${application.model?lower_case}=Add ${application.model?lower_case}
${application.model?lower_case}-added-successfully=The data has been added.
${application.model?lower_case}-updated-successfully=The data has been updated.
${application.model?lower_case}-deleted-successfully=The data has been deleted.
</#list>
there-was-an-unexpected-error.-please-refresh-the-current-page=Unexpected error. Please refresh.
permissions=Permissions
view=View
edit=Update
remove=Delete
trash=Move to trash