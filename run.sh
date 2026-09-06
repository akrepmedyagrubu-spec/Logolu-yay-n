#!/bin/bash

mkdir -p /app/hls

INPUT_STREAM="https://corestream.ardastream.live//beintv/tracks-v1a1/mono.m3u8"

echo "FFmpeg 240p başlıyor..."

(
while true
do
  ffmpeg -loglevel warning \
  -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
  -i "$INPUT_STREAM" -i logo2.png \
  -filter_complex "\
  [0:v]scale=426:240[base]; \
  [1:v]scale=426:240[logo]; \
  [base][logo]overlay=0:0" \
  -c:v libx264 -preset ultrafast -tune zerolatency \
  -b:v 400k -maxrate 450k -bufsize 600k \
  -g 48 \
  -c:a aac -b:a 48k \
  -f hls \
  -hls_time 4 \
  -hls_list_size 6 \
  -hls_flags delete_segments+append_list \
  /app/hls/stream.m3u8

  echo "FFmpeg restart..."
  sleep 3
done
) &

# Render port fix
cd /app
python3 -m http.server ${PORT:-10000}
