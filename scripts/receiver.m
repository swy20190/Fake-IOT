% This script receives the signal while measuring distance
%Version 1.2. created on 2020.11.17, updated on 2020.11.19, author: swy
start_record_vector = clock;
start_h = start_record_vector(4);
start_m = start_record_vector(5);
start_s = start_record_vector(6);

R = audiorecorder(48000, 16 ,1) ;
record(R);
pause(30);%录制30秒
stop(R);
[message_1, fs] = audioread('20201119T152026.wav');
message = getaudiodata(R);
% message = filter(filter_500_1200, message);
figure(1);
plot(message);
figure(2);
plot(message_1);


%examine where to begin the signal
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
data_bit = message(t+76800:t+249599); %此处有4*4800 = 19200的冗余，因为之后需要准确判断前导码结束位置
figure(3);
plot(data_bit);

f = 5000;%目标频率
[n,~] = size(data_bit);%获取数据的长度值
window = 400;%设置窗口大小为400个采样点
impulse_fft_5k = zeros(n,1);%定义变量数组impulse_fft，用于存储每个时刻对应的数据段中该频率信号的强度
for i= 1:1:n-window
    %对从当前点开始的window长度的数据进行傅里叶变换
    y = fft(data_bit(i:i+window-1));
    y = abs(y);
    %得到目标频率傅里叶变换结果中对应的index
    index_impulse = round(f/fs*window);
    %考虑到声音通信过程中的频率偏移，我们取以目标频率为中心的5个频率采样点中最大的一个来代表目标频率的强度
    impulse_fft_5k(i)=max(y(index_impulse-2:index_impulse+2));
end

% 滑动平均（均值滤波）
sliding_window = 5;
impulse_fft_tmp = impulse_fft_5k;
for i = 1+sliding_window:1:n-sliding_window
    impulse_fft_tmp(i)=mean(impulse_fft_5k(i-sliding_window:i+sliding_window));
end
impulse_fft_5k = impulse_fft_tmp;
figure(4)
plot(impulse_fft_5k);



position_impulse=[];%用于存储峰值的index
half_window = 200;
for i= half_window+1:1:n-half_window
    %进行峰值判断
    if impulse_fft_5k(i)>25 && impulse_fft_5k(i)==max(impulse_fft_5k(i-half_window:i+half_window))
        position_impulse=[position_impulse,i];
    end
end

disp(position_impulse);

message_bin = zeros(52, 1);
for i=1:1:length(position_impulse)
    message_bin(ceil(position_impulse/4800)) = 1;
end

disp(message_bin);
% 确定前导码结束准确位置(前四位中的第一个"10")
real_message_start = 1;
for i=1:1:3
   if(message_bin(i) == 1)
        real_message_start = i+2;
        break;
    end
end

real_message_start = real_message_start + 2;

real_message_bin = message_bin(real_message_start:real_message_start+47);
real_message_bin = reshape(real_message_bin',[16, 3])';
message_vector = bi2de(real_message_bin, 'left-msb');
disp(message_vector);
