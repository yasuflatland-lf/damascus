package com.liferay.damascus.antlr.generator

import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.test.tools.AntlrTestBase
import com.liferay.damascus.cli.common.CommonUtil
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import spock.lang.Unroll

import java.nio.charset.StandardCharsets

class TemplateGeneratorTest extends AntlrTestBase {

    @Unroll("smoke test (jsp file)")
    def "smoke test (jsp file)"() {
        when:
        def testFileName = "test.jsp"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
<%--
<dmsc:root id="hoge" />
--%>
<%
Gadget gadget = (Gadget)renderRequest.getAttribute(WebKeys.GADGET);
%>

<%
<dmsc:sync id="hoge" >
%>
<c:choose>
    <c:when test="<%= gadget == null %>">
        <div class="alert alert-info portlet-configuration">
            <a href="<%= portletDisplay.getURLConfiguration() %>" onClick="<%= portletDisplay.getURLConfigurationJS() %>">
                <liferay-ui:message key="configure-a-gadget-to-be-displayed-in-this-portlet" />
            </a>
        </div>

        <liferay-ui:icon
            cssClass="portlet-configuration"
            iconCssClass="icon-cog"
            message="configure-gadget"
            method="get"
            onClick="<%= portletDisplay.getURLConfigurationJS() %>"
            url="<%= portletDisplay.getURLConfiguration() %>"
        />
    </c:when>
    <c:otherwise>
        <liferay-util:include page="/gadget/view.jsp" servletContext="<%= application %>" />
    </c:otherwise>
<%
</dmsc:sync>
%>
'''.stripIndent()
                }
            }
        }

        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        def result = TemplateGenerator.builder().contentsFile(filePath).build().process()

        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        def error_str = errContent.toString()

        then:
        error_str.isEmpty()
        true == filePath.exists()
        contents == result
    }

    @Unroll("root tag missing. must be error")
    def "root tag missing. must be error"() {
        when:
        def testFileName = "test.js"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
<%
Gadget gadget = (Gadget)renderRequest.getAttribute(WebKeys.GADGET);
%>

<%
<dmsc:sync id="hoge" >
%>
<c:choose>
    <c:when test="<%= gadget == null %>">
        <div class="alert alert-info portlet-configuration">
            <a href="<%= portletDisplay.getURLConfiguration() %>" onClick="<%= portletDisplay.getURLConfigurationJS() %>">
                <liferay-ui:message key="configure-a-gadget-to-be-displayed-in-this-portlet" />
            </a>
        </div>

        <liferay-ui:icon
            cssClass="portlet-configuration"
            iconCssClass="icon-cog"
            message="configure-gadget"
            method="get"
            onClick="<%= portletDisplay.getURLConfigurationJS() %>"
            url="<%= portletDisplay.getURLConfiguration() %>"
        />
    </c:when>
    <c:otherwise>
        <liferay-util:include page="/gadget/view.jsp" servletContext="<%= application %>" />
    </c:otherwise>
<%
</dmsc:sync>
%>
'''.stripIndent()
                }
            }
        }

        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        def result = TemplateGenerator.builder().contentsFile(filePath).build().process()
        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        def error_str = errContent.toString()

        then:
        true == filePath.exists()
        contents == result
        error_str.contains('root must be decleared first')
    }

    @Unroll("sync start tag missing. must be error")
    def "sync start tag missing. must be error"() {
        when:
        def testFileName = "test.js"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
<%--
<dmsc:root id="hoge" />
--%>
<%
Gadget gadget = (Gadget)renderRequest.getAttribute(WebKeys.GADGET);
%>

<c:choose>
    <c:when test="<%= gadget == null %>">
        <div class="alert alert-info portlet-configuration">
            <a href="<%= portletDisplay.getURLConfiguration() %>" onClick="<%= portletDisplay.getURLConfigurationJS() %>">
                <liferay-ui:message key="configure-a-gadget-to-be-displayed-in-this-portlet" />
            </a>
        </div>

        <liferay-ui:icon
            cssClass="portlet-configuration"
            iconCssClass="icon-cog"
            message="configure-gadget"
            method="get"
            onClick="<%= portletDisplay.getURLConfigurationJS() %>"
            url="<%= portletDisplay.getURLConfiguration() %>"
        />
    </c:when>
    <c:otherwise>
        <liferay-util:include page="/gadget/view.jsp" servletContext="<%= application %>" />
    </c:otherwise>
<%
</dmsc:sync>
%>
'''.stripIndent()
                }
            }
        }

        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        def result = TemplateGenerator.builder().contentsFile(filePath).build().process()
        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        def error_str = errContent.toString()

        then:
        true == filePath.exists()
        contents == result
        error_str.contains('dmsc:sync start tag is missing.')
    }

    @Unroll("sync end tag missing. must be error")
    def "sync end tag missing. must be error"() {
        when:
        def testFileName = "test.js"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
<%--
<dmsc:root id="hoge" />
--%>
<%
Gadget gadget = (Gadget)renderRequest.getAttribute(WebKeys.GADGET);
%>

<%
<dmsc:sync id="hoge" >
%>
<c:choose>
    <c:when test="<%= gadget == null %>">
        <div class="alert alert-info portlet-configuration">
            <a href="<%= portletDisplay.getURLConfiguration() %>" onClick="<%= portletDisplay.getURLConfigurationJS() %>">
                <liferay-ui:message key="configure-a-gadget-to-be-displayed-in-this-portlet" />
            </a>
        </div>

        <liferay-ui:icon
            cssClass="portlet-configuration"
            iconCssClass="icon-cog"
            message="configure-gadget"
            method="get"
            onClick="<%= portletDisplay.getURLConfigurationJS() %>"
            url="<%= portletDisplay.getURLConfiguration() %>"
        />
    </c:when>
    <c:otherwise>
        <liferay-util:include page="/gadget/view.jsp" servletContext="<%= application %>" />
    </c:otherwise>
</c:choose>
'''.stripIndent()
                }
            }
        }

        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        def result = TemplateGenerator.builder().contentsFile(filePath).build().process()
        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        def error_str = errContent.toString()

        then:
        true == filePath.exists()
        contents == result
        error_str.contains('dmsc:sync is not closed')
    }

    @Unroll("smoke test (java file)")
    def "smoke test (java file)"() {
        when:
        def testFileName = "test.java"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.util;

import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.Http;
import com.liferay.portal.kernel.util.PortalRunMode;
import com.liferay.portal.kernel.util.ReflectionUtil;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringUtil;

import java.io.InputStream;

import java.lang.reflect.Method;

import java.net.InetAddress;
import java.net.URI;
import java.net.URL;
import java.net.URLClassLoader;
import java.net.UnknownHostException;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * @author Shuyang Zhou
 */
public class JarUtil {

    public static Path downloadAndInstallJar(
            URL url, String libPath, String name)
        throws Exception {
/* <dmsc:root id="hoge" /> */
        String protocol = url.getProtocol();

        if (PortalRunMode.isTestMode() &&
            (protocol.equals(Http.HTTP) || protocol.equals(Http.HTTPS))) {

            String urlString = url.toExternalForm();

/* <dmsc:sync id="hoge" > */
            if (!urlString.contains("mirrors")) {
                try {
                    InetAddress.getAllByName("mirrors");

                    String newURLString = StringUtil.replace(
                        urlString, "://", "://mirrors/");

                    url = new URL(newURLString);

                    if (_log.isDebugEnabled()) {
                        _log.debug(
                            StringBundler.concat(
                                "Swapping URL from ", urlString, " to ",
                                newURLString));
                    }
                }
                catch (UnknownHostException uhe) {
                    if (_log.isDebugEnabled()) {
                        _log.debug("Unable to resolve \"mirrors\"");
                    }
                }
            }
/* </dmsc:sync> */
        }

        Path path = Paths.get(libPath, name);

        if (_log.isInfoEnabled()) {
            _log.info(
                StringBundler.concat(
                    "Downloading ", String.valueOf(url), " to ",
                    String.valueOf(path)));
        }
/* <dmsc:sync id="fuga" > */
        try (InputStream inputStream = url.openStream()) {
            Files.copy(inputStream, path, StandardCopyOption.REPLACE_EXISTING);
        }
/* </dmsc:sync> */
        if (_log.isInfoEnabled()) {
            _log.info(
                StringBundler.concat(
                    "Downloaded ", String.valueOf(url), " to ",
                    String.valueOf(path)));
        }

        return path;
    }

    public static void downloadAndInstallJar(
            URL url, String libPath, String name, URLClassLoader urlClassLoader)
        throws Exception {

        Path path = downloadAndInstallJar(url, libPath, name);

        URI uri = path.toUri();

        if (_log.isInfoEnabled()) {
            _log.info(
                StringBundler.concat(
                    "Installing ", String.valueOf(path), " to ",
                    String.valueOf(urlClassLoader)));
        }

        _addURLMethod.invoke(urlClassLoader, uri.toURL());

        if (_log.isInfoEnabled()) {
            _log.info(
                StringBundler.concat(
                    "Installed ", String.valueOf(path), " to ",
                    String.valueOf(urlClassLoader)));
        }
    }

    private static final Log _log = LogFactoryUtil.getLog(JarUtil.class);

    private static final Method _addURLMethod;

    static {
        try {
            _addURLMethod = ReflectionUtil.getDeclaredMethod(
                URLClassLoader.class, "addURL", URL.class);
        }
        catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

}
'''.stripIndent()
                }
            }
        }

        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        def result = TemplateGenerator.builder().contentsFile(filePath).build().process()

        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);

        then:
        true == filePath.exists()
        contents == result
    }

    @Unroll("Root attribute fetch test")
    def "Root attribute fetch test"() {
        when:
        def testFileName = "test.jsp"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
<%--
<dmsc:root id="hoge" 
templateFileName="Portlet_XXXXWEB_Test.java.ftl"
version="70"
templateDirPath="/hoge/fuga/aaa" />
--%>
<%
Gadget gadget = (Gadget)renderRequest.getAttribute(WebKeys.GADGET);
%>

<%
<dmsc:sync id="aaa" >
%>
TEST
<%
</dmsc:sync>
%>
'''.stripIndent()
                }
            }
        }

        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        TemplateGenerator tg = new TemplateGenerator(filePath, null)
        tg.process()
        TemplateContext sc = tg.getSourceContext()
        def rootAttr = sc.getRootAttributes()

        then:
        true == filePath.exists()
        "hoge" == rootAttr.get("id")
        "Portlet_XXXXWEB_Test.java.ftl" == rootAttr.get("templateFileName")
        "70" == rootAttr.get("version")
        "/hoge/fuga/aaa" == rootAttr.get("templateDirPath")
    }

    @Unroll("replaceKeywords Test")
    def "replaceKeywords Test"() {
        when:
        def testFileName = "dummy.text"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(TestUtils.getTempPath()))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''package com.liferay.test.service.impl;
/**
* SampleSBLocalServiceImpl
*/
entry.setSamplesbText(ParamUtil.getString(request, "samplesbText"));
SampleSB entry = sampleSBPersistence.findByPrimaryKey(entryId);
addEntryResources(entry, addGroupPermissions, addGuestPermissions);
SampleSBActivityKeys.UPDATE_SAMPLESB
//  test sample-sb
}
/**
* Populate Model with values from a form
*
* @param request PortletRequest
* @return SampleSB Object
* @throws PortletException
* @throws SampleSBValidateException
*/
public SampleSB getSampleSBFromRequest(
long primaryKey, PortletRequest request) throws PortletException, SampleSBValidateException {
ThemeDisplay themeDisplay = (ThemeDisplay) request
.getAttribute(WebKeys.THEME_DISPLAY);
return entry;
}
}'''.stripIndent()
                }
            }
        }

        def outputFileName = "output.txt"

        tf.dir(TEST_DIR) {
            file(outputFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''package ${packageName}.service.impl;
/**
* ${capFirstModel}LocalServiceImpl
*/
entry.setSamplesbText(ParamUtil.getString(request, "${lowercaseModel}Text"));
${capFirstModel} entry = ${uncapFirstModel}Persistence.findByPrimaryKey(entryId);
addEntryResources(entry, addGroupPermissions, addGuestPermissions);
${capFirstModel}ActivityKeys.UPDATE_${uppercaseModel}
//  test ${snakecaseModel}
}
/**
* Populate Model with values from a form
*
* @param request PortletRequest
* @return ${capFirstModel} Object
* @throws PortletException
* @throws ${capFirstModel}ValidateException
*/
public ${capFirstModel} get${capFirstModel}FromRequest(
long primaryKey, PortletRequest request) throws PortletException, ${capFirstModel}ValidateException {
ThemeDisplay themeDisplay = (ThemeDisplay) request
.getAttribute(WebKeys.THEME_DISPLAY);
return entry;
}
}'''.stripIndent()
                }
            }
        }
        def filePath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + testFileName)
        def outPath = new File(TestUtils.getTempPath() + TEST_DIR + DamascusProps.DS + outputFileName)

        def checkpattern = [
                'com.liferay.test': '${packageName}',
                'SampleSB'        : '${capFirstModel}',
                'sampleSB'        : '${uncapFirstModel}',
                'samplesb'        : '${lowercaseModel}',
                'SAMPLESB'        : '${uppercaseModel}',
                'sample-sb'       : '${snakecaseModel}'
        ]

        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        String expected = FileUtils.readFileToString(outPath, StandardCharsets.UTF_8);
        def result = CommonUtil.replaceKeywords(contents, checkpattern)
        //FileUtils.writeStringToFile( outPath, result, StandardCharsets.UTF_8);

        then:
        true == outPath.exists()
        result == expected

    }

}
