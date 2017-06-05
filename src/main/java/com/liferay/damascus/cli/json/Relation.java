package com.liferay.damascus.cli.json;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.google.common.base.Objects;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * JSON structure POJO : Relation
 *
 * The contents describe the relations with other services.
 *
 * @author  Yasuyuki Takeo
 */
@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class
Relation {
    public String connectionFieldName;
    public String connectionTitle;
    public String detailFileClassName;
}
