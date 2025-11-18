#!/bin/bash
set -e  # stop on error

echo "🍺 Installing upmpdclit dependencies..."
brew install libmpdclient expat libmicrohttpd jsoncpp
pip3 install requests bottle mutagen waitress pyradios
# python-dateutil for BBC Sounds plugin
# pip3 install python-dateutil

if [ -n "$ZSH_VERSION" ]; then
    read "ans?📦 Install TIDAL support (tidalapi)? (Y/n): "
else
    read -p "📦 Install TIDAL support (tidalapi)? (Y/n): " ans
fi

ans=${ans:-Y}
if [[ "$ans" =~ ^[Yy]$ ]]; then
    echo "🎧 Installing tidalapi..."
    pip3 install tidalapi
else
    echo "⏭️ Skipping tidalapi installation..."
fi

echo "🎵 Installing upmpdcli ..."
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/upmpdcli/upmpdcli-1.9.7.tar.gz | tar -xzf - -C /opt
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/upmpdcli/upmpdcli.conf-xml -o /opt/homebrew/share/upmpdcli/upmpdcli.conf-xml
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/upmpdcli/upmpdcli-config.tar.gz | tar -xzf - -C $HOME/Applications

echo "📁 Creating upmpdcli configuration folder..."
if ! [ -f $HOME/.mpd/upmpdcli.conf ]; then
    echo "⚙️ Creating $HOME/.mpd/upmpdcli.conf..."
    curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/upmpdcli/upmpdcli.conf -o $HOME/.mpd/upmpdcli.conf
fi

echo "🧩 Installing LaunchAgent for auto-start..."
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/upmpdcli/com.upmpdcli.start.plist -o ~/Library/LaunchAgents/com.upmpdcli.start.plist
sed -i '' "s|HOME|$HOME|g" $HOME/Library/LaunchAgents/com.upmpdcli.start.plist

echo "🚀 Starting upmpdcli service..."
launchctl bootstrap gui/$(id -u) $HOME/Library/LaunchAgents/com.upmpdcli.start.plist || true
launchctl enable gui/$(id -u)/com.upmpdcli.start || true
launchctl kickstart -k gui/$(id -u)/com.upmpdcli.start || true

echo "✅ upmpdcli installation complete!"
