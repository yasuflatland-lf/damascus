package com.liferay.damascus.cli.xml;

import javax.xml.bind.annotation.XmlElement;
import java.util.List;

public class Relations {

    public List<Relation> relation;

    public static class Relation {

        @XmlElement(required = true)
        public String detailFileClassName;

        @XmlElement(required = true)
        public String connectionFieldName;

        @XmlElement(required = true)
        public String connectionTitle;

    }
}