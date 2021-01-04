<#include "./valuables.ftl">
<#assign createPath = "${createPath_val}/README.md">
# Damascus generated service

Damascus generates scaffolding files to save time for the tedious parts of the development. 
This document explains the tips of adding custom implementations on top of Damascus0generated files and adding your implementations.

# Misc
### TODO comments
Todo comments are inserted where customizations/modifications are needed. Please look for TODO tags in the generated project and add your implementations according to your requirements. 

### How to add pages?
Once Damascus generates the bundles, you can add pages as you want according to the basic Liferay portlet mechanism. Damascus generates both Admin and User pages and renders classes separately.
* ```*ViewMVCRenderCommand.java```  renders ```view.jsp```. 
* ```*CrudMVCActionCommand.java``` process view/delete/update/ create a record command. ```*CrudMVCRenderCommand.java``` renders ```edit.jsp``` and ```view.jsp``` according to the actions.

### How can I modify CRUD implementation?
According to Liferay's best practices, all model manipulation methods are stored in ```*LocalServiceImpl.java```. Please see ```*LocalServiceImpl.java``` for more details. 

From 7.2, permission checking are all delegated into ```*ServiceImpl.java```. ```*LocalServiceImpl.java``` is now only responsible for processing business logic. For more details, please see ```Blogs``` implimentations in the Liferay's source code.

When you modify the signature of methods or add new methods, please run ```gradle buildService``` to regenerate interfaces.
 
### How can I implement validations?
```*Validator.java``` includes validations. Please see the comments in the file for more details.

### How can I implement Indexer?
```*Indexer.java``` includes all required methods and enable your custom models to be searched in Liferay. However, this template implementation is legacy for the convenience in order to keep template files as less as possible. 

From 7.2, Search introduces new framework for the implementation, which is more modular and divides each search related functionality into different classes separately. For more details, please see the [official documents](https://portal.liferay.dev/docs/7-2/frameworks/-/knowledge_base/f/search)

### How can I modify permissions?
```*ModelResourcePermissionRegistrar.java``` and ```*PortletResourcePermissionRegistrar.java``` register permission helpers to the search framework. Please modify these files according to your requirements.

```*Permission.java``` classes are helper classes to check permission.

```default.xml``` under ```*-web/src/main/resources/resource-actions/default.xml``` and ```*-service/src/main/resources/META-INF/resource-actions/default.xml``` contain permission configurations.

### How can I modify view for Asset Publisher?
```*AssetRenderer.java``` and ```*AssetRendererFactory.java``` render ```abstract.jsp```, ```abstract.jsp``` and ```prewview.jsp``` for ```Asset Framework```. For more details, please see the [official document](https://portal.liferay.dev/docs/7-2/frameworks/-/knowledge_base/f/creating-an-asset-renderer)

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
This is used for Documents and Media related operations (such as uploading assets, selecting assets, e.g.)

### *ViewHelper.java
This class is a utility class mainly for handling search (search container)

# *-service
```*-service``` includes files which allow access to persistent layer, and it's service layer classes, which furthermore allows access database through the models/services. This README is a reference to Damascus-generated files. For more details of files that Liferay service builder generates, please check out http://dev.liferay.com.

## *LocalServiceImpl.java
This class is an implementation of the service to access the database. Liferay service builder generates the base code for transactions and accessing the database, so you usually don't need to implement database connections/transactions by yourself as long as following Liferay's best practices.

### addEntry* methods
These methods are for adding records on a database.

### updateEntry* methods
These methods are for updating records on a database.

### deleteEntry* methods
These methods are for deleting records on a database.

### moveEntryToTrash* methods
These methods are for moving records into the trash instead of deleting them from a database.

### find* methods
According to Liferay's contract, ```find*``` methods are for retrieving a record from the database. For searching, you may want to use the search engine instead of directory searching on the database for better performance as a best practice.

## Permission
There are 4 files related to permission management
| File name | Note |
| :-- | :-- |
| *Permission.java | Manage Portlet permission | 
| *EntryPermission.java | Manage Model permission |
| *ModelResourcePermissionRegistrar.java | Register Model permission handler and configure details of permission types |
| *PortletResourcePermissionRegistrar.java | Register portlet permission handler and configure details of permission types |
| default.xml | Permission mapping |

## *Indexer.java
This class is for indexing custom model data into the search engine. To ensure the search is working correctly, this class needs to be appropriately modified according to your requirements. 

From 7.2, the search introduced a new framework. For more details, please refer [the official document.](https://portal.liferay.dev/docs/7-2/frameworks/-/knowledge_base/f/search)

## *Validator.java
This class is for validating data coming from a form in ```edit.jsp``` of ```*-web``` bundle. According to the comments inside, you can implement error handling. After implementing validation, each error method returns the error message key, so you need to add an appropriate error message handler in ```view.jsp``` accordingly. Please refer to the default messages that have already been in place in the ```view.jsp```.

## *WorkflowHandler.java
This model handles workflows.

## *DisplayContext.java
This class holds search related context and display contexts.

## *ManagementToolbarDisplayContext.java
This class process the contents and state of management bar in both Admin and user portlet.

## *ExportMVCResourceCommand.java
This class process Export model data as csv with Apache POI.