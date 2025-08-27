Music Player Daemon for macOS

Install Homebrew and the required libraries for MPD with the following commands:

  `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

  `brew install fmt libid3tag flac faad2 expat lame libmad libsndfile`

Copy mpd to /Applications, then execute the commands below:

  `chmod +x /Applications/mpd`

  `cp ~/Downloads/com.mpd.start.plist ~/Library/LaunchAgents/`

  `launchctl load ~/Library/LaunchAgents/com.mpd.start.plist`

  `launchctl start com.mpd.start.plist`

Copy the mpd.conf file to either ~/.mpdconf or ~/.mpd/mpd.conf
