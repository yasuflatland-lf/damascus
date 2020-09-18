// <dmsc:root templateName="Portlet_XXXXAPI_PortletKeys.java.ftl"  />
/* <dmsc:sync id="head-common" > */
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/src/main/java/${packagePath}/constants/${capFirstModel}PortletKeys.java">
/* </dmsc:sync> */

package ${packageName}.constants;

/**
 * @author ${damascus_author}
 */
public class ${capFirstModel}PortletKeys {

	public static final String ${uppercaseModel} =
		"${packageSnake}_web_${capFirstModel}Portlet";

	public static final String ${uppercaseModel}_ADMIN =
		"${packageSnake}_web_${capFirstModel}AdminPortlet";

	public static final String ${uppercaseModel}_CONFIG =
		"${packageName}.web.portlet.action.${capFirstModel}Configuration";

}