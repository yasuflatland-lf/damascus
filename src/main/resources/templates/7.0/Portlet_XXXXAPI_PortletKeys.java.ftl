<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/src/main/java/${packagePath}/constants/${capFirstModel}PortletKeys.java">

package ${packageName}.constants;

/**
* @author Yasuyuki Takeo
* @author ${damascus_author}
*/
public class ${capFirstModel}PortletKeys {
public static final String ${uppercaseModel} = "${packageSnake}_web_portlet_${capFirstModel}WebPortlet";

public static final String ${uppercaseModel}_ADMIN = "${packageSnake}_web_portlet_${capFirstModel}AdminPortlet";

public static final String ${uppercaseModel}_CONFIG = "${packageName}.web.portlet.action.${capFirstModel}Configuration";

public static final String ${uppercaseModel}_FIND_ENTRY = "/${lowercaseModel}/find_entry";
}
