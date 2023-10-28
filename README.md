# Time Machine Bedtime

A launchd daemon to disable macOS Time Machine in the night to prevent broken backups. I created this because my Macbook uses a Synology NAS to store backups via SMB. The NAS is being shut down during the night and the abrupt connection loss when the NAS shuts down has led to several corrupted backups.

Actually, it's two daemons: one to pause the Time Machine at 23:00, and one to start it again at 8:30.

## Installation

The installation will prompt for a password, as the launchd daemon has to be installed on a system level.

```
git clone https://github.com/Kovah/timemachine-bedtime.git
cd timemachine-bedtime

./install.sh
```

### Full Disk Access for Bash

Unfortunately, there is one step missing in the script which can't be automated. Due to the macOS security system, the used tmutil command needs access to the full disk. As Bash (`/bin/bash`) is the program which runs `tmutil`, Bash needs this permission.

To do so, 
- open your Finder, 
- press `Cmd`+`Shift`+`.` to show hidden files, 
- then go to Macintosh HD (or whatever your hard drive is named) and then `/bin`
- open System Settings > Privacy & Security > Full Disk Access and pull the `bash` application from the Finder to the list of apps in the system settings

## Uninstall

```
./uninstall.sh
```

If the script fails, the following files and directories are used to install the daemon:

- `/usr/local/scripts/de.kovah.timemachine-bedtime`
  - `good-morning.sh`
  - `good-night.sh`
  - `activity.log`
- `/Library/LaunchDaemons/de.kovah.timemachine-bedtime.good-morning.plist`
- `/Library/LaunchDaemons/de.kovah.timemachine-bedtime.good-night.plist`

## Thanks

Thanks to [Thomas Krampe](https://www.thomas-krampe.com/2023/09/verwenden-von-launchd-zur-ausfuehrung-von-skripten-in-macos/) for his detailed article on launchd agents and daemons. Helped a lot to quickly put this together.
