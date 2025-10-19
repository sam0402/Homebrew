#!/usr/bin/env python3
import os
import random
import argparse
import subprocess
# defer import of MPDClient until runtime to allow --help without mpd installed

# config = os.path.join("~/.mpd/blissify.conf")
config = os.path.expanduser("~/.mpd/blissify.conf")

def init_connection():
    """
    Returns an MPDClient connection.
    """
    try:
        from mpd import MPDClient
    except Exception:
        # re-raise with a clearer message when used at runtime
        raise
    mpd_host = os.environ.get("MPD_HOST", "localhost")
    mpd_password = None
    if "@" in mpd_host:
        mpd_password, mpd_host = mpd_host.split("@")
    try:
        mpd_port = int(os.environ.get("MPD_PORT", 6600))
    except ValueError:
        mpd_port = 6600

    client = MPDClient()
    client.connect(mpd_host, mpd_port)
    if mpd_password:
        client.password(mpd_password)
    return client

def close_connection(client):
    """
    Closes an MPDClient connection.
    """
    client.close()
    client.disconnect()
        
def listen(client, wk_path, config):
    """Listen for MPD IDLE events and trigger blissify actions.

    This simplified listener removes any CLI gating and will run
    until interrupted (KeyboardInterrupt).
    """
    metric = ['euclidean', 'cosine']
    while True:
        try:
            if client.idle() == ['player']:
                playnum = int (client.status()['song']) + 1
                listlength = int (client.status()['playlistlength'])
                if playnum == listlength:
                    subprocess.check_call(['blissify', '-c', config, 'playlist', '--distance', metric[random.randint(0, 1)], str(random.randint(8, 16)) ])
            if client.idle() == ['update']:
                subprocess.check_call(['blissify', '-c', config, 'update'])
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Run blissify MPD listener (listens for IDLE events and triggers actions)."
    )
    parser.add_argument(
        "--config",
        "-c",
        dest="config",
        default=config,
        help="Path to blissify config (default: /etc/blissify.conf)",
    )

    args = parser.parse_args()
    client = init_connection()
    try:
        # derive working path from config location or current dir
        wk_path = os.path.dirname(args.config) or os.getcwd()
        listen(client, wk_path, args.config)
    finally:
        close_connection(client)
