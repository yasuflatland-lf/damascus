package com.liferay.damascus.cli.json;

import com.fasterxml.jackson.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

/**
 * JSON structure POJO : DamascusBase
 * <p>
 * This is the top level structure of JSON.
 * All JSON structures are included in this POJO.
 *
 * @author Yasuyuki Takeo
 * @author Sébastien Le Marchand
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
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

    /**
     * Check Web generation status
     *
     * @return true if any application set web to true or false
     */
    @JsonIgnore
    public boolean isWebExist() {
        if (null == applications) {
            return false;
        }

        return applications.stream().anyMatch(a -> a.isWeb() == true);
    }
}
