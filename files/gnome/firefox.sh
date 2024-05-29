#!/bin/bash

# URLs
userjs="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/user.js"
tabshapescss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/Tab%20Shapes.css"
toolbarcss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/Toolbar.css"
usercontentcss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/userContent.css"
userchromecss="https://raw.githubusercontent.com/caglaryalcin/my-configs/main/softwares/browser-conf/appearance/userChrome.css"

# Find the default Firefox profile directory
userProfileDir=$(find ~/.mozilla/firefox -type d -name "*.default-release")

if [[ -z "$userProfileDir" ]]; then
    echo "[ERROR] Firefox default profile directory not found."
    exit 1
fi

# Create chrome directory inside the profile directory
mkdir -p "$userProfileDir/chrome"

# Download files
declare -A configUrls=(
    ["user.js"]=$userjs
    ["Tab Shapes.css"]=$tabshapescss
    ["Toolbar.css"]=$toolbarcss
    ["userContent.css"]=$usercontentcss
    ["userChrome.css"]=$userchromecss
)

for file in "${!configUrls[@]}"; do
    if [[ "$file" == "user.js" ]]; then
        wget -q -O "$userProfileDir/$file" "${configUrls[$file]}"
    else
        wget -q -O "$userProfileDir/chrome/$file" "${configUrls[$file]}"
    fi

    if [[ $? -ne 0 ]]; then
        echo "[WARNING] Failed to download $file from ${configUrls[$file]}"
    else
        echo "[INFO] Successfully downloaded $file to $userProfileDir"
    fi
done

# Add Desktop to favorites in Nautilus
username=$(whoami)
bookmark_file="/home/$username/.config/gtk-3.0/bookmarks"

# Ensure the bookmarks file exists
mkdir -p $(dirname "$bookmark_file")
touch "$bookmark_file"

# Add Desktop to the bookmarks if not already present
if ! grep -q "file:///home/$username/Desktop" "$bookmark_file"; then
    echo "file:///home/$username/Desktop Desktop" >> "$bookmark_file"
    echo "[INFO] Added Desktop to Nautilus bookmarks"
else
    echo "[INFO] Desktop is already in Nautilus bookmarks"
fi

# Create distribution and extensions directories inside the profile directory
distributionDir="$userProfileDir/distribution"
extensionsDir="$distributionDir/extensions"

mkdir -p "$extensionsDir"

# Download and install the Bitwarden add-on
addonName="bitwarden-password-manager"
addonId="{446900e4-71c2-419f-a6a7-df9c091e268b}"
addonUrl="https://addons.mozilla.org/firefox/downloads/latest/$addonName/addon-$addonName-latest.xpi"
addonPath="$extensionsDir/$addonId.xpi"

if wget -q -O "$addonPath" "$addonUrl"; then
    echo "[INFO] Successfully downloaded Bitwarden add-on to $addonPath"
else
    echo "[ERROR] Failed to download Bitwarden add-on" >&2
fi
