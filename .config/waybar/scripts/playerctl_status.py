#!/usr/bin/env python3

import subprocess
import json
import sys

def get_player_status():
    try:
        status_output = subprocess.check_output(
            ["playerctl", "-p", "spotify", "status"],
            stderr=subprocess.PIPE
        ).decode('utf-8').strip()

        status = status_output.lower()

        if status not in ["playing", "paused"]:
            return None, "Stopped"

        metadata_raw = subprocess.check_output(
            ["playerctl", "-p", "spotify", "metadata", "--format",
             "{\"artist\": \"{{artist}}\", \"title\": \"{{title}}\", \"album\": \"{{album}}\"}"],
            stderr=subprocess.PIPE
        ).decode('utf-8').strip()

        metadata = json.loads(metadata_raw)

        artist = metadata.get('artist', 'Unknown Artist')
        title = metadata.get('title', 'Unknown Title')
        album = metadata.get('album', 'Unknown Album')

        return {
            "artist": artist,
            "title": title,
            "album": album,
            "status": status.capitalize()
        }, status.capitalize()

    except subprocess.CalledProcessError as e:
        return None, "Stopped"
    except json.JSONDecodeError:
        return None, "Stopped"
    except Exception as e:
        return None, "Stopped"

def main():
    metadata, status = get_player_status()

    music_symbol = "󰎈"

    text_content = ""
    tooltip_content_for_script = ""
    class_name = ""

    icon = music_symbol

    if metadata and status in ["Playing", "Paused"]:
        artist = metadata['artist']
        title = metadata['title']

        if status == "Playing":
            class_name = "playing"
        elif status == "Paused":
            class_name = "paused"

        max_length = 30
        display_text = f"{artist} - {title}"
        if len(display_text) > max_length:
            display_text = display_text[:max_length-3] + "..."

        text_content = f"{icon} {display_text}"

        tooltip_content_for_script = (
            f"<big><b>{metadata['title']}</b></big>\n"
            f"<small>{metadata['artist']}</small>\n\n"
            f"Status: {status}"
        )
    else:
        text_content = f"{icon}"
        tooltip_content_for_script = "No music playing on Spotify."
        class_name = "stopped"

    output = {
        "text": text_content,
        "tooltip": tooltip_content_for_script,
        "class": class_name
    }
    print(json.dumps(output, ensure_ascii=False))

if __name__ == "__main__":
    main()
