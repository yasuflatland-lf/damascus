// <dmsc:root templateName="Portlet_XXXXWEB_Configuration.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}Configuration.java">
// </dmsc:sync> //
package ${packageName}.web.portlet.action;

/**
 *  Copyright (C) 2017 ${damascus_author} All rights reserved.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Lesser General Public License for more details.
 */
import aQute.bnd.annotation.metatype.Meta;

import ${packageName}.constants.${capFirstModel}PortletKeys;

/**
 * ${capFirstModel} Configuration
 *
 * @author ${damascus_author}
 */
@Meta.OCD(id = ${capFirstModel}PortletKeys.${uppercaseModel}_CONFIG)
public interface ${capFirstModel}Configuration {

	public static final String CONF_PREFS_VIEW_TYPE = "prefsViewType";

	public static final String CONF_DATE_FORMAT = "dateFormat";

	public static final String CONF_DATETIME_FORMAT = "datetimeFormat";

	public static final String PREFS_VIEW_TYPE_DEFAULT = "0";

	public static final String PREFS_VIEW_TYPE_USER = "1";

	public static final String PREFS_VIEW_TYPE_USER_GROUP = "2";

	@Meta.AD(deflt = PREFS_VIEW_TYPE_DEFAULT, required = false)
	public int prefsViewType();

	@Meta.AD(deflt = "yyyy/MM/dd", required = false)
	public String dateFormat();

	@Meta.AD(deflt = "yyyy/MM/dd HH:mm", required = false)
	public String datetimeFormat();

	@Meta.AD(deflt = "%Y/%m/%d", required = false)
	public String datePickerFormat();

}