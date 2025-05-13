#!/usr/bin/env bash
# Manual NixOS rebuild script
# Usage: Place in /etc/nixos/bin/rebuild.sh and run manually as root

set -euo pipefail
cd /etc/nixos

echo "Rebuilding NixOS system..."
nixos-rebuild switch --flake .#nixos

echo "NixOS rebuild complete."
