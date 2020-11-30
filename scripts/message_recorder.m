% This script records the signal while transmitting message
%Version 1.0. created on 2020.11.30, updated on 2020.11.30, author: swy
R = audiorecorder(48000, 16 ,1) ;
record(R);
pause(60);%录制60秒
stop(R);
message = getaudiodata(R);
audiowrite("tmp.wav", message, 48000);