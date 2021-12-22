## Description

Contains various automated scripts for Linux..

<details><summary>Install Mirth & pgAdmin4</summary>&nbsp;

Download script with wget.

```
wget https://raw.githubusercontent.com/caglaryalcin/linux-scripts/main/scripts/pg4-mirth.sh
```
Before running, you must give run permission with the following command.
```
sudo chmod +x pg4-mirth.sh
```
```
sudo ./pg4-mirth.sh
```

This script does exactly the following;

- Checks your internet
- System update & upgrade
- Install http-tools
- Install mirth connect
- Install pgAdmin4
- Set user passwords for pgadmin & mirth


> **_NOTE:_**  After the ubuntu-based distro's is first setup, you can install Mirth Connect and pgAdmin4 in with this script.
<p>
</details>
