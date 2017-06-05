# Damascus

[![Build Status](https://travis-ci.org/yasuflatland-lf/damascus.svg?branch=master)](https://travis-ci.org/yasuflatland-lf/damascus)

---

Damascus is a Liferay Blade tool extension for generating scaffoldings of Service builder portlet with CRUD functionality from a json file. For more detailed usage, pleaase consult to https://github.com/yasuflatland-lf/damascus/wiki

### Install

**Mac**
```bash
curl https://raw.githubusercontent.com/yasuflatland-lf/damascus/master/installers/global | sudo sh
```

**Windows**
1. Download jpm (https://raw.githubusercontent.com/jpm4j/jpm4j.installers/master/dist/jpm-setup.exe) and install.
2. Install damascus.jar with jpm as follows. ```jpm install https://github.com/yasuflatland-lf/damascus/raw/master/latest/damascus.jar```

### How to use
Let's make a Todo app with damascus
1. Create a Liferay workspace with Blade cli or Liferay IDE / Liferay Developer Studio. For more details, please see https://dev.liferay.com/develop/tutorials/-/knowledge_base/7-0/blade-cli
2. After creating Liferay workspace, navigate to under ```modules``` folder and run ```damascus -init Todo -p com.liferay.sb.test -v 70```
3. Navigate to ```Todo``` folder. You'll see ```base.json``` file is created. For detailed configuration, please consult to https://github.com/yasuflatland-lf/damascus/wiki Just for demonstration now, we'll create a scaffolding as it is.
4. Type ```damascus -create``` and damascus will create a scaffolding service and portlet according to the base.json file.
5. Start up your Liferay server and in the ```Todo``` folder, type ```blade deploy```. Blade will run properly and service and portlet will be deployed.

---

Damascus is named after "Damascus blade", which is a strong / sharp blade made out from Damascus steel and forged with a lost technology. Liferay has it's official development tool,"Blade", so I gave this name in hope of reinforcement or extension of Blade tool. 