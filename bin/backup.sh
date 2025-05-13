#!/usr/bin/env bash
# Auto-update and push NixOS config to GitHub for backup
# Usage: Place in /etc/nixos/bin/backup.sh and run manually or via cron/systemd

set -euo pipefail
cd /etc/nixos

if [[ -n $(git status --porcelain) ]]; then
  git add -A
  git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')"
fi

git pull --rebase

git push git@github.com-ag:AureliusGemini/NixOS-Config master
