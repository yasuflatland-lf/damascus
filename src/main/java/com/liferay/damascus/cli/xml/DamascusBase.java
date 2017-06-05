package com.liferay.damascus.cli.xml;

import lombok.Data;
import lombok.ToString;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * XML structure POJO : DamascusBase
 * <p>
 * This is the top level structure of XML.
 * All XML structures are included in this POJO.
 *
 * @author Yasuyuki Takeo
 */
@XmlRootElement(name="definition")
@ToString
@Data
public class DamascusBase {

    private String projectName = null;

    private String liferayVersion = null;

    private String packageName = null;

    private Applications applications;
}
