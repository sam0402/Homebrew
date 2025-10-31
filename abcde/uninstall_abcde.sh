#!/bin/bash
# ============================================
#  uninstall_abcde.sh
#  Remove abcde CD ripping environment on macOS
# ============================================

set -e  # stop on error

echo "🧹 Uninstalling abcde and related tools..."
echo

# --- Stop any abcde process if running ---
if pgrep -f "abcde" >/dev/null; then
  echo "⚙️  Stopping running abcde processes..."
  pkill -f "abcde" || true
fi

# --- Remove executables ---
echo "🗑️  Removing installed binaries..."
sudo rm -f /usr/local/bin/abcde
sudo rm -f /usr/local/bin/cddb-tool
sudo rm -f /usr/local/bin/qobuz2cddb.py

# --- Remove config file ---
echo "🧾  Removing user config..."
rm -f "$HOME/.abcde.conf"

# --- Remove Python packages ---
echo "🐍  Removing Python modules (beautifulsoup4, soupsieve, lxml)..."
python3 -m pip uninstall -y beautifulsoup4 soupsieve lxml || true

# --- Ask about Homebrew packages ---
read -r -p "❓ Do you also want to uninstall Homebrew dependencies (libcdio, glyr, kid3, etc)? [y/N] " yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
  echo "🍺 Removing Homebrew packages..."
  brew uninstall libcdio libcdio-paranoia cd-discid glyr kid3 || true
else
  echo "➡️  Keeping Homebrew dependencies."
fi

echo
echo "✅ Uninstallation complete!"
echo "abcde and related tools have been removed."
echo