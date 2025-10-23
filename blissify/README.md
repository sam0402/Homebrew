Blissify - analyze an MPD library and make smart playlist

Install Blissify with the following commands:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/sam0402/Homebrew/refs/heads/main/blissify/install_blissify.sh)"
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
