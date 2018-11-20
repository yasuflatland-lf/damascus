<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/social/${capFirstModel}ActivityInterpreter.java">
<#assign skipTemplate = !generateActivity || !generateWeb>

package ${packageName}.web.social;

import com.liferay.portal.kernel.security.permission.PermissionChecker;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.util.AggregateResourceBundleLoader;
import com.liferay.portal.kernel.util.FastDateFormatFactoryUtil;
import com.liferay.portal.kernel.util.ResourceBundleLoader;
import com.liferay.portal.kernel.util.ResourceBundleLoaderUtil;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.social.kernel.model.BaseSocialActivityInterpreter;
import com.liferay.social.kernel.model.SocialActivity;
import com.liferay.social.kernel.model.SocialActivityConstants;
import com.liferay.social.kernel.model.SocialActivityInterpreter;
import ${packageName}.constants.${capFirstModel}PortletKeys;
import ${packageName}.model.${capFirstModel};
import ${packageName}.service.${capFirstModel}LocalService;
import ${packageName}.service.permission.${capFirstModel}PermissionChecker;
import ${packageName}.social.${capFirstModel}ActivityKeys;

import java.text.Format;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

/**
 * ${capFirstModel} Activity Interpreter
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
@Component(
    property = {
        "javax.portlet.name=" + ${capFirstModel}PortletKeys.${uppercaseModel}
    },
    service = SocialActivityInterpreter.class
)
public class ${capFirstModel}ActivityInterpreter extends BaseSocialActivityInterpreter {

    @Override
    public String[] getClassNames() {
        return _CLASS_NAMES;
    }

    @Override
    protected String getPath(SocialActivity activity, ServiceContext serviceContext) {

        return ${capFirstModel}PortletKeys.${uppercaseModel}_FIND_ENTRY + "?resourcePrimKey=" + activity.getClassPK();
    }

    @Override
    protected ResourceBundleLoader getResourceBundleLoader() {
        return _resourceBundleLoader;
    }

    @Override
    protected Object[] getTitleArguments(String groupName, SocialActivity activity, String link, String title,
                                         ServiceContext serviceContext) throws Exception {

        String creatorUserName = getUserName(activity.getUserId(), serviceContext);
        String receiverUserName = getUserName(activity.getReceiverUserId(), serviceContext);

        ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(activity.getClassPK());

        String displayDate = StringPool.BLANK;

        if ((activity.getType() == ${capFirstModel}ActivityKeys.ADD_${uppercaseModel})
            && (entry.getStatus() == WorkflowConstants.STATUS_SCHEDULED)) {

            link = null;

            Format dateFormatDate = FastDateFormatFactoryUtil.getSimpleDateFormat("MMMM d", serviceContext.getLocale(),
                                                                                  serviceContext.getTimeZone());

            displayDate = dateFormatDate.format(entry.getModifiedDate());
        }

        return new Object[] { groupName, creatorUserName, receiverUserName, wrapLink(link, title), displayDate };
    }

    @Override
    protected String getTitlePattern(String groupName, SocialActivity activity) throws Exception {

        int activityType = activity.getType();

        if (activityType == ${capFirstModel}ActivityKeys.ADD_${uppercaseModel}) {
            ${capFirstModel} entry = _${uncapFirstModel}LocalService.get${capFirstModel}(activity.getClassPK());

            if (entry.getStatus() == WorkflowConstants.STATUS_SCHEDULED) {
                if (Validator.isNull(groupName)) {
                    return "activity-${lowercaseModel}-schedule-entry";
                } else {
                    return "activity-${lowercaseModel}-schedule-entry-in";
                }
            } else {
                if (Validator.isNull(groupName)) {
                    return "activity-${lowercaseModel}-add-entry";
                } else {
                    return "activity-${lowercaseModel}-add-entry-in";
                }
            }
        } else if (activityType == SocialActivityConstants.TYPE_MOVE_TO_TRASH) {
            if (Validator.isNull(groupName)) {
                return "activity-${lowercaseModel}-move-to-trash";
            } else {
                return "activity-${lowercaseModel}-move-to-trash-in";
            }
        } else if (activityType == SocialActivityConstants.TYPE_RESTORE_FROM_TRASH) {

            if (Validator.isNull(groupName)) {
                return "activity-${lowercaseModel}-restore-from-trash";
            } else {
                return "activity-${lowercaseModel}-restore-from-trash-in";
            }
        } else if (activityType == ${capFirstModel}ActivityKeys.UPDATE_${uppercaseModel}) {
            if (Validator.isNull(groupName)) {
                return "activity-${lowercaseModel}-update-entry";
            } else {
                return "activity-${lowercaseModel}-update-entry-in";
            }
        }

        return null;
    }

    @Override
    protected boolean hasPermissions(
        PermissionChecker permissionChecker, SocialActivity activity,
        String actionId, ServiceContext serviceContext)
        throws Exception {

        return ${capFirstModel}PermissionChecker.contains(
            permissionChecker, activity.getClassPK(), actionId);
    }

    @Reference(
        target = "(bundle.symbolic.name=${packageName}.web)",
        unbind = "-"
    )
    protected void setResourceBundleLoader(ResourceBundleLoader resourceBundleLoader) {

        _resourceBundleLoader = new AggregateResourceBundleLoader(resourceBundleLoader,
                                                                  ResourceBundleLoaderUtil.getPortalResourceBundleLoader());
    }

    @Reference(unbind = "-")
    protected void set${capFirstModel}LocalService(${capFirstModel}LocalService ${lowercaseModel}localservice) {
        _${uncapFirstModel}LocalService = ${lowercaseModel}localservice;
    }

    private ${capFirstModel}LocalService _${uncapFirstModel}LocalService;
    private ResourceBundleLoader _resourceBundleLoader;
    private static final String[] _CLASS_NAMES = { ${capFirstModel}.class.getName() };

}