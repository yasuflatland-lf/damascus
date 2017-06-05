package com.liferay.damascus.cli.xml;

import javax.xml.bind.annotation.*;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "_int",
    "_long",
    "_double",
    "date",
    "datetime",
    "varchar",
    "text",
    "richtext",
    "_boolean",
    "document",
    "documentlibrary"
})
public class Type {

    @XmlElement(name = "int")
    public Int _int;

    @XmlElement(name = "long")
    public Long _long;

    @XmlElement(name = "double")
    public Double _double;

    public Date date;

    public Datetime datetime;

    public Varchar varchar;

    public Object text;

    public Object richtext;

    @XmlElement(name = "boolean")
    public Object _boolean;

    public Object document;

    public Object documentlibrary;

    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
    })
    public static class Date {

        @XmlElement(defaultValue = "false")
        public Boolean order;

    }

    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
    })
    public static class Datetime {

        @XmlElement(defaultValue = "false")
        public Boolean order;

    }

    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
    })
    public static class Double {

        @XmlSchemaType(name = "unsignedShort")
        public int length;

        @XmlSchemaType(name = "unsignedShort")
        public int decimals;

        public String regexp;

        @XmlElement(defaultValue = "false")
        public Boolean order;

        @XmlElement(defaultValue = "false")
        public Boolean unique;

    }

    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
    })
    public static class Int {

        @XmlSchemaType(name = "unsignedShort")
        public int length;

        @XmlElement(defaultValue = "false")
        public boolean signed;

        @XmlElement(defaultValue = "true")
        public Boolean zerofill;

        @XmlElement(defaultValue = "false")
        public boolean nullable;

        public String regexp;

        @XmlElement(defaultValue = "false")
        public Boolean order;

        @XmlElement(defaultValue = "false")
        public Boolean unique;

    }

    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
    })
    public static class Long {

        @XmlSchemaType(name = "unsignedShort")
        public int length;

        @XmlElement(defaultValue = "false")
        public boolean signed;

        @XmlElement(defaultValue = "false")
        public boolean nullable;

        public String regexp;

        @XmlElement(defaultValue = "false")
        public Boolean order;

        @XmlElement(defaultValue = "false")
        public Boolean unique;

    }

    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
    })
    public static class Varchar {

        @XmlSchemaType(name = "unsignedShort")
        public int length;

        public String regexp;

        public String order;

        @XmlElement(defaultValue = "false")
        public Boolean unique;

        public String filter;
    }
}
