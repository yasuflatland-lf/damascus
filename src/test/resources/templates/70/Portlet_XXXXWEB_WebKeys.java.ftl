<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/constants/${capFirstModel}WebKeys.java">

package ${application.packageName}.web.constants;

/**
* @author Yasuyuki Takeo
* @author ${damascus_author}
*/
public class ${capFirstModel}WebKeys {
    public static final String VIEW_JSP = "/view.jsp";
    public static final String VIEW_RECORD_JSP = "/view_record.jsp";
    public static final String EDIT_JSP = "/edit.jsp";

    public static final String ${uppercaseModel}_ITEM_SELECTOR_HELPER =
        "${uppercaseModel}_ITEM_SELECTOR_HELPER";

    public static final String ${uppercaseModel}_VIEW_HELPER =
        "${uppercaseModel}_VIEW_HELPER";
}
