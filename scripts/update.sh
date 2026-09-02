#!/usr/bin/env bash
set -e

CONFIG_DIR="$HOME/nixos-config"
cd "$CONFIG_DIR"

echo "🔄 Flake Update Check"
read -p "🌐 Do you want to update flake inputs? (y/N): " update_inputs

if [[ "$update_inputs" =~ ^[Yy]$ ]]; then
    echo "⬇️ Updating flake inputs..."
    nix flake update
    echo "✨ Flake inputs updated successfully!"
else
    echo "⏭️ Skipping flake input updates."
fi

echo "📦 Staging configuration files..."
git add .

if ! git diff --staged --quiet; then
    echo "📝 Uncommitted changes detected!"
    read -p "✍️ Enter a commit message (or press Enter for auto-message): " commit_msg

    if [ -z "$commit_msg" ]; then
        commit_msg="System update & flake sync: $(date +'%Y-%m-%d %H:%M')"
    fi

    git commit -m "$commit_msg"
    echo "✅ Committed: $commit_msg"
fi

echo "🚀 Pre-building NixOS configuration (downloading packages)..."
# Builds derivation safely with resilient network settings
nix build .#nixosConfigurations.nixos.config.system.build.toplevel \
    --option download-attempts 10 \
    --option connect-timeout 20

echo "⚡ Applying configuration and updating bootloader generations..."
# Registers the profile generation and activates
sudo nixos-rebuild switch --flake .#nixos --option substitute false

# Clean up local result symlink
rm -f ./result

echo ""
read -p "🗑️ Do you want to run Garbage Collection? (y/N): " run_gc

if [[ "$run_gc" =~ ^[Yy]$ ]]; then
    echo "🧹 Cleaning up old system generations..."
    sudo nix-collect-garbage -d
    echo "✨ System cleaned!"
else
    echo "⏭️ Skipping garbage collection."
fi

echo "✅ All tasks completed successfully!"
