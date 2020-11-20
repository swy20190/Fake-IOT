function FSK = bits2FSK(bits)
%BITS2FSK transfer the digital signal to stimulate signal with 2FSK
%Input:
%   bits: the digital signal
%Output:
%   FSK: stimulate signal
%Info:
%   sampling rate: 48000
%   1: f=5kHz
%   0: f=4kHz
%   transfer speed: 1/0.1 = 10 bits per second
%Version 1.2. created on 2020.11.17, updated on 2020.11.19, author: swy
FSK = [];
t_begin=0;
t_end=0.1;
t=t_begin:1/48000:t_end-1/48000;
for i=1:length(bits)
    
    if(bits(i)==1)
        FSK=[FSK,sin(10000*pi*t)];
    elseif (bits(i)==0)
        FSK=[FSK,sin(8000*pi*t)];
    end
    
end
end

