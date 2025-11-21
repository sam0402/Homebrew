#!/bin/bash
# Install dependencies
brew install sqlite
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/ffmpeg-8.0.1.tar.gz | tar xf - -C /opt/homebrew/Cellar
brew link ffmpeg
pip3 install python-mpd2

# Install blissify and its components
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify -o /usr/local/bin/blissify
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.py -o /usr/local/bin/blissify.py
sudo chmod +x /usr/local/bin/blissify*

# Download blissify configuration
mkdir -p ~/.mpd
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

if [ -n "$ZSH_VERSION" ]; then
    read "ans?Do you want to initialize and analyze your MPD library? [Y/n]: "
else
    read -p "Do you want to initialize and analyze your MPD library? [Y/n]: " ans
fi

ans=${ans:-Y}
if [[ "$ans" =~ ^[Yy]$ ]]; then
    echo "Running blissify update..."
    blissify update -c ~/.mpd/blissify.conf || echo "⚠️ Failed to run blissify update."
else
    echo "Skipped blissify initialization"
fi
