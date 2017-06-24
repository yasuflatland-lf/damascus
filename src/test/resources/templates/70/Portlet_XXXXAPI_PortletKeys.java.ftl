<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-api/src/main/java/${packagePath}/constants/${capFirstModel}PortletKeys.java">

package ${application.packageName}.constants;

/**
* @author Yasuyuki Takeo
* @author ${damascus_author}
*/
public class ${capFirstModel}PortletKeys {
public static final String ${uppercaseModel} = "${packageSnake}_web_portlet_${capFirstModel}WebPortlet";

public static final String ${uppercaseModel}_CONFIG = "${application.packageName}.web.portlet.action.${capFirstModel}Configuration";

public static final String ${uppercaseModel}_FIND_ENTRY = "/${lowercaseModel}/find_entry";
}
