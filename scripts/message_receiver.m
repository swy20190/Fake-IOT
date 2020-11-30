% This script decodes the signal while transmitting message
%Version 1.0. created on 2020.11.30, updated on 2020.11.30, author: swy
[message, fs] = audioread('tmp.wav');
figure(1);
plot(message);

%filter
message = filter(filter_4k_5k(), message);
figure(2);
plot(message);

