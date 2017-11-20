package com.liferay.damascus.cli.json;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.google.common.collect.Lists;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * JSON structure POJO : DamascusBase
 *
 * This is the top level structure of JSON.
 * All JSON structures are included in this POJO.
 *
 * @author  Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
@Data
@AllArgsConstructor
@JsonTypeInfo(use = JsonTypeInfo.Id.NONE)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class DamascusBase {

    @JsonProperty(required = true)
    public String projectName;
    
    @JsonProperty(required = true)
    public String packageName;

    @JsonProperty(required = true)
    public String liferayVersion;

    public Map<String, String> customValue;

    @JsonProperty(required = true)
    public List<Application> applications = null;
}
