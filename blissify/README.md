Blissify - analyze an MPD library and make smart playlist

Install Blissify with the following commands:

```bash
brew install ffmpeg sqlite
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify >/usr/local/bin/blissify
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.py >/usr/local/bin/blissify.py
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.conf >~/.mpd/blissify.conf
chmod +x /usr/local/bin/blissify*
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/com.blissify.start.plist >~/Library/LaunchAgents/com.blissify.start.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.blissify.start.plist
launchctl enable gui/$(id -u)/com.blissify.start
launchctl kickstart -k gui/$(id -u)/com.blissify.start
```

To initialize and analyze your MPD library, use

```bash
blissify init -c ~/.mpd/blissify.conf
```

Update your library by running

```bash
blissify update -c ~/.mpd/blissify.conf
```
or update library with MPD Client.

From: [Blissify-rs](https://github.com/Polochon-street/blissify-rs)
