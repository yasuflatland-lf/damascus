<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/resources/resource-actions/default.xml">
<#assign skipTemplate = !generateWeb>
<?xml version="1.0"?>
<!DOCTYPE resource-action-mapping PUBLIC "-//Liferay//DTD Resource Action Mapping 7.0.0//EN" "http://www.liferay.com/dtd/liferay-resource-action-mapping_7_0_0.dtd">

<resource-action-mapping>
	<#list damascus.applications as app >
    <portlet-resource>
        <portlet-name>${packageSnake}_web_portlet_${app.model?cap_first}WebPortlet</portlet-name>
        <permissions>
            <supports>
                <action-key>ACCESS_IN_CONTROL_PANEL</action-key>
                <action-key>ADD_TO_PAGE</action-key>
                <action-key>CONFIGURATION</action-key>
                <action-key>VIEW</action-key>
            </supports>
            <site-member-defaults>
                <action-key>VIEW</action-key>
            </site-member-defaults>
            <guest-defaults>
                <action-key>VIEW</action-key>
            </guest-defaults>
            <guest-unsupported>
                <action-key>ACCESS_IN_CONTROL_PANEL</action-key>
                <action-key>CONFIGURATION</action-key>
            </guest-unsupported>
        </permissions>
    </portlet-resource>
    </#list>	
</resource-action-mapping>