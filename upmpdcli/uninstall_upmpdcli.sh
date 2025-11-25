#!/bin/bash
set -e

echo "🧹 Uninstalling upmpdcli..."

LAUNCH_PLIST="$HOME/Library/LaunchAgents/com.upmpdcli.start.plist"
OPT_UPMPDCLI="/opt/upmpdcli-1.9.7"
BREW_CONF="/opt/homebrew/etc/upmpdcli.conf"

echo "⏹ Stopping LaunchAgent..."
launchctl bootout gui/$(id -u)/com.upmpdcli.start 2>/dev/null || true
launchctl disable gui/$(id -u)/com.upmpdcli.start 2>/dev/null || true

echo "🗑 Removing LaunchAgent plist..."
if [[ -f "$LAUNCH_PLIST" ]]; then
    rm -f "$LAUNCH_PLIST"
    echo "  ✔ Removed $LAUNCH_PLIST"
fi

echo "🗑 Removing upmpdcli extracted files..."
if [[ -d "$OPT_UPMPDCLI" ]]; then
    rm -rf "$OPT_UPMPDCLI"
    rm -rf $HOME/Applications/upmpdcli-config.app
    echo "  ✔ Removed $OPT_UPMPDCLI"
fi

echo "🗑 Removing /opt/homebrew/etc/upmpdcli.conf..."
if [[ -f "$BREW_CONF" ]]; then
    rm -f "$BREW_CONF"
    echo "  ✔ Removed $BREW_CONF"
fi

echo "🍺 Uninstalling Homebrew dependencies & Python pip3 modules..."
brew uninstall libmicrohttpd jsoncpp qwt
pip3 uninstall -y requests bottle mutagen waitress pyradios python-dateutil tidalapi

echo "❗ Keeping other Homebrew packages (libmpdclient expat)"
echo "✨ upmpdcli has been completely uninstalled."