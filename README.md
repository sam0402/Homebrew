Music Player Daemon for macOS

Install MPD with the following commands:

```bash
curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/install_mpd.sh | bash
```

Modify the music_directory value in ~/.mpd/mpd.conf according to the location of your music files.

To enable the httpd output, remove the comment marks (#) from lines 263 to 275 in the mpd.conf file.

Enjoy it!
