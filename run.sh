#!/bin/bash

set -e

mkdir -p /app/hls

INPUT_STREAM="https://corestream.ardastream.live//beintv/tracks-v1a1/mono.m3u8"

echo "FFmpeg başlatılıyor..."

# FFmpeg arka planda + hata verse bile loop
(
while true
do
  ffmpeg -loglevel error -re -i "$INPUT_STREAM" -i logo.png \
  -filter_complex "overlay=20:20" \
  -c:v libx264 -preset veryfast -crf 23 \
  -c:a aac \
  -f hls \
  -hls_time 4 \
  -hls_list_size 6 \
  -hls_flags delete_segments+append_list \
  /app/hls/stream.m3u8

  echo "FFmpeg çöktü → yeniden başlatılıyor"
  sleep 3
done
) &

# 🔥 KRİTİK: foreground process
echo "HTTP server başlatılıyor..."

cd /app
python3 -m http.server ${PORT:-10000}
