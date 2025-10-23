#!/bin/bash
#
# uninstall_mpd.sh
# Uninstall MPD and its service (macOS)

set -e

echo "🧹 Uninstalling MPD and related files..."

# --- Stop LaunchAgent ---
if launchctl list | grep -q "com.mpd.start"; then
    echo "Stopping MPD LaunchAgent..."
    launchctl bootout gui/$(id -u)/com.mpd.start 2>/dev/null || true
    launchctl disable gui/$(id -u)/com.mpd.start 2>/dev/null || true
fi

# --- Remove LaunchAgent file ---
if [ -f "$HOME/Library/LaunchAgents/com.mpd.start.plist" ]; then
    echo "Removing LaunchAgent plist..."
    rm -f "$HOME/Library/LaunchAgents/com.mpd.start.plist"
fi

# --- Remove MPD binary ---
if [ -f "/Applications/mpd" ]; then
    echo "Removing /Applications/mpd..."
    sudo rm -f /Applications/mpd
fi

# --- Optional: uninstall Homebrew packages ---
if [ -n "$ZSH_VERSION" ]; then
    read "ans?Do you also want to uninstall Homebrew? [y/N]: "
else
    read -p "Do you also want to uninstall Homebrew? [y/N]: " ans
fi

if [[ "$ans" =~ ^[Yy]$ ]]; then
    echo "Uninstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
else
    echo "Skipping Homebrew uninstallation."
fi

echo "✅ MPD and its service have been removed successfully."