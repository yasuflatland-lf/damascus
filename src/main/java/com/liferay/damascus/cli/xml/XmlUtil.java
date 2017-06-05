package com.liferay.damascus.cli.xml;

import org.xml.sax.SAXException;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import java.io.File;

/**
 * XML Utilities
 *
 * @author Yasuyuki Takeo
 */
public class XmlUtil {

    /**
     * Unmarshaller
     * <p>
     * XML to Object
     *
     * @param xmlFile
     * @param xsdFile
     * @return
     * @throws JAXBException
     * @throws SAXException
     */
    static public <T> T unmarshaller(Class<T> clazz, File xmlFile, File xsdFile) throws JAXBException, SAXException {

        SchemaFactory schemaFactory = SchemaFactory
            .newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);

        Schema schema = schemaFactory.newSchema(xsdFile);

        JAXBContext jc = JAXBContext.newInstance(clazz);
        Unmarshaller unmarshaller = jc.createUnmarshaller();
        unmarshaller.setSchema(schema);

        return clazz.cast(unmarshaller.unmarshal(xmlFile));
    }

    /**
     * Unmarshaller
     * <p>
     * XML to Object
     *
     * @param xmlFile
     * @param xsdFile
     * @return
     * @throws JAXBException
     * @throws SAXException
     */
    static public DamascusBase unmarshaller(File xmlFile, File xsdFile) throws JAXBException, SAXException {

        SchemaFactory schemaFactory = SchemaFactory
            .newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);

        Schema schema = schemaFactory.newSchema(xsdFile);

        JAXBContext jc = JAXBContext.newInstance(DamascusBase.class);
        Unmarshaller unmarshaller = jc.createUnmarshaller();
        unmarshaller.setSchema(schema);

        DamascusBase dmsc = (DamascusBase) unmarshaller.unmarshal(xmlFile);
        return dmsc;
    }

    /**
     * Marshaller
     * <p>
     * Object to XML
     *
     * @param obj
     * @param xmlFile
     * @param xsdFile
     * @param <T>
     * @throws SAXException
     * @throws JAXBException
     */
    static public <T> void marshaller(T obj, File xmlFile, File xsdFile) throws SAXException, JAXBException {

        SchemaFactory schemaFactory = SchemaFactory
            .newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        Schema schema = schemaFactory.newSchema(xsdFile);

        JAXBContext jc = JAXBContext.newInstance(obj.getClass());
        Marshaller marshaller = jc.createMarshaller();
        marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
        marshaller.setSchema(schema);
        marshaller.marshal(obj, xmlFile);
    }
}
