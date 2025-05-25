#!/usr/bin/env bash
# Update Nix flake inputs, rebuild system, and auto-backup config to GitHub
# Usage: Place in /etc/nixos/bin/update-flake.sh and run manually or via cron/systemd

set -euo pipefail
cd /etc/nixos

echo "[Updating flake inputs...]"
nix flake update

echo "Rebuilding NixOS system..."
nixos-rebuild switch --flake .#nixos

# Optionally, auto-backup after update
if [[ -x /etc/nixos/bin/backup.sh ]]; then
  echo "[Running backup...]"
  /etc/nixos/bin/backup.sh
fi

echo "[Update and backup complete.]"
