#!/bin/bash
set -e

/usr/bin/tmutil stopbackup
/usr/bin/tmutil disable

echo "[$(date +"%Y-%m-%dT%H:%M:%S%z")] Time Machine backups stopped and disabled"
