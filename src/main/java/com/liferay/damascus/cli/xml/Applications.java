package com.liferay.damascus.cli.xml;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import java.util.List;

/**
 * XML structure POJO : Applications
 * <p>
 * This structure describes Applications,
 * which is based on each model(entity) of service.xml
 *
 * @author Yasuyuki Takeo
 */
public class Applications {

    public List<Applications.Application> application;

    public static class Application {

        @XmlElement(required = true)
        public String namespace;

        @XmlElement(required = true)
        public String model;

        @XmlElement(required = true)
        public String title;

        @XmlElement(defaultValue = "true",required = false)
        public Boolean web;

        @XmlElement(required = true)
        public Asset asset;

        @XmlElement(required = true)
        protected String fieldsName;

        @XmlElement(required = true)
        public Fields fields;

        public Relations relations;
    }

}