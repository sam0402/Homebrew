#!/bin/bash
# Install dependencies
brew install ffmpeg sqlite
pip3 install python-mpd2

# Install blissify and its components
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify -o /usr/local/bin/blissify
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.py -o /usr/local/bin/blissify.py
sudo chmod +x /usr/local/bin/blissify*

# Download blissify configuration
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.conf -o ~/.mpd/blissify.conf

# Get MPD music directory from mpd.conf
MDIR=$(grep "^music_directory" ~/.mpd/mpd.conf | cut -d'"' -f2)

# Replace HOME and default music path in configuration
sed -i '' "s|HOME|$HOME|g; s|~/Music|$MDIR|g" ~/.mpd/blissify.conf

# Download and configure LaunchAgent plist
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/com.blissify.start.plist -o ~/Library/LaunchAgents/com.blissify.start.plist
sed -i '' "s|HOME|$HOME|g" ~/Library/LaunchAgents/com.blissify.start.plist

# Load and start the LaunchAgent
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.blissify.start.plist
launchctl enable gui/$(id -u)/com.blissify.start
launchctl kickstart -k gui/$(id -u)/com.blissify.start

echo "✅ Blissify installation and setup complete."
