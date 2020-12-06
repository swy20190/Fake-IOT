function [] = message_recorder_func()
%MESSAGE_RECORDER_FUNC record the signal to be decoded
%   record the signal for 60 seconds, then store it in file "tmp.wav"
%   no input
%   no output
%Version 1.0. created by swy on 2020/12/6, updated by swy on 2020/12/6
R = audiorecorder(48000, 16 ,1) ;
record(R);
pause(60);%录制60秒
stop(R);
message = getaudiodata(R);
audiowrite("tmp.wav", message, 48000);

end

