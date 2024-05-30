#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run the script as root user: sudo $0"
  exit 1
fi

sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y dbus-x11 >/dev/null 2>&1

echo -n "Disabling sleep mode settings..."
if sudo sed -i 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf && \
   sudo sed -i 's/^#HandleLidSwitchDocked=suspend/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf && \
   sudo sed -i 's/^#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf; then
    echo "[OK]"
else
    echo "[WARNING]"
fi

echo -n "Adding or updating the IdleAction line..."
if sudo grep -q "^IdleAction=" /etc/systemd/logind.conf; then
    if sudo sed -i 's/^IdleAction=.*/IdleAction=ignore/' /etc/systemd/logind.conf; then
        echo "[OK]"
    else
        echo "[WARNING]"
    fi
else
    if echo "IdleAction=ignore" | sudo tee -a /etc/systemd/logind.conf; then
        echo "[OK]"
    else
        echo "[WARNING]"
    fi
fi

echo -n "Disabling Suspend and Hibernate targets..."
if sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target; then
    echo "[OK]"
else
    echo "[WARNING]"
fi

echo -n "Creating Firefox profile..."
sudo -u $SUDO_USER firefox -headless &
sleep 10
pkill -u $SUDO_USER firefox
echo "[OK]"

userjs="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/user.js"
tabshapescss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/Tab%20Shapes.css"
toolbarcss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/Toolbar.css"
usercontentcss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/userContent.css"
userchromecss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/userChrome.css"

profile_path=$(sudo find /home/$SUDO_USER/.mozilla/firefox/ -type d -name "*.default-release" | head -n 1)

if [ -z "$profile_path" ]; then
    echo "Firefox profile not found"
    exit 1
fi

sudo mkdir -p "$profile_path/chrome"

firefox_errors=""

echo -n "Restoring Firefox settings..."
if ! sudo curl -s "$userjs" -o "$profile_path/user.js"; then
    firefox_errors+=" user.js"
fi
if ! sudo curl -s "$tabshapescss" -o "$profile_path/chrome/Tab%20Shapes.css"; then
    firefox_errors+=" Tab Shapes.css"
fi
if ! sudo curl -s "$toolbarcss" -o "$profile_path/chrome/Toolbar.css"; then
    firefox_errors+=" Toolbar.css"
fi
if ! sudo curl -s "$usercontentcss" -o "$profile_path/chrome/userContent.css"; then
    firefox_errors+=" userContent.css"
fi
if ! sudo curl -s "$userchromecss" -o "$profile_path/chrome/userChrome.css"; then
    firefox_errors+=" userChrome.css"
fi

for file in "$profile_path/user.js" "$profile_path/chrome/Tab%20Shapes.css" "$profile_path/chrome/Toolbar.css" "$profile_path/chrome/userContent.css" "$profile_path/chrome/userChrome.css"; do
    if [ ! -f "$file" ]; then
        firefox_errors+=" $(basename $file)"
    fi
done

if [ -z "$firefox_errors" ]; then
    echo "[OK]"
else
    echo "[WARNING]: $firefox_errors"
fi

# gnome.sh
echo -n "Adjusting GNOME settings..."
if sudo dbus-launch gsettings set org.gnome.desktop.screensaver lock-enabled false && \
   sudo dbus-launch gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false && \
   sudo dbus-launch gsettings set org.gnome.desktop.session idle-delay 0 && \
   sudo dbus-launch gsettings set org.gnome.desktop.screensaver lock-delay 0; then
    echo "[OK]"
else
    echo "[WARNING]"
fi
