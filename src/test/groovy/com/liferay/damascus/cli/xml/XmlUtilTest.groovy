package com.liferay.damascus.cli.xml

import com.google.common.io.Resources
import com.liferay.damascus.cli.common.DamascusProps
import com.liferay.damascus.cli.test.tools.TestUtils
import org.apache.commons.io.FileUtils
import org.apache.commons.lang3.StringUtils
import spock.lang.Specification
import spock.lang.Unroll

class XmlUtilTest extends Specification {
    static def DS = DamascusProps.DS;
    static def workTempDir = TestUtils.getTempPath() + "damascustest";

    def template_path = DamascusProps.TEMPLATE_FOLDER_NAME;
    def resource_path = DS + template_path + DS + DamascusProps.VERSION_70 + DS
    def base_xml_path = resource_path + DamascusProps.BASE_XML;
    def base_xsd_path = resource_path + DamascusProps.BASE_XSD;

    def setup() {
        FileUtils.deleteDirectory(new File(workTempDir));
        FileUtils.forceMkdir(new File(workTempDir))
    }

    @Unroll("unmarshaller test")
    def "unmarshaller smoke test"() {
        when:
        URL urlXml = Resources.getResource(XmlUtilTest.class, base_xml_path)
        URL urlXsd = Resources.getResource(XmlUtilTest.class, base_xsd_path)
        DamascusBase dmsc = XmlUtil.unmarshaller(new File(urlXml.toURI()),new File(urlXsd.toURI()))
        Applications.Application app = dmsc.applications.application[0];

        then:
        true != StringUtils.isEmpty(dmsc.projectName)
        true != StringUtils.isEmpty(dmsc.packageName)
        true != StringUtils.isEmpty(dmsc.liferayVersion)
        true != app.namespace.equals("")
        true != app.model.equals("")
        true != app.title.equals("")
        true == app.asset.assetTitleFieldName.equals("ToDoTitleName")

    }

    @Unroll("unmarshaller generic test")
    def "unmarshaller generic smoke test"() {
        when:
        URL urlXml = Resources.getResource(XmlUtilTest.class, base_xml_path)
        URL urlXsd = Resources.getResource(XmlUtilTest.class, base_xsd_path)
        com.liferay.damascus.cli.xml.DamascusBase dmsc = XmlUtil.unmarshaller(com.liferay.damascus.cli.xml.DamascusBase.class,new File(urlXml.toURI()),new File(urlXsd.toURI()))
        com.liferay.damascus.cli.xml.Applications.Application app = dmsc.applications.application[0];

        then:
        true != StringUtils.isEmpty(dmsc.projectName)
        true != StringUtils.isEmpty(dmsc.packageName)
        true != StringUtils.isEmpty(dmsc.liferayVersion)
        true != app.namespace.equals("")
        true != app.model.equals("")
        true != app.title.equals("")
        true == app.asset.assetTitleFieldName.equals("ToDoTitleName")
        true == app.fields.field[0].name.equals("todoId");
        5 == app.fields.field[0].type._long.length;
    }

    @Unroll("marshaller smoke test")
    def "marshaller smoke test"() {
        when:
        URL urlXml = Resources.getResource(XmlUtilTest.class, base_xml_path)
        URL urlXsd = Resources.getResource(XmlUtilTest.class, base_xsd_path)
        DamascusBase dmsc = XmlUtil.unmarshaller(new File(urlXml.toURI()),new File(urlXsd.toURI()))

        def outputXmlPath = new File(workTempDir + DamascusProps.BASE_XML)
        XmlUtil.marshaller(dmsc, outputXmlPath, new File(urlXsd.toURI()))

        then:
        true == outputXmlPath.exists()
    }

}