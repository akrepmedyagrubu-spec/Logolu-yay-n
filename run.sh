#!/bin/bash

mkdir -p /app/hls

INPUT_STREAM="https://corestream.d72377a9ds0ec71.cfd//beintv/tracks-v1a1/mono.m3u8"

echo "360p bufferlı stream başlatılıyor..."

(
while true
do
  ffmpeg -loglevel warning \
  -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
  -i "$INPUT_STREAM" -i logo3.png \
  -filter_complex "\
  [0:v]scale=640:360[base]; \
  [1:v]scale=640:360[logo]; \
  [base][logo]overlay=0:0" \
  -c:v libx264 -preset ultrafast -tune zerolatency \
  -b:v 600k -maxrate 800k -bufsize 1000k \
  -g 48 \
  -c:a aac -b:a 64k \
  -f hls \
  -hls_time 6 \
  -hls_list_size 20 \
  -hls_flags append_list \
  /app/hls/stream.m3u8

  echo "FFmpeg restart..."
  sleep 3
done
) &

cd /app
python3 -m http.server ${PORT:-10000}
