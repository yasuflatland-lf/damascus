// <dmsc:root templateName="Portlet_XXXXAPI_Constants.java.ftl"  />
/* <dmsc:sync id="head-common" > */
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${apiModulePath}/src/main/java/${packagePath}/constants/${capFirstModel}Constants.java">
/* </dmsc:sync> */
package ${packageName}.constants;

/**
 * @author ${damascus_author}
 */
public class ${capFirstModel}Constants {

	// This name is defined in default.xml, model-name

	public static final String RESOURCE_NAME = "${packageName}";

	// This name is defined in service.xml, package-path

	public static final String SERVICE_NAME = "${packageName}";

}