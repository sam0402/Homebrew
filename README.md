Music Player Daemon for macOS

Install Homebrew and the required libraries for MPD with the following commands:

```bash
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
```

```bash
brew install fmt libid3tag flac faad2 expat lame libmad libsndfile
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/mpd-streamp3/mpd >~/Applications/mpd
chmod +x ~/Applications/mpd
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/com.mpd.start.plist >~/Library/LaunchAgents/com.mpd.start.plist
launchctl load ~/Library/LaunchAgents/com.mpd.start.plist
launchctl start com.mpd.start.plist
mkdir ~/.mpd
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/mpd-streamp3/mpd.conf >~/.mpd/mpd.conf
```

Enjoy it!
