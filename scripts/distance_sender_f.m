%This script is used to send signal to measure distance
%Version 1.2. created on 2020.11.17, updated on 2020.11.21, author: swy
time_vector = clock;
disp(time_vector);

h = time_vector(4);
m = time_vector(5);
s = time_vector(6);
% transfer second into ms
% h = round(h*100);
% m = round(m*100);
% s = round(s*1000);
preamble = [0 1 0 1 0 1 0 1];
data_vector = [h, m, s]
%data_vector = [h, m, s];
temp = [h, m, s]; 
data_vector = cast(temp,'uint16');
data_bin = de2bi(data_vector, 16, 'left-msb');
disp(data_bin);
data_bits = reshape(double(data_bin).',48,1).';
send_bits = [preamble, data_bits];
FSK_code = bits2FSK(send_bits);
%FSK2WAV(FSK_code);
sound(FSK_code, 48000);