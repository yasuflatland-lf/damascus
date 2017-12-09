<#include "./valuables.ftl">
<#assign createPath = "${entityWebResourcesPath}/search_results.jspf">
<#assign skipTemplate = !generateWeb>
<%@page import="javax.portlet.RenderRequest"%>
<%
    searchContainer.setOrderByCol(orderByCol);
    searchContainer.setOrderByType(orderByType);

    SearchContainerResults<${capFirstModel}> searchContainerResults = null;
    if (Validator.isNull(keywords)) {
        searchContainerResults = ${uncapFirstModel}ViewHelper.getListFromDB(renderRequest, searchContainer);
    } else {
        searchContainerResults = ${uncapFirstModel}ViewHelper.getListFromIndex(renderRequest, searchContainer);
    }

    searchContainer.setTotal(searchContainerResults.getTotal());
    searchContainer.setResults(searchContainerResults.getResults());
%>