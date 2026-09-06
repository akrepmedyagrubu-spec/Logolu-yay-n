#!/bin/bash

mkdir -p /app/hls

# 🔥 BURAYA KENDİ M3U8 LİNKİNİ KOY
INPUT_STREAM="https://corestream.ardastream.live//beintv/tracks-v1a1/mono.m3u8"

echo "FFmpeg başlatılıyor..."

# 🔁 Sürekli çalış (çökse bile tekrar başlar)
(
while true
do
  ffmpeg -loglevel warning \
  -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
  -i "$INPUT_STREAM" -i logo.png \
  -filter_complex "[1:v]scale=main_w:main_h[logo];[0:v][logo]overlay=0:0" \
  -c:v libx264 -preset veryfast -crf 23 \
  -c:a aac -b:a 128k \
  -f hls \
  -hls_time 4 \
  -hls_list_size 6 \
  -hls_flags delete_segments+append_list \
  /app/hls/stream.m3u8

  echo "FFmpeg çöktü → yeniden başlatılıyor..."
  sleep 3
done
) &

# 🌐 HTTP SERVER (Render port fix)
echo "Server başlatılıyor..."

cd /app
python3 -m http.server ${PORT:-10000}
