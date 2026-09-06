#!/bin/bash

mkdir -p /app/hls

INPUT_STREAM="https://corestream.ardastream.live//beintv/tracks-v1a1/mono.m3u8"

echo "FFmpeg başlatılıyor..."

(
while true
do
  ffmpeg -loglevel warning \
  -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
  -i "$INPUT_STREAM" -i logo.png \
  -filter_complex "[1:v][0:v]scale2ref=w=iw:h=ih[logo][base];[base][logo]overlay=0:0" \
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

cd /app
python3 -m http.server ${PORT:-10000}
