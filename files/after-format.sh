RED='\033[0;31m'
Green='\033[0;32m'
Yellow="\[\033[0;33m\]"
BG_CYAN="\e[40;96m"
CYAN="\e[96m"
NC='\033[0m'

#Check jq
if ! command -v jq &>/dev/null; then
    echo -n "Installing jq..."
    sudo snap install jq &>/dev/null && echo -e "${Green}[DONE]" ${NC} || echo -e "${RED}There was an error loading jq."
fi

#Net Connection
echo
echo -e "${BG_CYAN}---------Checking your Internet connection" ${NC}
echo

nc -z 1.1.1.1 53  >/dev/null 2>&1
online=$?
if [ $online -eq 0 ]; then
    echo -n "The network is up..."
	echo -e "${Green}[DONE]" ${NC}
else
    echo -e "The network is down..." ${RED}
		exit
fi
echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -n "DNS resolve is up..."
	echo -e "${Green}[DONE]" ${NC}
else
    echo -n "DNS not resolved..."
	echo -e "${RED}[WARNING]" ${NC}
		exit
fi
echo

#System Setting
echo -e "${BG_CYAN}---------System Settings" ${NC}
echo

echo -n "Setting Resolution..."
sleep 1
xrandr -s 1920x1080 &> /dev/null
echo -e "${Green}[DONE]" ${NC}
echo

#Set dark theme
if ! command -v gnome-tweaks &>/dev/null; then
    echo -n "Installing GNOME Tweaks..."
    sudo apt install "gnome-tweaks" -y &>/dev/null && echo -e "${Green}[DONE]${NC}" || echo -e "${RED}[FAILED]${NC}"
fi

if gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' &>/dev/null; then
	echo -n "Setting Dark theme..."
    echo -e "${Green}[DONE]${NC}"
else
    echo -e "${RED}[FAILED]${NC}"
fi
echo

#System Update
echo -e "${BG_CYAN}---------System Updating" ${NC}
echo
echo -n "System Updating..."
{
    sleep 1
    wget -qO- https://updates.signal.org/desktop/apt/keys.asc | sudo apt-key add - >/dev/null 2>&1
    echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list >/dev/null 2>&1
    apt install apt-transport-https curl -y > /dev/null 2>&1
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg >/dev/null 2>&1
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null 2>&1
    echo | sudo add-apt-repository multiverse >/dev/null 2>&1
    wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add - >/dev/null 2>&1
    echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list >/dev/null 2>&1
    sudo apt-get -qq update
	
	
} >/dev/null 2>&1

echo -e "${Green}[DONE]" ${NC}
echo -n "System Upgrading..."
{
sudo apt-get -qq upgrade -y >/dev/null 2>&1

} >/dev/null 2>&1

#Install Softwares
echo -e "${Green}[DONE]" ${NC}
echo
echo -e "${BG_CYAN}---------Installing Softwares" ${NC}
echo
echo -n "Installing vMware Workstation..."
sleep 1
apt install gcc build-essential -y > /dev/null 2>&1
cd /tmp
wget https://download3.vmware.com/software/wkst/file/VMware-Workstation-Full-16.1.2-17966106.x86_64.bundle >/dev/null 2>&1
chmod +x VMware-Workstation-*.bundle
./VMware-Workstation-*.bundle >/dev/null 2>&1
cd /

echo -e "${Green}[DONE]" ${NC}

curl -sS -H "Content-Type: application/json; charset=utf-8" https://raw.githubusercontent.com/caglaryalcin/linux-scripts/main/files/packages.json -o packages.json

function read_packages_from_json() {
    local url="$1"
    wget -qO- "$url" | jq -r '.packages[]'
}

url="https://raw.githubusercontent.com/caglaryalcin/linux-scripts/main/files/packages.json"

read_packages_from_json "$url" | while read -r package; do
    echo -n "Installing $package..."
    if ! dpkg -l | grep -q "^ii.*$package" > /dev/null 2>&1; then
        if apt install "$package" -y > /dev/null 2>&1; then
            echo -e "${Green}[DONE]${NC}"
        else
            echo -e "\n${RED}[FAILED]${NC}"
        fi
    else
        echo -e "${Green}[${package} is already installed.]${NC}"
    fi
done

rm -rf dark.sh
