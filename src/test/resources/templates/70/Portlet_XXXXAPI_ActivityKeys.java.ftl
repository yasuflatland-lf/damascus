<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-api/src/main/java/${packagePath}/social/${capFirstModel}ActivityKeys.java">
<#assign skipTemplate = !generateActivity>

package ${application.packageName}.social;

/**
* @author Yasuyuki Takeo
* @author ${damascus_author}
*/
public class ${capFirstModel}ActivityKeys {

public static final int ADD_${uppercaseModel} = 1;

public static final int UPDATE_${uppercaseModel} = 2;

}