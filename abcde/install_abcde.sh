#!/bin/bash
# ============================================
#  install_abcde.bash
#  macOS CD ripping environment installer
# ============================================

set -e  # stop on error

echo "🎵 Installing abcde CD ripping environment for macOS..."
echo

# --- Homebrew dependencies ---
echo "📦 Installing dependencies via Homebrew..."
brew install libcdio libcdio-paranoia cd-discid glyr
brew install --cask kid3

# --- Python libraries ---
echo "🐍 Upgrading pip and installing Python modules..."
python3 -m pip install --upgrade pip
pip3 install beautifulsoup4 soupsieve lxml --break-system-packages

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

echo
echo "✅ Installation complete!"
echo
echo "Configuration file located at:"
echo "    ~/.abcde.conf"
echo
