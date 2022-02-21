RED='\033[0;31m'
Green='\033[0;32m'
NC='\033[0m'
echo "${Green}Checking your Internet connection.."${NC}
nc -z 1.1.1.1 53  >/dev/null 2>&1
online=$?
if [ $online -eq 0 ]; then
    echo "${Green}The network is up"
else
    echo "${RED}The network is down"
		exit
fi
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "DNS resolve is up"
else
    echo "DNS not resolved"
		exit
fi

echo "${Green}Setting Resolution.."${NC}
sleep 1
xrandr -s 1920x1080 &> /dev/null

echo "${Green}System Updating.."${NC}
sleep 1
add-apt-repository multiverse
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add - >/dev/null 2>&1
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null
wget -nc https://dl.winehq.org/wine-builds/winehq.key >/dev/null 2>&1
apt-key add winehq.key >/dev/null 2>&1
add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' >/dev/null 2>&1
sudo apt-get -qq update && sudo apt-get -qq upgrade -y >/dev/null 2>&1

echo "${Green}Installing vMware Workstation.."${NC}
sleep 1
apt install gcc build-essential -y > /dev/null 2>&1
cd /tmp
wget https://download3.vmware.com/software/wkst/file/VMware-Workstation-Full-16.1.2-17966106.x86_64.bundle >/dev/null 2>&1
chmod +x VMware-Workstation-*.bundle
./VMware-Workstation-*.bundle >/dev/null 2>&1
cd /

echo "${Green}Installing Wine.."${NC}
apt update >/dev/null 2>&1
apt install --install-recommends winehq-stable -y >/dev/null 2>&1

echo "${Green}Installing libreoffice, thunderbird, putty, steam, anydesk, flameshot, sublime-text, vlc, filezilla, deluge and gparted.."${NC}
packages="libreoffice thunderbird putty steam anydesk flameshot sublime-text vlc filezilla deluge gparted"
for i in $packages; do
  sudo apt install -y $i > /dev/null 2>&1
done
