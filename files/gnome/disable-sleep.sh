#!/bin/bash

set -e

# Editing logind.conf to disable sleep mode
sudo sed -i 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#HandleLidSwitchDocked=suspend/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/^#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf

# Add or update the IdleAction line
if grep -q "^IdleAction=" /etc/systemd/logind.conf; then
    sudo sed -i 's/^IdleAction=.*/IdleAction=ignore/' /etc/systemd/logind.conf
else
    echo "IdleAction=ignore" | sudo tee -a /etc/systemd/logind.conf
fi

# restart systemd-logind service
sudo systemctl restart systemd-logind

# Disable Suspend and Hibernate targets
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

#!/bin/bash

gsettings set org.gnome.desktop.screensaver lock-enabled false #automatic screen
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false #screen and suspend
gsettings set org.gnome.desktop.session idle-delay 0 #delaty
gsettings set org.gnome.desktop.screensaver lock-delay 0 #screensaver

echo "Automatic Screen Lock and Lock Screen on Suspend have been disabled."


echo "[INFO] Sleep mode is disabled."
