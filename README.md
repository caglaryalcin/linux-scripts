# Linux Scripts

## Description

Contains various automated scripts for Linux..


1. [Install Mirth & pgAdmin4](https://github.com/caglaryalcin/linux-scripts/blob/main/scripts/pg4-mirth-last.sh)
   - [Mirth Last Ver. with Admin Launcher 1.2.0 & pgAdmin4](https://github.com/caglaryalcin/linux-scripts#mirth-connect-last-ver-with-administrator-launcher-120-pgadmin4-last-ver)
     - Second nested list item

### Install Mirth & pgAdmin4 

Before running, you must give run permission with the following command.

```
wget https://github.com/caglaryalcin/linux-scripts/blob/main/scripts/pg4-mirth-last.sh
```
```
sudo chmod +x pg4-mirth-last.sh
```
```
sudo ./pg4-mirth-last.sh
```

This script does exactly the following;

- Checks your internet
- System update & upgrade
- Install vmware from iso & vmware-tools
- Install http tools
- Install mirth connect last version
- Install pgAdmin4
- Set user passwords


> **_NOTE:_**  After the ubuntu-based distro's is first setup, you can install Mirth Connect and pgAdmin4 in with this script.

### Mirth Last Ver. with Admin Launcher 1.2.0 & pgAdmin4

Before running, you must give run permission with the following command.

```
wget https://github.com/caglaryalcin/linux-scripts/blob/main/scripts/pg4-mirth-adm-launc-1.2.0.sh
```
```
sudo chmod +x pg4-mirth-adm-launc-1.2.0.sh
```
```
sudo ./pg4-mirth-adm-launc-1.2.0.sh
```

This script does exactly the following;

- Checks your internet
- System update & upgrade
- Install vmware from iso & vmware-tools
- Install http tools
- Install mirth connect 3.12.0 & administrator launcher 1.2.0
- Install pgAdmin4
- Set user passwords


> **_NOTE:_**  After the ubuntu-based distro's is first setup, you can install Mirth Connect and pgAdmin4 in with this script. .When installing mirth, uncheck administrator launcher. After that, the installation for version 1.2.0 will start.

![image](https://github.com/caglaryalcin/linux-scripts/blob/main/screenshots/uncheck.png)
