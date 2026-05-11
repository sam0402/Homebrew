#!/bin/bash
echo "🎵 Installing MPD ..."
homebrew install flac
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/squeezelite/squeezelite -o /Applications/squeezelite
sudo chmod +x /Applications/squeezelite

# Download and configure LaunchAgent plist
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/squeezelite/com.squeezelite.start.plist -o ~/Library/LaunchAgents/com.squeezelite.start.plist

# Load and start the LaunchAgent
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.squeezelite.start.plist
launchctl enable gui/$(id -u)/com.squeezelite.start
launchctl kickstart -k gui/$(id -u)/com.squeezelite.start

echo "✅ squeezelite installation and setup complete."
