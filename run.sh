#!/bin/bash

mkdir -p hls

# ORIJINAL STREAM BURAYA
INPUT_STREAM="https://andro.evrenesoglu57.click/checklist/androstreamlivets1.m3u8"

# FFmpeg restart loop (çökünce geri açılır)
while true
do
  echo "Stream başlıyor..."

  ffmpeg -re -i "$INPUT_STREAM" -i logo.png \
  -filter_complex "overlay=20:20" \
  -c:v libx264 -preset veryfast -crf 23 \
  -c:a aac \
  -f hls \
  -hls_time 4 \
  -hls_list_size 6 \
  -hls_flags delete_segments+append_list \
  -hls_allow_cache 1 \
  hls/stream.m3u8

  echo "FFmpeg çöktü, yeniden başlıyor..."
  sleep 2
done &
