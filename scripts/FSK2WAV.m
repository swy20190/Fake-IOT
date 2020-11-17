function [] = FSK2WAV(stimulate_signal)
%FSK2WAV transfer stimulate signal to sound wave
%Input:
%   stimulate signal
%Info:
%   save the file named by the time stamp, then play it after 5 seconds
%Version 1.1. created on 2020.11.17, updated on 2020.11.17, author: swy
Fs = 10000;
audio_succ = ".wav";
audio_name = strcat(datestr(now, 30), audio_succ);
audiowrite(audio_name,stimulate_signal, Fs);

pause(5);
sound(stimulate_signal, 10000);

end

