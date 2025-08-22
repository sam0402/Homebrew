MPD for macOS

Install Homebrew and the required libraries for MPD with the following commands:

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

`brew install fmt libid3tag flac faad2 expat lame libmad libsndfile`

Copy mpd to /Applications and run '/Applications/mpd &' in the background.

Copy the mpd.conf file to either ~/.mpdconf or ~/.mpd/mpd.conf.
