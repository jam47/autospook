#!/bin/bash

ffmpeg -y -i $1.mp4 $1.wav
time=$(python3 findQuiet.py $1.wav)
ffmpeg -y -t $time -i $1.mp4 $1_start.mp4
ffmpeg -y -ss $time -i $1.mp4 $1_end.mp4
ffmpeg -y -i $1_start.mp4 -i $2.mp4 -i $1_end.mp4 \
       -filter_complex "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] 
                        concat=n=3:v=1:a=1 [v] [a]" \
       -map "[v]" -map "[a]" output.mp4
    
rm -f $1.wav
rm -f $1_start.mp4
rm -f $1_end.mp4