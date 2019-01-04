<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${serviceModulePath}/src/main/java/${packagePath}/service/workflow/${capFirstModel}WorkflowManager.java">
package ${packageName}.service.workflow;

import com.liferay.portal.kernel.dao.orm.QueryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.model.WorkflowInstanceLink;
import com.liferay.portal.kernel.service.WorkflowInstanceLinkLocalServiceUtil;
import com.liferay.portal.kernel.util.HtmlUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowException;
import com.liferay.portal.kernel.workflow.WorkflowInstance;
import com.liferay.portal.kernel.workflow.WorkflowInstanceManagerUtil;
import com.liferay.portal.kernel.workflow.WorkflowTask;
import com.liferay.portal.kernel.workflow.WorkflowTaskManagerUtil;
import ${packageName}.model.${capFirstModel};

import java.util.ArrayList;
import java.util.List;

/**
 * Workflow Utility class
 * <p>
 * TODO: This class has been generated as a model specific for convenience of code generation.
 * Please feel free to refactor this as a common library according to your requirements.
 *
 * @author Yasuyuki Takeo
 * @author ${damascus_author}
 */
public class ${capFirstModel}WorkflowManager {

    private final static String _className = ${capFirstModel}.class.getName();

    /**
     * Complete workflow at once
     * <p/>
     * Without assigning a task to a user, this method automatically assign user and update the workflow.
     *
     * @param user
     * @param scorpGroupId
     * @param classPK
     * @param transitionName
     * @return WorkflowTask object
     * @throws PortalException
     */
    static public WorkflowTask completeWorkflowTaskAtOnce(
        User user, long scorpGroupId, long classPK, String transitionName)
        throws PortalException {

        return completeWorkflowTaskAtOnce(
                    user,scorpGroupId, _className, classPK, transitionName);
    }

    /**
     * Complete workflow at once
     * <p/>
     * Without assigning a task to a user, this method automatically assign user and update the workflow.
     *
     * @param user
     * @param scorpGroupId
     * @param className
     * @param classPK
     * @param transitionName
     * @return WorkflowTask object
     * @throws PortalException
     */
    static public WorkflowTask completeWorkflowTaskAtOnce(
        User user, long scorpGroupId, String className, long classPK, String transitionName)
        throws PortalException {

        if (Validator.isNull(className)) {
            className = _className;
        }

        // Get workflow instance
        WorkflowTask workflowTask = getWorkflowTask(user, scorpGroupId, className, classPK);
        
        if (Validator.isNull(workflowTask)) {
            return null;
        }

        // Assign a task to the user
		WorkflowTaskManagerUtil.assignWorkflowTaskToUser(
				user.getCompanyId(), user.getUserId(),
				workflowTask.getWorkflowTaskId(), user.getUserId(), "", null, null);        

        // Complete workflow
		WorkflowTask completeWorkflowTask = WorkflowTaskManagerUtil.completeWorkflowTask(
				user.getCompanyId(), user.getUserId(),
				workflowTask.getWorkflowTaskId(), transitionName, "", null);		

        return completeWorkflowTask;
    }

    /**
     * Check if workflow is enabled.
     * 
     * @param user
     * @param scorpGroupId
     * @param classPK
     * @return true if workflow is enabled or false
     * @throws PortalException
     */
    static public boolean isWorkflowEnable(User user, long scorpGroupId, long classPK) 
    		throws PortalException {
    	List<String> transitionNames = getTransitionNames(user, scorpGroupId, null, classPK);
    	return (transitionNames.size() == 0) ? false : true;
    }
    
    /**
     * Get Transition names
     * <p/>
     * A task includes transitions. This method retrieve a list of transition names
     *
     * @param user
     * @param scorpGroupId
     * @param classPK
     * @return Escaped transition names
     * @throws PortalException
     */
    static public List<String> getTransitionNames(User user, long scorpGroupId, long classPK)
        throws PortalException {
        return getTransitionNames(user, scorpGroupId, null, classPK);
    }

    /**
     * Get Transition names
     * <p/>
     * A task includes transitions. This method retrieve a list of transition names
     *
     * @param user
     * @param scorpGroupId
     * @param className
     * @param classPK
     * @return Transition name string List
     * @throws PortalException
     */
    static public List<String> getTransitionNames(User user, long scorpGroupId, String className, long classPK)
        throws PortalException {

        WorkflowTask workflowTask = getWorkflowTask(user, scorpGroupId, className, classPK);

        if (Validator.isNull(workflowTask)) {
            return new ArrayList<String>();
        }

        List<String> transitionNames =
            WorkflowTaskManagerUtil.getNextTransitionNames(
                user.getCompanyId(),
                user.getUserId(),
                workflowTask.getWorkflowTaskId());

        List<String> convertedNames = new ArrayList<String>();

        for (String transitionName : transitionNames) {
            if (_log.isDebugEnabled()) {
                _log.debug("Transition name : <" + transitionName + ">");
            }

            convertedNames.add(getTransitionName(transitionName));
        }

        return convertedNames;
    }

    /**
     * Get Transition Message
     *
     * @param transitionName
     * @return Escaped Transition name
     */
    static public String getTransitionName(String transitionName) {
        if (Validator.isNull(transitionName)) {
            return "proceed";
        }

        return HtmlUtil.escape(transitionName);
    }

    /**
     * Get WorkFlow
     *
     * @param user
     * @param scorpGroupId
     * @param className
     * @param classPK
     * @return WorkflowTask object
     * @throws WorkflowException
     */
    static public WorkflowTask getWorkflowTask(User user, long scorpGroupId, String className, long classPK)
        throws WorkflowException {
        WorkflowInstance workflowInstance = getWorkflowInstance(user, scorpGroupId, className, classPK);
        List<WorkflowTask> workflowTasks = getWorkflowTasks(user, className);

        return workflowTasks.stream()
            .filter(wft ->
                wft.getWorkflowInstanceId() == workflowInstance.getWorkflowInstanceId()
            ).findFirst().orElse(null);
    }

    /**
     * Get Workflow Instance
     *
     * @param user
     * @param scorpGroupId
     * @param className
     * @param classPK
     * @return Workflow task instances if those exist
     * @throws WorkflowException
     */
    static public WorkflowInstance getWorkflowInstance(User user, long scorpGroupId, String className, long classPK)
        throws WorkflowException {

        if (Validator.isNull(classPK)) {
            _log.debug("classPK is null");
            return null;
        }

        if (Validator.isNull(className)) {
            className = _className;
        }

        WorkflowInstanceLink workflowInstanceLink =
            WorkflowInstanceLinkLocalServiceUtil.fetchWorkflowInstanceLink(
                user.getCompanyId(), scorpGroupId, _className, classPK);

        if (Validator.isNull(workflowInstanceLink)) {
            _log.debug("WorkflowInstanceLink is null");
            return null;
        }

        WorkflowInstance workflowInstance = WorkflowInstanceManagerUtil.getWorkflowInstance(
            user.getCompanyId(),
            workflowInstanceLink.getWorkflowInstanceId());

        if (_log.isDebugEnabled()) {
            _log.debug(workflowInstance.toString());
        }

        return workflowInstance;
    }


    /**
     * Get WorkflowTasks
     * <p>
     * Get unasigned tasks available for the current user.
     *
     * @param user
     * @param className
     * @return WorkflowTasks of corresponding class
     * @throws WorkflowException
     */
    static public List<WorkflowTask> getWorkflowTasks(User user, String className) throws WorkflowException {

        if (Validator.isNull(className)) {
            className = _className;
        }

        List<WorkflowTask> workflowTasks = new ArrayList<>();

        // Fetch workflow tasks has asinged to the user
        List<WorkflowTask> workflowTasksToMyRoles
            = getWorkflowTasks(user, className, true);

        workflowTasks.addAll(workflowTasksToMyRoles);

        // Fetch workflow tasks has asigned to my roles, but not asigned to the user yet.
        List<WorkflowTask> workflowTasksToMe
            = getWorkflowTasks(user, className, false);

        workflowTasks.addAll(workflowTasksToMe);

        return workflowTasks;
    }

    /**
     * Get WorkflowTasks
     * <p>
     * Get unasigned tasks available for the current user.
     *
     * @param user
     * @param className
     * @param searchByUserRoles
     * @return WorkflowTasks of corresponding class
     * @throws WorkflowException
     */
    static public List<WorkflowTask> getWorkflowTasks(User user, String className, boolean searchByUserRoles)
        throws WorkflowException {

        if (Validator.isNull(className)) {
            className = _className;
        }

        return WorkflowTaskManagerUtil.search(
            user.getCompanyId(),  // companyId
            user.getUserId(),    // userId
            "",            // keywords
            new String[]{className}, // assetTypes
            false,            // completed
            searchByUserRoles,      // searchByUserRoles
            QueryUtil.ALL_POS,  // start
            QueryUtil.ALL_POS,  // end
            null);        //OrderByComparator<WorkflowTask> orderByComparator)
    }

    /**
     * Is Workflow Exist
     *
     * @param user
     * @param scorpGroupId
     * @param className
     * @param classPK
     * @return true if a workflow exists or false
     */
    static public boolean isWorkflowExist(User user, long scorpGroupId, String className, long classPK) {

        if (Validator.isNull(className)) {
            className = _className;
        }

        return WorkflowInstanceLinkLocalServiceUtil.hasWorkflowInstanceLink(
            user.getCompanyId(), scorpGroupId, _className, classPK);
    }

    private static Log _log = LogFactoryUtil
        .getLog(${capFirstModel}WorkflowManager.class);
}
