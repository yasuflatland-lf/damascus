<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/content/Language_it.properties">

model.resource.${packageName}=${damascus.projectName}

<#list damascus.applications as application>
javax.portlet.short-title.${application.model?lower_case}web=${camelcaseProjectName}Web
javax.portlet.title.${application.model?lower_case}web=${camelcaseProjectName}Web
model.resource.${packageName}.model.${application.model?cap_first}=${application.model?cap_first}
    <#list application.fields as field >
${application.model?lower_case}-${field.name?lower_case}=${field.title}
${field.name?lower_case}=${field.title}
        <#if field.required?? && field.required == true>
${application.model?lower_case}-${field.name?lower_case}-required=Il campo ${field.title} deve essere compilato!
        </#if>
    </#list>
add-${application.model?lower_case}=Aggiungi ${application.model?lower_case}
${application.model?lower_case}-added-successfully=I dati sono stati aggiunti.
${application.model?lower_case}-updated-successfully=I dati sono stati modificati.
${application.model?lower_case}-deleted-successfully=I dati sono stati eliminati.
</#list>
there-was-an-unexpected-error.-please-refresh-the-current-page=Errore. Si prega di aggiornare la pagina.
permissions=Permessi
view=Visualizza
edit=Modifica
remove=Elimina
trash=Sposta nel cestino
