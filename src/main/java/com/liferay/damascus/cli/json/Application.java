package com.liferay.damascus.cli.json;

import java.security.InvalidParameterException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.liferay.damascus.cli.json.fields.FieldBase;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * JSON structure POJO : Application
 * <p>
 * This structure describes Application,
 * which is based on each model(entity) of service.xml
 *
 * @author Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonTypeInfo(use = JsonTypeInfo.Id.NONE)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Application {

    @JsonProperty(required = true)
    public String model;

    @JsonProperty(required = true)
    public String title;

    public boolean web = true;

    @JsonProperty(required = true)
    public Asset asset = null;

    @JsonProperty(required = true)
    public String fieldsName = null;

    @JsonProperty(required = true)
    public List<FieldBase> fields = null;

    /**
     * Custom value map
     */
    public Map<String, String> customValue;

    /**
     * Replacement keywords map
     */
    public LinkedHashMap<String, String> replacements;

    /**
     * Has an asset configured?
     *
     * @return true if it's configured. false if it's not
     */
    @JsonIgnore
    public boolean isSetAsset() {
        return (null != asset) ? true : false;
    }

    @JsonIgnore
    public boolean hasPrimary() {

        //Primary key must be unique. Throw exception in case it is not.
        if (1 != (getFields().stream().filter(f -> (true == f.primary)).count())) {
            throw new InvalidParameterException("Multiple primary keys have been detected in application<" + getTitle() + ">. Primary key should be only one.");
        }

        return true;
    }
}