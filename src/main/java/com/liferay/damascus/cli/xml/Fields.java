package com.liferay.damascus.cli.xml;

import javax.xml.bind.annotation.XmlElement;
import java.util.List;

public class Fields {

    public List<Field> field;

    public static class Field {

        @XmlElement(required = true)
        public String name;

        @XmlElement(required = true)
        public String title;

        @XmlElement(required = true)
        public Type type;

        @XmlElement(defaultValue = "true")
        public boolean showFieldInView;

        @XmlElement(defaultValue = "false")
        public Boolean required;

        public Relations relations;
    }

}