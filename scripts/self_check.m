check_signal = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0];
check_stimulate = bits2FSK(check_signal);
pred = zeros(1, 4800*8);
check_stimulate = [pred check_stimulate];


R = audiorecorder(48000, 16 ,1) ;
record(R);
sound(check_stimulate, 48000);
pause(5);
stop(R);
message = getaudiodata(R);
figure(1);
plot(message);

preamble = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0];
preamble = bits2FSK(preamble);

bar = 0.75;
t = 1;
try_preamble = message(t:t+76799);
co = [0 0 0 0];
while co(2) < bar
    t = t+1;
    try_preamble = message(t:t+76799);
    co = corrcoef(try_preamble, preamble);
end

disp(t);
% measure the deviation of the beginning of preamble
delta_t = 4800*8 - t;
disp(delta_t);

