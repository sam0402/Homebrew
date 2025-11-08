#!/bin/bash
set -e  # stop on error

echo "🎵 MPD Installation"
echo "============================================="
echo "Select installation version:"
echo "1) MPD 0.23.17 (wav, aiff, w64; Radio: aac, mp3)"
echo "2) MPD +FLAC 0.23.17 (+flac; Radio: +ogg)"
read -p "Enter choice [1-2]: " choice

version="mpd-0.23.17"
if [[ "$choice" == "1" ]]; then
    echo "➡️ Installing MPD 0.23.17..."
    version="mpd-0.23.17"
elif [[ "$choice" == "2" ]]; then
    echo "➡️ Installing MPD 0.23.17 with custom FLAC 1.4.3..."
    version="mpd-flac-0.23.17"
else
    echo "➡️ Installing MPD 0.23.17..."
    version="mpd-0.23.17"
fi

echo "🔧 Installing Homebrew (skipping if already installed)..."
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed, skipping."
fi

echo "🍺 Installing MPD dependencies..."
brew install fmt libid3tag faad2 expat libmad libsndfile
brew uninstall --ignore-dependencies flac
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/flac-143.tar.bz2 | tar jxvf - -C /opt/homebrew/Cellar
brew link flac@1.4.3
ln -s /opt/homebrew/opt/flac@1.4.3 /opt/homebrew/opt/flac
ln -s /opt/homebrew/opt/flac@1.4.3/lib/libFLAC.12.dylib /opt/homebrew/opt/flac@1.4.3/lib/libFLAC.14.dylib

echo "🎵 Installing MPD ..."
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/$version -o /Applications/mpd
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