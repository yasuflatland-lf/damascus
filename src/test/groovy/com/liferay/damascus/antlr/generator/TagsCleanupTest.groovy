package com.liferay.damascus.antlr.generator

import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.test.tools.AntlrTestBase
import org.apache.commons.io.FileUtils
import spock.lang.Unroll

import java.nio.charset.StandardCharsets

class TagsCleanupTest extends AntlrTestBase {

    @Unroll("smoke test (jsp file)")
    def "smoke test (jsp file)"() {
        when:
        def testFileName = "test.jsp"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(DamascusProps.TMP_PATH))
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

        def filePath = new File(DamascusProps.TMP_PATH + TEST_DIR + DamascusProps.DS + testFileName)
        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        def result = TagsCleanup.process(contents)
        def error_str = errContent.toString()

        then:
        error_str.isEmpty()
        true == filePath.exists()
        !result.contains('dmsc:sync')
        !result.contains('dmsc:root')
    }

    @Unroll("smoke test (tags do not exist)")
    def "smoke test (tags do not exist)"() {
        when:
        def testFileName = "test.jsp"

        final FileTreeBuilder tf = new FileTreeBuilder(new File(DamascusProps.TMP_PATH))
        tf.dir(TEST_DIR) {
            file(testFileName) {
                withWriter('UTF-8') { writer ->
                    writer.write '''
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
'''.stripIndent()
                }
            }
        }

        def filePath = new File(DamascusProps.TMP_PATH + TEST_DIR + DamascusProps.DS + testFileName)
        String contents = FileUtils.readFileToString(filePath, StandardCharsets.UTF_8);
        def result = TagsCleanup.process(contents)
        def error_str = errContent.toString()

        then:
        error_str.isEmpty()
        true == filePath.exists()
        contents == result
    }
}