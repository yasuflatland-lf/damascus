// <dmsc:root templateName="Portlet_XXXXWEB_WebKeys.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/constants/${capFirstModel}WebKeys.java">
// </dmsc:sync> //
package ${packageName}.web.constants;

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

/**
 * @author ${damascus_author}
 */
public class ${capFirstModel}WebKeys {

	public static final String ADMIN_EDIT_JSP = "/sample_sb_admin/edit.jsp";

	public static final String ADMIN_VIEW_JSP = "/sample_sb_admin/view.jsp";

	public static final String ADMIN_VIEW_RECORD_JSP =
		"/sample_sb_admin/view_record.jsp";

	public static final String EDIT_JSP = "/sample_sb/edit.jsp";

	public static final String ${uppercaseModel}_DISPLAY_CONTEXT =
		"${uppercaseModel}_DISPLAY_CONTEXT";

	public static final String ${uppercaseModel}_ITEM_SELECTOR_HELPER =
		"${uppercaseModel}_ITEM_SELECTOR_HELPER";

	public static final String ${uppercaseModel}_VIEW_HELPER = "${uppercaseModel}_VIEW_HELPER";

	public static final String VIEW_JSP = "/sample_sb/view.jsp";

	public static final String VIEW_RECORD_JSP = "/sample_sb/view_record.jsp";

}