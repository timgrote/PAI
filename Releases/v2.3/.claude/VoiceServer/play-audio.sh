#!/bin/bash
# Play audio via Windows ffplay (called from VoiceServer)
# Usage: play-audio.sh /path/to/audio.mp3

AUDIO_FILE="$1"

if [ -z "$AUDIO_FILE" ]; then
    echo "Usage: $0 <audio-file>" >&2
    exit 1
fi

# Convert Linux path to Windows UNC path
WIN_PATH="\\\\wsl.localhost\\Ubuntu${AUDIO_FILE//\//\\}"

# ffplay.exe location
FFPLAY='/mnt/c/Users/tim/AppData/Local/Microsoft/WinGet/Packages/Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe/ffmpeg-8.0-full_build/bin/ffplay.exe'

# Run ffplay via Windows
"$FFPLAY" -nodisp -autoexit "$WIN_PATH" 2>/dev/null
