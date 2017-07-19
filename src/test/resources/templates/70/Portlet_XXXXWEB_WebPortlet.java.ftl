<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/${capFirstModel}WebPortlet.java">

package ${packageName}.web.portlet;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.web.portlet.action.${capFirstModel}Configuration;

import java.io.IOException;
import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;

import aQute.bnd.annotation.metatype.Configurable;

/**
 * ${capFirstModel} Portlet
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    configurationPid =${capFirstModel}PortletKeys.${uppercaseModel}_CONFIG,
    immediate = true,
    property = {
        "com.liferay.portlet.preferences-unique-per-layout=true",
        "com.liferay.portlet.preferences-owned-by-group=true",
        "com.liferay.portlet.css-class-wrapper=portlet-${lowercaseModel}",
        "com.liferay.portlet.display-category=category.sample",
        "com.liferay.portlet.instanceable=true",
        "com.liferay.portlet.render-weight=50",
        "com.liferay.portlet.scopeable=true",
        "com.liferay.portlet.struts-path=${lowercaseModel}",
        "com.liferay.portlet.use-default-template=true",
        "javax.portlet.display-name=${capFirstModel}-web Portlet",
        "javax.portlet.init-param.mvc-action-command-package-prefix=${packageName}.web.portlet.action" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "javax.portlet.init-param.always-display-default-configuration-icons=true",
        "javax.portlet.expiration-cache=0",
        "javax.portlet.init-param.template-path=/",
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel},
        "javax.portlet.resource-bundle=content.Language",
        "javax.portlet.security-role-ref=power-user,user",
        "javax.portlet.supports.mime-type=text/html"
    },
    service = Portlet.class
)
public class ${capFirstModel}WebPortlet extends MVCPortlet {
    @Override
    public void doView(RenderRequest renderRequest, RenderResponse renderResponse)
        throws IOException, PortletException {

        renderRequest.setAttribute(${capFirstModel}Configuration.class.getName(), _${uncapFirstModel}Configuration);

        super.doView(renderRequest, renderResponse);
    }

    @Activate
    @Modified
    protected void activate(Map<Object, Object> properties) {
        _${uncapFirstModel}Configuration = Configurable.createConfigurable(${capFirstModel}Configuration.class, properties);
    }

    private volatile ${capFirstModel}Configuration _${uncapFirstModel}Configuration;
}