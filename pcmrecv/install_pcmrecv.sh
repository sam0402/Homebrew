#!/bin/bash
echo "🎵 Installing Pcmrecv ..."
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/pcmrecv/pcmrecv -o /Applications/pcmrecv
sudo chmod +x /Applications/pcmrecv

# Download and configure LaunchAgent plist
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/pcmrecv/com.pcmrecv.start.plist -o ~/Library/LaunchAgents/com.pcmrecv.start.plist

# Load and start the LaunchAgent
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.pcmrecv.start.plist
launchctl enable gui/$(id -u)/com.pcmrecv.start
launchctl kickstart -k gui/$(id -u)/com.pcmrecv.start

echo "✅ pcmrecv installation and setup complete."
