function [] = FSK2WAV(stimulate_signal)
%FSK2WAV 此处显示有关此函数的摘要
%   此处显示详细说明
Fs = 10000;
audio_succ = ".wav";
audio_name = strcat(datestr(now, 30), audio_succ);
audiowrite(audio_name,stimulate_signal, Fs);

pause(5);
sound(stimulate_signal, 10000);

end

