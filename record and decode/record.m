
R = audiorecorder(44100, 16 ,1) ;
record(R);
pause(5);%录制5秒
stop(R);
message = getaudiodata(R);
plot(message);
audiowrite('message01.wav',message,44100);