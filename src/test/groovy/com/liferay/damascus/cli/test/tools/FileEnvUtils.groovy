package com.liferay.damascus.cli.test.tools

import org.apache.commons.io.FileUtils

/**
 * File environment utils
 *
 * @author Yasuyuki Takeo
 */
class FileEnvUtils {
    static def createPropertiesSource(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getPropertiesContents(templateName)
        )
    }

    static def createPropertiesTemplate(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getPropertiesTemplate(templateName)
        )
    }

    static def createJavaSource(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getJavaContents(templateName)
        )
    }

    static def createJavaTemplate(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getJavaTemplate(templateName)
        )
    }

    static def createXmlSource(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getXmlContents(templateName)
        )
    }

    static def createXmlTemplate(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getXmlTemplate(templateName)
        )
    }

    static def createInsertTagTemplate(String rootPath, String fileName, String templateName) {
        sourceEnvCreate(
                rootPath,
                fileName,
                getInsertTagContents(templateName)
        )
    }

    static def sourceEnvCreate(String rootPath, String fileName, String contents) {

        FileUtils.forceMkdir(new File(rootPath));
        final FileTreeBuilder tf = new FileTreeBuilder(new File(rootPath))
        tf.file(fileName) {
            withWriter('UTF-8') { writer ->
                writer.write contents.stripIndent()
            }
        }
    }

    static def getRootTag(String templateName) {
        def retVal = $/
<dmsc:root templateName="${templateName}" pickup="true" />
/$;
        return retVal;
    }

    static def getPropertyComment(String rootTag) {
        def retVal = $/
# ${rootTag}
/$;
        return retVal;
    }

    static def getXmlComment(String rootTag) {
        def retVal = $/
<!-- ${rootTag} -->
/$;
        return retVal;
    }

    static def getSingleSlashComment(String rootTag) {
        def retVal = $/
// ${rootTag}
/$;
        return retVal;
    }

    static def getJavaComment(String rootTag) {
        def retVal = $/
/* ${rootTag} */
/$;
        return retVal;
    }

    static def getXmlTemplate(String templateName) {
        def rootTag = getXmlComment(getRootTag(templateName))
        def retVal = $/
    ${rootTag}
<!-- <dmsc:sync id="foo1"> -->
    <!-- REPLACED BY FOO1 FIRST TAG -->
<!-- </dmsc:sync -->
        <column name="groupId" type="long"/>

        <!-- Audit fields -->
        <column name="companyId" type="long"/>
        <column name="userId" type="long"/>
        <column name="userName" type="String"/>
        <column name="createDate" type="Date"/>
        <column name="modifiedDate" type="Date"/>

<!-- <dmsc:sync id="barfoo"> -->
        <!-- REPLACED BY BARFOO SECOND TAG -->
<!-- </dmsc:sync> -->

/$;
        return retVal;

    }

    static def getXmlContents(String templateName) {
        def rootTag = getXmlComment(getRootTag(templateName))
        def retVal = $/
<?xml version="1.0"?>
<!DOCTYPE service-builder PUBLIC "-//Liferay//DTD Service Builder 7.0.0//EN" "http://www.liferay.com/dtd/liferay-service-builder_7_0_0.dtd">

<service-builder package-path="com.liferay.test">

    <namespace>SampleSB</namespace>

    <!--<entity data-source="sampleDataSource" local-service="true" name="SampleSB" remote-service="false" session-factory="sampleSessionFactory" table="foo" tx-manager="sampleTransactionManager uuid="true"">-->
    <entity name="SampleSB" local-service="true" remote-service="false" uuid="true" trash-enabled="true">
    ${rootTag}
<!-- <dmsc:sync id="foo1"> -->
        <!-- PK field -->
        <column name="samplesbId" type="long" primary="true" />
        <column name="title" type="String"  />
        <column name="samplesbBooleanStat" type="boolean"  />
        <column name="samplesbDateTime" type="Date"  />
        <column name="samplesbDocumentLibrary" type="String"  />
        <column name="samplesbDouble" type="double"  />
        <column name="samplesbInteger" type="int"  />
        <column name="samplesbRichText" type="String"  />
        <column name="samplesbText" type="String"  />
<!-- </dmsc:sync -->
        <!-- Group instance -->
        <column name="groupId" type="long"/>

        <!-- Audit fields -->
        <column name="companyId" type="long"/>
        <column name="userId" type="long"/>
        <column name="userName" type="String"/>
        <column name="createDate" type="Date"/>
        <column name="modifiedDate" type="Date"/>

<!-- <dmsc:sync id="barfoo"> -->
        <!-- Asset related fields-->
        <column name="urlTitle" type="String" />
        <column name="samplesbTitleName" type="String" />
        <column name="samplesbSummaryName" type="String" />

        <!-- Workflow related fields -->
        <column name="status" type="int" />
        <column name="statusByUserId" type="long" />
        <column name="statusByUserName" type="String" />
        <column name="statusDate" type="Date" />
<!-- </dmsc:sync> -->
    </entity>
    <exceptions>
        <exception>NoSuchSampleSB</exception>
        <exception>SampleSBValidateException</exception>
    </exceptions>

</service-builder>
/$;
        return retVal;

    }

    static def getJavaTemplate(String templateName) {
        def rootTag = getJavaComment(getRootTag(templateName))
        def retVal = $/
${rootTag}
package com.liferay.test.service.impl;

public class SampleSBLocalServiceImpl
    extends SampleSBLocalServiceBaseImpl {

/* <dmsc:sync id="bar123foo"> */
    <!-- REPLACED BY BAR123FOO FIRST TAG -->
/* </dmsc:sync> */

    @Override
    public void addEntryResources(
        long entryId, String[] groupPermissions, String[] guestPermissions)
        throws PortalException {
/* <dmsc:sync id="asdf"> */
        <!-- REPLACED BY ASDF SECOND TAG -->
/* </dmsc:sync> */
        addEntryResources(entry, groupPermissions, guestPermissions);
    }
}
/$;
        return retVal;

    }

    static def getJavaContents(String templateName) {
        def rootTag = getJavaComment(getRootTag(templateName))
        def retVal = $/
/**
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*  GNU Lesser General Public License for more details.
*/
${rootTag}
package com.liferay.test.service.impl;

import javax.portlet.PortletException;
import javax.portlet.PortletRequest;

/**
 * SampleSBLocalServiceImpl
 */
public class SampleSBLocalServiceImpl
    extends SampleSBLocalServiceBaseImpl {

/* <dmsc:sync id="bar123foo"> */
    @Override
    public void addEntryResources(
        long entryId, boolean addGroupPermissions, boolean addGuestPermissions)
        throws PortalException {

        SampleSB entry = sampleSBPersistence.findByPrimaryKey(entryId);

        addEntryResources(entry, addGroupPermissions, addGuestPermissions);
    }
/* </dmsc:sync> */

    @Override
    public void addEntryResources(
        long entryId, String[] groupPermissions, String[] guestPermissions)
        throws PortalException {
/* <dmsc:sync id="asdf"> */
        SampleSB entry = sampleSBPersistence.findByPrimaryKey(entryId);
/* </dmsc:sync> */
        addEntryResources(entry, groupPermissions, guestPermissions);
    }
}
/$;
        return retVal;

    }

    static def getPropertiesTemplate(String templateName) {
        def rootTag = getPropertyComment(getRootTag(templateName))
        def retVal = $/
${rootTag}
include-and-override=portlet-ext.properties
# <dmsc:sync id="propstat1">
<!-- REPLACED BY PROPSTAT1 FIRST TAG -->
# </dmsc:sync>

#
# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
# <dmsc:sync id="propstat2">
<!-- REPLACED BY PROPSTAT2 SECOND TAG -->
# </dmsc:sync>
/$;
        return retVal;

    }

    static def getPropertiesContents(String templateName) {
        def rootTag = getPropertyComment(getRootTag(templateName))
        def retVal = $/
${rootTag}
include-and-override=portlet-ext.properties
# <dmsc:sync id="propstat1">
language.bundle=content.Language
# </dmsc:sync>

#
# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
# <dmsc:sync id="propstat2">
resource.actions.configs=resource-actions/default.xml
# </dmsc:sync>
/$;
        return retVal;

    }

    static def getInsertTagContents(String templateName) {
        def rootTag = getPropertyComment(getRootTag(templateName))
        def retVal = $/
${rootTag}
include-and-override=portlet-ext.properties
# <dmsc:sync id="propstat1"> #
language.bundle=content.Language
<#assign createPath = "DMSC_INSERT_FULLPATH_TAG">
# </dmsc:sync> #

#
# Input a list of comma delimited resource action configurations that will be
# read from the class path.
#
# <dmsc:sync id="propstat2">
resource.actions.configs=resource-actions/default.xml
# </dmsc:sync>
/$;
        return retVal;

    }
}
