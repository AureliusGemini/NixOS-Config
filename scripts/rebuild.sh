#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/nixos-config"
cd "$CONFIG_DIR"

# Clean up build output symlink on exit
trap 'rm -f "$CONFIG_DIR/result"' EXIT

echo "🔄 Flake Update Check"
read -rp "🌐 Do you want to update flake inputs? (y/N): " update_inputs

if [[ "$update_inputs" =~ ^[Yy]$ ]]; then
    echo "⬇️ Updating flake inputs..."
    nix flake update
    echo "✨ Flake inputs updated successfully!"
else
    echo "⏭️ Skipping flake input updates."
fi

echo "📦 Staging configuration files..."
git add .

COMMITTED=false
if ! git diff --staged --quiet; then
    echo "📝 Uncommitted changes detected!"
    read -rp "✍️ Enter a commit message (or press Enter for auto-message): " commit_msg

    if [ -z "$commit_msg" ]; then
        commit_msg="System update & flake sync: $(date +'%Y-%m-%d %H:%M')"
    fi

    git commit -m "$commit_msg"
    echo "✅ Committed: $commit_msg"
    COMMITTED=true
else
    echo "🤷 No new configuration changes to commit."
fi

echo "🚀 Pre-building NixOS configuration..."
nix build .#nixosConfigurations.nixos.config.system.build.toplevel \
    --option download-attempts 10 \
    --option connect-timeout 20 \
    --fallback

echo "⚡ Applying configuration and updating bootloader generations..."
sudo nixos-rebuild switch --flake .#nixos --fallback

# --- Push to GitHub Prompt ---
echo ""
read -rp "🚀 Do you want to push commits to GitHub? (y/N): " push_github

if [[ "$push_github" =~ ^[Yy]$ ]]; then
    echo "⬆️ Pushing changes to remote repository..."
    # Attempt pushing current branch (defaults to main)
    CURRENT_BRANCH=$(git branch --show-current)
    if git push origin "$CURRENT_BRANCH"; then
        echo "✨ Successfully pushed to GitHub ($CURRENT_BRANCH)!"
    else
        echo "⚠️ Git push failed! Please check your SSH keys or network connection."
    fi
else
    echo "⏭️ Skipping GitHub push."
fi

echo ""
read -rp "🗑️ Run Garbage Collection? (1: Keep last 14 days, 2: Wipe all old, N: Skip): " gc_choice

case "$gc_choice" in
    1)
        echo "🧹 Cleaning generations older than 14 days..."
        sudo nix-collect-garbage --delete-older-than 14d
        echo "✨ Cleaned while preserving recent rollback options!"
        ;;
    2)
        echo "🧹 Deleting ALL historical generations..."
        sudo nix-collect-garbage -d
        echo "✨ System cleaned!"
        ;;
    *)
        echo "⏭️ Skipping garbage collection. Rollbacks preserved."
        ;;
esac

echo "✅ All tasks completed successfully!"
