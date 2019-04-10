package com.liferay.damascus.cli.json.fields;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.liferay.damascus.cli.json.Validation;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

/**
 * Long
 *
 * @author Yasuyuki Takeo
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(callSuper=false)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Long extends FieldBase{
    public boolean unique;

    public Validation validation = null;

}
