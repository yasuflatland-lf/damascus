// <dmsc:root templateName="Portlet_XXXXWEB_PortletLayoutFinder.java.ftl"  />
// <dmsc:sync id="head-common" > //
<#include "./license.ftl">
<#include "./valuables.ftl">
<#assign createPath = "${webModulePath}/src/main/java/${packagePath}/web/portlet/action/${capFirstModel}PortletLayoutFinder.java">
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
import com.liferay.portal.kernel.portlet.BasePortletLayoutFinder;
import com.liferay.portal.kernel.portlet.PortletLayoutFinder;
import ${packageName}.constants.${capFirstModel}PortletKeys;

import org.osgi.service.component.annotations.Component;

/**
 * @author ${damascus_author}
 */
@Component(
	immediate = true,
	property = "model.class.name=${packageName}.model.${capFirstModel}",
	service = PortletLayoutFinder.class
)
public class ${capFirstModel}PortletLayoutFinder extends BasePortletLayoutFinder {

	@Override
	protected String[] getPortletIds() {
		return _PORTLET_IDS;
	}

	private static final String[] _PORTLET_IDS = {${capFirstModel}PortletKeys.${uppercaseModel}};

}