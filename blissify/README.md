Blissify - analyze an MPD library and make smart playlist

Install Blissify with the following commands:

```bash
brew install ffmpeg sqlite
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify -o /usr/local/bin/blissify
sudo curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.py -o /usr/local/bin/blissify.py
sudo chmod +x /usr/local/bin/blissify*
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/blissify.conf >~/.mpd/blissify.conf
MDIR=`cat ~/.mpd/mpd.conf| grep "^music_directory" | cut -d'"' -f2`
sed -i '' "s|~/Music|$MDIR|g;s|~/Music|$MDIR|g" ~/.mpd/blissify.conf
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/com.blissify.start.plist >~/Library/LaunchAgents/com.blissify.start.plist
sed -i '' "s|HOME|$HOME|g" ~/Library/LaunchAgents/com.blissify.start.plist
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
