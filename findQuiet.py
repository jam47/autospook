import wave
import sys
with wave.open(sys.argv[1], mode='r') as f:
    frameNo = 0
    avg = int.from_bytes(b'\xff\xff\xff\xff', 'big')
    minVol = int.from_bytes(b'\xff\xff\xff\xff', 'big')
    minPos = 0
    for frame in range(f.getnframes()):
        volume= int.from_bytes(f.readframes(1), 'big')
        avg = avg*0.99995 + 0.00005*volume
        if avg <= minVol:
            minVol = avg
            minPos = frameNo
        frameNo += 1
    print(round(minPos * (1/f.getframerate()), 3))
