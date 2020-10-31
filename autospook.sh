#!/bin/bash

ffmpeg -y -i $1.mp4 $1.wav
time=$(python3 findQuiet.py $1.wav)
ffmpeg -y -t $time -i $1.mp4 $1_start.mp4
ffmpeg -y -ss $time -i $1.mp4 $1_end.mp4
ffmpeg -y -i $1_start.mp4 -i $2.mp4 -i $1_end.mp4 \
       -filter_complex "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] 
                        concat=n=3:v=1:a=1 [v] [a]" \
       -map "[v]" -map "[a]" output.mp4

-filter_complex \
"[0:v]scale=640:480:force_original_aspect_ratio=decrease,pad=640:480:(ow-iw)/2:(oh-ih)/2[v0]; \
 [v0][0:a][1:v][1:a]concat=n=2:v=1:a=1[v][a]" \
-map "[v]" -map "[a]" -c:v libx264 -c:a aac -movflags +faststart output.mp4
    
rm -f $1.wav
rm -f $1_start.mp4
rm -f $1_end.mp4