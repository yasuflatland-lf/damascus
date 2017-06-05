<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/${application.model}/${application.model}-web/src/main/resources/META-INF/resources/search_results.jspf">

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