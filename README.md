# Damascus

[![Build Status](https://travis-ci.org/yasuflatland-lf/damascus.svg?branch=master)](https://travis-ci.org/yasuflatland-lf/damascus)
[![Coverage Status](https://coveralls.io/repos/github/yasuflatland-lf/damascus/badge.svg?branch=master)](https://coveralls.io/github/yasuflatland-lf/damascus?branch=master)
[![Build status](https://ci.appveyor.com/api/projects/status/qqpdw6drt8w07ljp?svg=true)](https://ci.appveyor.com/project/yasuflatland-lf/damascus)

Damascus is a Liferay Blade tool extension for generating scaffoldings of Service builder portlet with CRUD functionality based on a configuration json file, base.json. For more detailed usage, please see https://github.com/yasuflatland-lf/damascus/wiki

The list of what Damascus automatically generate is as follows
* CRUD functionality with a model
    * CRUD api / corresponding jsp pages
    * Document & Library access field (if you have a corresponding field in base.json)
    * Assets required field (if you have a corresponding field in base.json)
* Workflow
* Trashbox
* Search (Including Advanced search for individual fields)
* Comments
* Related assets
* Ratings
* Activities (The activities on the portlet will be recorded and visible on an activity portlet)
* Multiple service builder portlets at once
* Exporting entities by xls file format

### Required environment
* Liferay 7.0 CE GA4 and Liferay DXP SP3 or higher versions.
* Liferay 7.1 CE GA1 and higher.
* Java 1.8 or above
* gradle 3.0 or above need to be installed
* jpm needs to be installed. (instruction to install is as follows)

### How to Install

**Mac**
```bash
curl https://raw.githubusercontent.com/yasuflatland-lf/damascus/master/installers/global | sudo sh
```

**Windows**
1. [Download jpm](https://raw.githubusercontent.com/jpm4j/jpm4j.installers/master/dist/jpm-setup.exe) and install.
2. Install damascus.jar with jpm as follows. ```jpm install https://github.com/yasuflatland-lf/damascus/raw/master/latest/damascus.jar```

### How to update
1. Run jpm remove damascus to uninstall damascus.
2. Remove all files under ```${user}/.damascus``` folder. If you've modified files, please change them accordingly after regenerating configurations and templates.
3. Follow How to install section to install again

### Getting started
Let's make a Todo app with damascus
1. Create a Liferay workspace with Blade cli or Liferay IDE / Liferay Developer Studio. For more details, please see [this document](https://dev.liferay.com/de/develop/tutorials/-/knowledge_base/7-1/blade-cli).
2. After creating Liferay workspace, navigate to under ```modules``` folder and run ```damascus -init Todo -p com.liferay.sb.test -v 7.1```
3. Navigate to ```todo``` folder. You'll see ```base.json``` file is created. For detailed configuration, please see [the official documentation](https://damascusweb.wedeploy.io). Just for demonstration now, we'll create a scaffolding as it is.
4. Type ```damascus -create``` and damascus will create a scaffolding service and portlet according to the base.json file.
5. Start up your Liferay server and in the ```Todo``` folder, type ```blade deploy```. Blade will run properly and service and portlet will be deployed.

### How to compile Damascus on your own?
1. Clone this repository to your local. Please make sure you've already installed Gradle 3.0 or above and jpm.
2. At the root directory, run ```gradle assemble``` then ```damascus.jar``` will be created under ```/build/libs/``` directory.
3. If you've already installed damascus, uninstall it first with ```jpm remove damascus```. Then install your jar with ```jpm install ./damascus.jar```.

### Proxy settings
Please see more detailed settings [here](https://github.com/yasuflatland-lf/damascus/wiki/4.-Proxy-settings)

### IDE settings
Damascus is including lombok library, so annotation library for lombok needs to be properly installed on IDEs. Here are how to apply lombok to Eclipse / IntelliJ
##### Eclipse
1. Download lombok https://projectlombok.org/download
2. double click ```lombok.jar``` and select the directory where ```eclipse.exe``` exist
3. Run ```gradle eclipse``` at the project directory and restart IDE, and right click on the project and display context name, and choose ```gradle > Refresh gradle project```
4. Java files will be displayed properly without errors.
##### IntelliJ
1. ```Preferences - Plugins``` and search Lombok. Install the Lombok plugin.
2. ```Preferences - Build, Execution, Deployment - Compiler - Annotation Processors``` and check ```Enable annotation processing```

### Bug reports
In terms of bugs, please post Github issues or send me a PR. To send me PR, please follow the process below.
1. Fix bugs at your local
2. Remove ```${user}/.damascus``` folder.
3. Run test locally with this command ```gradle clean test``` and confirm your fix pass all tests.
4. Send PR to /development repository. I'll create a fix brunch accordingly.

### Enhancement requests
A contribution is always welcome! In terms of an Enhancement request, please follow the process below. If you wonder it's a complex feature, please create an issue first and let's discuss. In terms of simple enhancement, please follow steps below.

1. After implementing your feature, please add a test as well. Spock test is preferable because it's more readable and flexible to add tests later on. To add tests, tests are separated by classes and in a test class, each test should be written each method basis.
2. Run test locally with ```gradle clean test``` until your code pass all tests
3. Send a PR to /development branch. According to the status of Travis CI / Appveyor, I may create a feature branch and request you to make it pass the test on Travis CI / Appveyor environment.
4. After all tests pass on Travis CI / Appveyor, will merge into the development branch and relase into master at some points according to the impact of the code.

### What does Damascus stand for?
Damascus is named after "Damascus blade", which is a strong/sharp blade made out from Damascus steel and forged with lost technology. Liferay has it's an official development tool, "Blade", so I gave this name in hope of reinforcement or extension of Blade tool.
