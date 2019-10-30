// <dmsc:root templateName="Portlet_XXXXWEB_WebKeys.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/constants/${capFirstModel}WebKeys.java">
// </dmsc:sync> //
package ${packageName}.web.constants;

/**
 * ${capFirstModel} Web Keys
 * 
 * @author ${damascus_author}
 */
public class ${capFirstModel}WebKeys {

	public static final String ADMIN_EDIT_JSP = "/${snakecaseModel}_admin/edit.jsp";

	public static final String ADMIN_VIEW_JSP = "/${snakecaseModel}_admin/view.jsp";

	public static final String ADMIN_VIEW_RECORD_JSP =
		"/${snakecaseModel}_admin/view_record.jsp";

	public static final String EDIT_JSP = "/${snakecaseModel}/edit.jsp";

	public static final String ${uppercaseModel}_DISPLAY_CONTEXT =
		"${uppercaseModel}_DISPLAY_CONTEXT";

	public static final String ${uppercaseModel}_ITEM_SELECTOR_HELPER =
		"${uppercaseModel}_ITEM_SELECTOR_HELPER";

	public static final String ${uppercaseModel}_VIEW_HELPER = "${uppercaseModel}_VIEW_HELPER";

	public static final String VIEW_JSP = "/${snakecaseModel}/view.jsp";

	public static final String VIEW_RECORD_JSP = "/${snakecaseModel}/view_record.jsp";

}