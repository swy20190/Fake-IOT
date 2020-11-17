% This script receives the signal while measuring distance
%Version 1.0. created on 2020.11.17, updated on 2020.11.17, author: swy
start_record_vector = clock;
start_h = start_record_vector(4);
start_m = start_record_vector(5);
start_s = start_record_vector(6);

R = audiorecorder(10000, 16 ,1) ;
record(R);
pause(30);%录制60秒
stop(R);
[message_1, fs] = audioread('message01.wav');
message = getaudiodata(R);
plot(message);


%examine where to begin the signal
preamble = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
preamble = bits2FSK(preamble);

bar = 0.5;
t = 1;
try_preamble = message(t:t+15999);
co = [0 0 0 0];
while co(2) < bar
    t = t+1;
    try_preamble = message(t:t+15999);
    co = corrcoef(try_preamble, preamble);
end

disp(t);

