#!/bin/bash
set -e  # stop on error

echo "🎵 MPD Installation"
echo "============================================="
echo "Select installation version (default 1):"
echo "0) MPD Ultra-light .2317 (wav/aiff, flac file only)"
echo "1) MPD .2317 (wav/aiff; Radio: flac, mp3)"
echo "2) MPD +DSD .2317 (+dsd; Radio: flac only)"
echo "3) MPD +Radio .2317 (Radio: +aac, ogg ,opus)"
echo "4) MPD All .2317 (All Format/Radio)"
read -p "Enter choice [0-4]: " choice

version="mpd-0.23.17"
if [[ "$choice" == "0" ]]; then
    echo "➡️ Installing MPD Ultra-light 0.23.17..."
    version="mpd-ul-0.23.17"
elif [[ "$choice" == "1" ]]; then
    echo "➡️ Installing MPD 0.23.17..."
    version="mpd-0.23.17"
elif [[ "$choice" == "2" ]]; then
    echo "➡️ Installing MPD-DSD 0.23.17 ..."
    version="mpd-dsd-0.23.17"
elif [[ "$choice" == "3" ]]; then
    echo "➡️ Installing MPD-Radio 0.23.17 ..."
    version="mpd-radio-0.23.17"
elif [[ "$choice" == "4" ]]; then
    echo "➡️ Installing MPD-FFmpeg 0.23.17..."
    version="mpd-ffmpeg-0.23.17"
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
# curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/libsndfile-1.2.2-2.tar.gz | tar xf - -C /opt/homebrew/Cellar
# brew link libsndfile
brew install fmt libid3tag expat faad2 flac mad opus
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/flac-143.tar.bz2 | tar jxf - -C /opt/homebrew/Cellar
if [ -f /opt/homebrew/Cellar/flac@1.4.3/lib/libFLAC.12.dylib ]; then
    rm -f /opt/homebrew/Cellar/flac/1.5.0/lib/libFLAC.14.dylib
    ln -s /opt/homebrew/Cellar/flac@1.4.3/1.4.3/lib/libFLAC.12.dylib /opt/homebrew/Cellar/flac/1.5.0/lib/libFLAC.14.dylib
fi
if [ ${version%-*} = "mpd-ffmpeg" ]; then
    curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/ffmpeg-8.0.1.tar.gz | tar xf - -C /opt/homebrew/Cellar
    brew link ffmpeg
fi

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
sed -i '' "s|HOME|$HOME|g" ~/Library/LaunchAgents/com.mpd.start.plist

echo "🚀 Starting MPD service..."
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.mpd.start.plist || true
launchctl enable gui/$(id -u)/com.mpd.start || true
launchctl kickstart -k gui/$(id -u)/com.mpd.start || true

echo "✅ MPD installation complete!"
