#!/bin/bash
# ============================================
#  install_abcde.bash
#  macOS CD ripping environment installer
# ============================================

set -e  # stop on error

echo "🎵 Installing abcde CD ripping environment for macOS..."
echo
echo "🔧 Installing Homebrew (skipping if already installed)..."
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew already installed, skipping."
fi

# --- Homebrew dependencies ---
echo "📦 Installing dependencies via Homebrew..."
brew install libcdio libcdio-paranoia cd-discid glyr flac
brew install --cask kid3

# --- Python libraries ---
echo "🐍 Upgrading pip and installing Python modules..."
# python3 -m pip install --upgrade pip
pip3 install beautifulsoup4 soupsieve lxml

# --- Install helper scripts ---
echo "🧰 Installing abcde and related tools..."

sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/abcde/cddb-tool \
  -o /usr/local/bin/cddb-tool

sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/abcde/abcde \
  -o /usr/local/bin/abcde

curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/abcde/abcde.conf \
  -o "$HOME/.abcde.conf"

sudo curl -fsSL https://raw.githubusercontent.com/sam0402/ArchQ/refs/heads/main/pkg/qobuz2cddb.py \
  -o /usr/local/bin/qobuz2cddb.py

# --- Set permissions ---
echo "🔐 Setting permissions..."
sudo chmod +x /usr/local/bin/*cd*

if [ -f $HOME/.mpd/mpd.conf ]; then
    # Get MPD music directory from mpd.conf
    MDIR=$(grep "^music_directory" $HOME/.mpd/mpd.conf | cut -d'"' -f2)

    # Replace HOME and default music path in configuration
    sed -i '' "s|^OUTPUTDIR=.*|OUTPUTDIR=\"$MDIR\"|" $HOME/.abcde.conf
fi
echo
echo "✅ Installation complete!"
echo
echo "Configuration file located at:"
echo "    ~/.abcde.conf"
echo