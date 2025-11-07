#!/bin/bash
set -e  # stop on error

echo "🔧 Installing Homebrew (skipping if already installed)..."
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed, skipping."
fi

echo "🍺 Installing MPD dependencies..."
brew install fmt libid3tag faad2 expat lame libmad libsndfile
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/flac-143.tar.bz2 | tar jxvf - -C /opt/homebrew/Cellar
brew link flac@1.4.3
cd /opt/homebrew/opt/
ln -s flac@1.4.3 flac
cd -

echo "🎵 Installing MPD ..."
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/mpd-0.23.17 -o /Applications/mpd
sudo chmod +x /Applications/mpd

echo "📁 Creating MPD configuration folder..."
mkdir -p ~/.mpd/playlists

if ! [ -f ~/.mpd/mpd.conf ]; then
    echo "⚙️ Downloading mpd.conf..."
    curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/mpd-streamp3/mpd.conf -o ~/.mpd/mpd.conf
fi

echo "🧩 Installing LaunchAgent for auto-start..."
mkdir -p ~/Library/LaunchAgents
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/com.mpd.start.plist -o ~/Library/LaunchAgents/com.mpd.start.plist

echo "🚀 Starting MPD service..."
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.mpd.start.plist || true
launchctl enable gui/$(id -u)/com.mpd.start || true
launchctl kickstart -k gui/$(id -u)/com.mpd.start || true

echo "✅ MPD installation complete!"