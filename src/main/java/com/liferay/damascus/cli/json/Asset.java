package com.liferay.damascus.cli.json;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * JSON structure POJO : Asset
 *
 * @author  Yasuyuki Takeo
 */
@Data
@AllArgsConstructor
@JsonTypeInfo(use = JsonTypeInfo.Id.NONE)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class Asset {
    @JsonProperty(required = true)
    public String assetTitleFieldName;

    @JsonProperty(required = true)
    public String assetSummaryFieldName;

    public boolean categories = true;
    public boolean discussion = true;
    public boolean ratings = true;
    public boolean tags = true;
    public boolean relatedAssets = true;
    public String fullContentFieldName;
    public boolean workflow = true;
    public boolean generateActivity = true;
    public boolean trash = true;
}
