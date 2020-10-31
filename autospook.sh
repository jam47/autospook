#!/bin/bash
# RES1=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 $1.mp4)
# RES2=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 $2.mp4)

# LARGER=$(python3 larger.py $RES1 $RES2)

# if [[ $LARGER -gt 0 ]] 
# then
#     echo "LARGER"
#     ffmpeg -y -i $1.mp4 -vf scale=$(echo $RES2 | tr , x):flags=lanczos -c:v libx264 -preset slow -crf 21 $1_res.mp4
#     cp $2.mp4 $2_res.mp4
# else
#     echo "reducing $2.mp4 -> $(echo $RES1 | tr , x) -> $2_res.mp4"
#     ffmpeg -y -i $2.mp4 -vf scale=$(echo $RES1 | tr , x):flags=lanczos -c:v libx264 -preset slow -crf 21 $2_res.mp4
#     cp $1.mp4 $1_res.mp4
# fi

ffmpeg -y -i $1.mp4 $1.wav
time=$(python3 findQuiet.py $1.wav)
ffmpeg -y -t $time -i $1.mp4 $1_start.mp4
ffmpeg -y -ss $time -i $1.mp4 $1_end.mp4
ffmpeg -y -i $1_start.mp4 -i $2.mp4 -i $1_end.mp4 \
       -filter_complex "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a] 
                        concat=n=3:v=1:a=1 [v] [a]" \
       -map "[v]" -map "[a]" output.mp4
    
 

                        # "[0:v]scale=1920x1080:force_original_aspect_ratio=1[v0]; [1:v]scale=1920x1080:force_original_aspect_ratio=1[v1];
    #    [2:v]scale=1920x1080:force_original_aspect_ratio=1[v2]; [v0][0:a][v1][1:a][v2][2:a] concat=n=3:v=1:a=1 [v] [a]" \



# rm -f $1_res.mp4
# rm -f $2_res.mp4
# rm -f $1.wav
# rm -f $1_start.mp4
# rm -f $1_end.mp4