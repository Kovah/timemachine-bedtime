#!/bin/bash
set -e

SCRIPT_DIR="/usr/local/scripts/de.kovah.timemachine-bedtime"
DAEMON_DIR="/Library/LaunchDaemons"

if [ ! -d "$SCRIPT_DIR" ]; then
  echo 'Directory with launch daemons not found.'
  exit 1
fi

read -p "This script will use sudo to install a LaunchDaemon. You might get a password prompt. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Disabling the launch daemons..."
sudo launchctl unload -w "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-night.plist" "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-morning.plist" || true
echo "> Done"

echo "Allow Time Machine asking for alternative disks again..."
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool false
echo "> Done"

echo "Removing $SCRIPT_DIR/..."
sudo rm -r "$SCRIPT_DIR"
sudo rm -r "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-night.plist"
sudo rm -r "$DAEMON_DIR/de.kovah.timemachine-bedtime.good-morning.plist"
echo "> Done"

echo "Uninstal complete"
