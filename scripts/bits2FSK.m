function FSK = bits2FSK(bits)
%BITS2FSK transfer the digital signal to stimulate signal with 2FSK
%Input:
%   bits: the digital signal
%Output:
%   FSK: stimulate signal
%Info:
%   sampling rate: 1/0.001 = 1000
%   1: f=40000Hz
%   0: f=20000Hz
%   transfer speed: 1/0.1 = 10 bits per second
%Version 1.0. created on 2020.11.17, updated on 2020.11.17, author: swy
FSK = [];
t_begin=0;
t_end=0.1;
for i=1:length(bits)
    t=t_begin:0.001:t_end;
    if(bits(i)==1)
        FSK=[FSK,sin(40000*pi*t).*(t>=t_begin & t<t_end)];
    elseif (bits(i)==0)
        FSK=[FSK,sin(20000*pi*t).*(t>=t_begin & t<t_end)];
    end
    t_begin=t_begin+0.1;
    t_end=t_end+0.1;
end
end

