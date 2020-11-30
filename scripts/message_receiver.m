% This script decodes the signal while transmitting message
%Version 1.0. created on 2020.11.30, updated on 2020.11.30, author: swy
[message, fs] = audioread('tmp.wav');

%filter
message = filter(filter_4k_5k(), message);
figure(1);
plot(message);

%find the start of signal
preamble = [0 1 0 1 0 1 0 1];
preamble = bits2FSK(preamble);

bar = 0.7;
t = 1;
try_preamble = message(t:t+38399);
co = [0 0 0 0];
while co(2) < bar
    t = t+1;
    try_preamble = message(t:t+38399);
    co = corrcoef(try_preamble, preamble);
end

disp(t);

disp(t);
len = length(message);
data_bit = message(t+38400:len); %此处有6*4800 = 28800的冗余，因为之后需要准确判断前导码结束位置
figure(2);
plot(data_bit);


