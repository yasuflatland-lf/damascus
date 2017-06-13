<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/java/${packagePath}/web/asset/${capFirstModel}AssetRendererFactory.java">

package ${application.packageName}.web.asset;

import com.liferay.asset.kernel.model.AssetRenderer;
import com.liferay.asset.kernel.model.AssetRendererFactory;
import com.liferay.asset.kernel.model.BaseAssetRendererFactory;
import com.liferay.portal.kernel.exception.PortalException;
import ${application.packageName}.constants.${capFirstModel}PortletKeys;
import ${application.packageName}.model.${capFirstModel};
import ${application.packageName}.service.${capFirstModel}LocalService;

import javax.servlet.ServletContext;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Asset Renderer Factory
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    immediate = true,
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}
    },
    service = AssetRendererFactory.class
)
public class ${capFirstModel}AssetRendererFactory extends BaseAssetRendererFactory<${capFirstModel}> {

    public static final String TYPE = "${uncapFirstModel}";

    public ${capFirstModel}AssetRendererFactory() {
        setClassName(${capFirstModel}.class.getName());
        setLinkable(true);
        setPortletId(${capFirstModel}PortletKeys.${uppercaseModel});
        setSearchable(true);
    }

    @Override
    public AssetRenderer<${capFirstModel}> getAssetRenderer(long classPK, int type) throws PortalException {
        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(classPK);

        ${capFirstModel}AssetRenderer ${uncapFirstModel}AssetRenderer =
            new ${capFirstModel}AssetRenderer(entry);

        ${uncapFirstModel}AssetRenderer.setAssetRendererType(type);
        ${uncapFirstModel}AssetRenderer.setServletContext(_servletContext);

        return ${uncapFirstModel}AssetRenderer;
    }

    @Override
    public String getClassName() {
        return ${capFirstModel}.class.getName();
    }

    @Override
    public String getIconCssClass() {
        return TYPE;
    }

    @Override
    public String getType() {
        return TYPE;
    }

    @Reference(
        target = "(osgi.web.symbolicname=${application.packageName}.web)", unbind = "-"
    )
    public void setServletContext(ServletContext servletContext) {
        _servletContext = servletContext;
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(${capFirstModel}LocalService ${uncapFirstModel}LocalService) {
        _${uncapFirstModel}LocalService = ${uncapFirstModel}LocalService;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
    private ServletContext _servletContext;
}
