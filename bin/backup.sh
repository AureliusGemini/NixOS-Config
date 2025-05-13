#!/usr/bin/env bash
# Auto-update and push NixOS config to GitHub for backup
# Usage: Place in /etc/nixos/bin/backup.sh and run manually or via cron/systemd

set -euo pipefail
cd /etc/nixos

git pull --rebase
if [[ -n $(git status --porcelain) ]]; then
  git add -A
  git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')"
  # Push to personal GitHub backup repo using github.com-ag alias only
  git push git@github.com-ag:AureliusGemini/NixOS-Config master
else
  echo "No changes to commit."
fi
