package com.liferay.damascus.cli.json;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * JSON structure POJO : Validation
 *
 * @author  Softbless
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonTypeInfo(use = JsonTypeInfo.Id.NONE)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Validation {
	@JsonProperty(required = true)
    public String className;

    @JsonProperty(required = true)
    public String fieldName;

    @JsonProperty(required = true)
    public String orderByField;    
}
