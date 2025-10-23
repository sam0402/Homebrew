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
read -p "Do you also want to uninstall Homebrew dependencies (flac, lame, fmt, etc)? [y/N]: " ans
if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
    echo "Removing Homebrew dependencies..."
    brew uninstall --ignore-dependencies fmt libid3tag flac faad2 expat lame libmad libsndfile 2>/dev/null || true
fi

echo "✅ MPD and its service have been removed successfully."