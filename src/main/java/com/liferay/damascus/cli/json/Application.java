package com.liferay.damascus.cli.json;

import com.fasterxml.jackson.annotation.*;
import com.liferay.damascus.cli.json.fields.*;
import lombok.*;

import java.security.*;
import java.util.*;

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

    public List<Relation> relations = null;

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

        //Primary key must be one. Throw exception to let user know to fix base.json
        if (1 != (getFields().stream().filter(f -> (true == f.primary)).count())) {
            throw new InvalidParameterException("Multiple primary keys have been detected in application<" + getTitle() + ">. Primary key should be only one.");
        }

        return true;
    }
}