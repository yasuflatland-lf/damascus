package com.liferay.damascus.cli.json.fields;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.liferay.damascus.cli.json.Validation;

import lombok.Data;

import java.util.List;

/**
 * Field Base
 * <p>
 * Field types in service.xml are as follows
 * <p>
 * boolean (Boolean)
 * double (Double)
 * int (Integer)
 * long (Long)
 * Blob (Blob)
 * Date (Date)
 * String (String)
 * Map (Map)
 * <p>
 * Belows are for jsp and java file. () is how it's stored in DB
 * <p>
 * DateTime (Date)
 * document (long)
 * documentlibrary (String, 255 characters)
 * richtext (String, 4001 characters, Textarea)
 * text (String, 4001 characters, Textarea)
 * varchar (String, configured length)
 *
 * @author Yasuyuki Takeo
 */
@Data
@JsonInclude(JsonInclude.Include.NON_EMPTY)
@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, include = JsonTypeInfo.As.PROPERTY, property = "type",visible = true)
public abstract class FieldBase {
    @JsonProperty(required = true)
    public String name;

    @JsonProperty(required = true)
    public String title;

    @JsonProperty(required = true)
    public String type;

    public Validation validation = null;
    
    public boolean primary = false;

    public boolean showFieldInView = true;

    public boolean required = false;

}
