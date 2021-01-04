<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/README.md">
# Damascus generated service

Damascus generates scaffolding files to save time for the tedious parts of development. 
This document explains the tips of adding custom implementations on top of Damascus0generated files and adding your own implementations.

# Misc
### Todo comments
Todo comments are inserted where customizations / modifications are needed. Please look for TODO tags in the generated project and add your implementations according to your requirements. 

### How to add pages?
Basically, once the bundles are generated, you can add pages as you want according to the basic Liferay portlet mechanism.
* ```*ViewMVCRenderCommand.java``` is for rendering ```view.jsp```. This is called when a portlet is displayed. 
* ```*CrudMVCActionCommand.java``` is called at view / delete / update/ create a record and ```*CrudMVCRenderCommand.java``` are for rendering after the each action. ```edit.jsp``` and ```view.jsp``` will be rendered according to the actions.
### How can I modify CRUD implementation?
According to Liferay best practices, all m  sdfethods related to model manipulation are found in ```*LocalServiceImpl.java```. Please see ```*LocalServiceImpl.java``` for more details. If you modify the signature of methods or add new methods, you will need to run ```gradle buildService``` to regenerate interfaces.
  
### How can I implement validations?
```*Validator.java``` needs to be implemented according to the comments in the file.
### How can I implement Indexer?
```*Indexer.java``` needs to be modified according to your requirements. 
### How can I modify permissions?
```*ResourcePermissionChecker.java``` and ```*PermissionChecker.java``` need to be modified according to your requirements. 
### How can I modify view for Asset Publisher?
```*AssetRenderer.java``` and ```*AssetRendererFactory.java``` needs to be modified.

# *-web
This bundle includes classes and java files related to display portlets. This also contains utility classes to handle requests. 

### *WebPortlet.java
This is an entry point of displaying a portlet in the user area. 

### *PanelApp.java, *AdminPortlet.java
This is an entry point of displaying a portlet in the administration area (inside of Control Panel)

### *PortletLayoutFinder.java
This is used for displaying contents in Asset Publisher with 

### *AssetRendererFactory.java, *AssetRenderer.java
These classes are used to associate with an asset and generated model.

### *ItemSelectorHelper.java
This is used for Documents and Media related operations (such as uploading assets, selecting assets, e.g)

### *ViewHelper.java
This is a utility class mainly for handling search (search container)

### *ActivityInterpreter.java
This is for managing activities for Activity portlet. When using Activity portlet, you will need to customize what information should be recorded and displayed in this class.

# *-service
*-service includes files which allows access to persistent layer and it's service layer classes which furthermore allows access database through the models / services. This README is a reference of Damascus-generated files. For more details of files that Liferay service builder generates, please check out http://dev.liferay.com.

## *LocalServiceImpl.java
This is an implementation of the service to access the database. Liferay service builder generates the base code for transactions and accessing the database, so you usually don't need to implement database connections / transactions by yourself as long as following Liferay's best practices.

### addEntry* methods
These methods are for adding records on a database.

### updateEntry* methods
These methods are for updating records on a database.

### deleteEntry* methods
These methods are for deleting records on a database.

### moveEntryToTrash* methods
These methods are for moving records into the trash instead of deleting them from a database.

### find* methods
According to Liferay's contract, ```find*``` methods are for retrieving record from database. For the purposes of searching, you may want to use the search engine instead of directory searching on the database for better performance as a best practice.

## *PermissionChecker.java, *ResourcePermissionChecker.java
These classes are for checking permissions. ```*PermissionChecker``` manages permissions to access a model and ```*ResourcePermissionChecker``` manages access to resources such as portlet, configurations, services other than model.

## *Indexer.java
This is for indexing custom model data into the search engine. To ensure search is working properly, this class need to be modified properly according to your requirements. 

## *Validator.java
This is for validating data coming from a form in ```edit.jsp``` of ```*-web``` bundle. According to the comments inside, you can implement error handling. After implementing validation, each error method returns error message key, so you need to add appropriate error message handler in ```view.jsp``` accordingly. For more details of implementation, please refer to the default messages that have already been implemented in the ```view.jsp```. 

## *WorkflowHandler.java
This model includes methods which handles workflows. Please modify this according to your requirements.
