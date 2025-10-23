#!/bin/bash
#
# uninstall_blissify.sh
# Uninstall Blissify and its service (macOS)

set -e

echo "🧽 Uninstalling Blissify and related files..."

# --- Stop LaunchAgent ---
if launchctl list | grep -q "com.blissify.start"; then
    echo "Stopping Blissify LaunchAgent..."
    launchctl bootout gui/$(id -u)/com.blissify.start 2>/dev/null || true
    launchctl disable gui/$(id -u)/com.blissify.start 2>/dev/null || true
fi

# --- Remove LaunchAgent file ---
if [ -f "$HOME/Library/LaunchAgents/com.blissify.start.plist" ]; then
    echo "Removing LaunchAgent plist..."
    rm -f "$HOME/Library/LaunchAgents/com.blissify.start.plist"
fi

# --- Remove Blissify executables ---
if [ -f "/usr/local/bin/blissify" ] || [ -f "/usr/local/bin/blissify.py" ]; then
    echo "Removing /usr/local/bin/blissify* ..."
    sudo rm -f /usr/local/bin/blissify /usr/local/bin/blissify.py
fi

# --- Remove Blissify configuration ---
if [ -f "$HOME/.mpd/blissify.conf" ]; then
    echo "Removing ~/.mpd/blissify.conf..."
    rm -f "$HOME/.mpd/blissify.conf"
fi

# --- Optional: uninstall dependencies ---
read -p "Do you also want to uninstall Homebrew and Python dependencies (ffmpeg, sqlite, python-mpd2)? [y/N]: " ans
if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
    echo "Removing Homebrew packages..."
    brew uninstall --ignore-dependencies ffmpeg sqlite 2>/dev/null || true
    echo "Removing Python package python-mpd2..."
    pip3 uninstall -y python-mpd2 2>/dev/null || true
fi

echo "✅ Blissify and its service have been removed successfully."