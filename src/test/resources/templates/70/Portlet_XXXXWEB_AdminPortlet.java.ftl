<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/${capFirstModel}AdminPortlet.java">
package ${packageName}.web.portlet;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import javax.portlet.Portlet;

import org.osgi.service.component.annotations.Component;

/**
 * ${capFirstModel} Admin Portlet
 *
 * TODO: This portlet merely delegate all requests and actions to
 * ${capFirstModel}WebPortlet for an edit link of Asset Publisher portlet. You'll have a
 * link in a product menu (the menus in the left side pane on Liferay) but it's
 * same one you have in a ${capFirstModel}WebPortlet. If you need to implement a decent
 * Admin Portlet, please refer jsp files under the following folder.
 * liferay-portal/modules/apps/collaboration/blogs/blogs-web/src/main/resources/
 * META-INF/resources/blogs_admin/
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    immediate = true,
    property = {
        "com.liferay.portlet.preferences-unique-per-layout=true",
        "com.liferay.portlet.preferences-owned-by-group=true",
        "com.liferay.portlet.css-class-wrapper=portlet-${lowercaseModel}-admin",
        "com.liferay.portlet.display-category=category.hidden",
        // TODO : If com.liferay.portlet.instanceable is true, Edit for Asset Publisher doesn't work.
        "com.liferay.portlet.instanceable=false",
        "com.liferay.portlet.render-weight=50",
        "com.liferay.portlet.scopeable=true",
        "com.liferay.portlet.struts-path=${lowercaseModel}-admin",
        "com.liferay.portlet.use-default-template=true",
        "javax.portlet.display-name=${capFirstModel}-Admin Portlet",
        "javax.portlet.init-param.mvc-action-command-package-prefix=${packageName}.web.portlet.action" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
        "javax.portlet.init-param.always-display-default-configuration-icons=true",
        "javax.portlet.expiration-cache=0",
        "javax.portlet.init-param.template-path=/",
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}_ADMIN,
        "javax.portlet.resource-bundle=content.Language",
        "javax.portlet.security-role-ref=administrator",
        "javax.portlet.supports.mime-type=text/html"
    },
    service = Portlet.class
)
public class ${capFirstModel}AdminPortlet extends MVCPortlet {

}
