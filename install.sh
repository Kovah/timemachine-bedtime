#!/bin/bash
set -e

SCRIPT_DIR="/usr/local/scripts/de.kovah.timemachine-bedtime"
DAEMON_DIR="/Library/LaunchDaemons"

if [ -d "$SCRIPT_DIR" ]; then
  echo 'Launch agents are already installed. Run ./uninstall.sh to remove them.'
  exit 1
fi

read -p "This script will use sudo to install a LaunchDaemon. You might get a password prompt. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Copying scripts to $SCRIPT_DIR/ and launch daemons to $DAEMON_DIR/..."
sudo mkdir -p $SCRIPT_DIR

sudo cp ./good-night.plist "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-night.plist"
sudo cp ./good-night.sh "$SCRIPT_DIR/good-night.sh"
sudo chmod +x "$SCRIPT_DIR/good-night.sh"

sudo cp ./good-morning.plist "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-morning.plist"
sudo cp ./good-morning.sh "$SCRIPT_DIR/good-morning.sh"
sudo chmod +x "$SCRIPT_DIR/good-morning.sh"

sudo touch "$SCRIPT_DIR/activity.log"

echo "> Done"

# See https://superuser.com/a/1462352/180708 for details
echo "Prevent Time Machine asking for alternative disks..."
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
echo "> Done"

echo "Enabling the launch daemons..."
sudo launchctl load -w "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-night.plist" "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-morning.plist"
echo "> Done"

echo "Installation complete!"
echo "Logs can be found at $SCRIPT_DIR/activity.log"
echo
echo -e "CAUTION: you need to give /bin/bash Full Disk Access for this to work."
echo -e "Open /bin in Finder and drag bash to the application list under System Settings > Privacy & Security > Full Disk Access."
