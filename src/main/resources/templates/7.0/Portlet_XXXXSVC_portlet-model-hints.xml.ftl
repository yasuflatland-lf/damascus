<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/resources/META-INF/portlet-model-hints.xml">
<?xml version="1.0"?>

<model-hints>
<#list damascus.applications as application>
    <model name="${packageName}.model.${application.model}">
        <field name="uuid" type="String" />

        <#-- ---------------- -->
        <#-- field loop start -->
        <#-- ---------------- -->
        <#list application.fields as field >
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Long" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}" />
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Varchar" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}" >
            <hint name="max-length">${field.length}</hint>
        </field>
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Date" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}">
            <hint name="show-time">false</hint>
            <hint name="year-range-delta">80</hint>
        </field>
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.DateTime" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}">
            <hint name="show-time">true</hint>
            <hint name="year-range-delta">80</hint>
        </field>
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Boolean" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}" />
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.DocumentLibrary" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}">
            <hint name="display-width">60</hint>
            <hint name="max-length">512</hint>
        </field>
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Double" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}" />
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Integer" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}" />
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.RichText" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}">
            <hint-collection name="TEXTAREA" />
            <hint name="max-length">4001</hint>
        </field>
            </#if>
            <#if field.type?string == "com.liferay.damascus.cli.json.fields.Text" >
        <field name="${field.name}" type="${templateUtil?api.getTypeParameter(field.type?string)}">
            <hint-collection name="TEXTAREA" />
            <hint name="max-length">4001</hint>
        </field>
            </#if>
        </#list>
        <#-- ---------------- -->
        <#-- field loop ends  -->
        <#-- ---------------- -->

        <#-- ---------------- -->
        <#--      Assets      -->
        <#-- ---------------- -->
        <#if application.asset.assetTitleFieldName?? && application.asset.assetTitleFieldName != "" >
            <field name="${application.asset.assetTitleFieldName}" type="String">
                <hint name="display-width">200</hint>
                <hint name="max-length">255</hint>
            </field>
        </#if>
        <#if application.asset.assetSummaryFieldName?? && application.asset.assetSummaryFieldName != "" >
            <field name="${application.asset.assetSummaryFieldName}" type="String">
                <hint-collection name="TEXTAREA" />
                <hint name="max-length">4001</hint>
            </field>
        </#if>

        <field name="groupId" type="long" />
        <field name="companyId" type="long" />
        <field name="userId" type="long" />
        <field name="userName" type="String" />
        <field name="createDate" type="Date" />
        <field name="modifiedDate" type="Date" />
        <field name="urlTitle" type="String" />
        <field name="status" type="int" />
        <field name="statusByUserId" type="long" />
        <field name="statusByUserName" type="String" />
        <field name="statusDate" type="Date" />
    </model>
</#list>
</model-hints>