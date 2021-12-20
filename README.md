# Linux Scripts

## Description

Contains various automated scripts for Linux..

## Mirth connect last ver. with Administrator Launcher 1.2.0, pgAdmin4 last ver.

After the ubuntu-based distro's is first setup, you can install Mirth Connect and pgAdmin4 in with this script.

Before running, you must give run permission with the following command.

```
wget https://github.com/caglaryalcin/linux-scripts/blob/main/pg4-mirth-adm-launcher-1.2.0.sh
```
```
sudo chmod +x pg4-mirth.sh
```
```
sudo ./pg4-mirth.sh
```

This script does exactly the following;

- Checks your internet
- System update & upgrade
- Install vmware from iso & vmware-tools
- Install http tools
- Install mirth connect 3.12.0 & administrator launcher 1.2.0
- Install pgAdmin4
- Set user passwords


> **_NOTE:_**  When installing mirth, uncheck administrator launcher. After that, the installation for version 1.2.0 will start.

![image](https://github.com/caglaryalcin/linux-scripts/blob/main/uncheck.png)
