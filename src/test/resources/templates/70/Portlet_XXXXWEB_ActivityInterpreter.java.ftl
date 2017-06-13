<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/social/${capFirstModel}ActivityInterpreter.java">

package ${application.packageName}.web.social;

import com.liferay.portal.kernel.util.AggregateResourceBundleLoader;
import com.liferay.portal.kernel.util.ResourceBundleLoader;
import com.liferay.portal.kernel.util.ResourceBundleLoaderUtil;
import com.liferay.social.kernel.model.BaseSocialActivityInterpreter;
import com.liferay.social.kernel.model.SocialActivityInterpreter;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.model.${capFirstModel};

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Activity Interpreter
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    property = {"javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}},
    service = SocialActivityInterpreter.class
)
public class ${capFirstModel}ActivityInterpreter extends BaseSocialActivityInterpreter {

    @Override
    public String[] getClassNames() {
        return _CLASS_NAMES;
    }

    @Override
    protected ResourceBundleLoader getResourceBundleLoader() {
        return _resourceBundleLoader;
    }

    @Reference(
        target = "(bundle.symbolic.name=${application.packageName}.web)", unbind = "-"
    )
    protected void setResourceBundleLoader(
        ResourceBundleLoader resourceBundleLoader) {

        _resourceBundleLoader = new AggregateResourceBundleLoader(
            resourceBundleLoader,
            ResourceBundleLoaderUtil.getPortalResourceBundleLoader());
    }

    private ResourceBundleLoader _resourceBundleLoader;
    private static final String[] _CLASS_NAMES = {${capFirstModel}.class.getName()};

}
