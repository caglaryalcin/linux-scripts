RED='\033[0;31m'
Green='\033[0;32m'
NC='\033[0m'
echo "${Green}Checking your Internet connection.."${NC}
sleep 2
nc -z 1.1.1.1 53  >/dev/null 2>&1
online=$?
if [ $online -eq 0 ]; then
    echo "${Green}The network is up"
	sleep 1
else
    echo "${RED}The network is down"
	exit
fi
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "DNS resolve is up"
	sleep 2
else
    echo "DNS not resolved"
	exit
fi
echo "${Green}System updating.."${NC}
sleep 1
apt update && apt upgrade -y
echo "\e[1;32m Installing vmware tools.. \e[0m"
apt install -y open-vm-tools
apt install -y open-vm-tools-desktop
curl -J -O https://fujifilm.cloud/index.php/s/SJPKZ4RYrp7treB/download
tar -zxvf VMwareTools-10.3.2-9925305.tar.gz
cd vmware-tools-distrib
./vmware-install.pl -d
echo "${Green}Installing https tools.."${NC}
sleep 1
apt install -y ca-certificates
apt install -y apt-transport-https
echo "${Green}Mirth downloading.."${NC}
sleep 1
wget http://downloads.mirthcorp.com/connect/3.12.0.b2650/mirthconnect-3.12.0.b2650-unix.sh
wget https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-1.2.0-unix.sh
echo "${Green}Installing mirth.. "
printf "\033[31;5mUncheck Mirt Connect Administrator Launcher during installation(If you want latest version, don't mind it)\033[0m"${NC}
sleep 5
chmod +x mirthconnect-3.12.0.b2650-unix.sh
./mirthconnect-3.12.0.b2650-unix.sh
echo "${Green}Installing the Administrator Launcher stable version.."${NC}
sleep 1
chmod +x mirth-administrator-launcher-1.2.0-unix.sh
./mirth-administrator-launcher-1.2.0-unix.sh
echo "${Green}Installing pgAdmin4.."${NC}
apt install -y postgresql postgresql-contrib
sleep 1
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/focal pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update' -y
apt install -y pgadmin4
sleep 1
apt install -y pgadmin4-desktop
sleep 1
apt install -y pgadmin4-web
sleep 1
echo "${Green}Configure the webserver to '/usr/pgadmin4/bin/setup-web.sh', if you installed pgadmin4-web"${NC}
echo "${Green}Deleting setup files.."${NC}
rm -rf mirthconnect-3.12.0.b2650-unix.sh
sleep 1
rm -rf mirth-administrator-launcher-1.2.0-unix.sh
echo "${Green}Setting passwords.. "${NC}
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'admin';"
echo "pgAdmin default password:${Green}admin${NC}"
echo "Mirth default user:${Green}admin${NC} password:${Green}admin${NC}"
echo "'${Green}admin${NC}' password has been set for ${Green}postgres${NC} user"
