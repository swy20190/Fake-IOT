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
len = length(message);
data_bit = message(t+38400:len); 
figure(2);
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
figure(3)
plot(impulse_fft_5k);

% peak
position_impulse=[];%用于存储峰值的index
half_window = 800;
for i= half_window+1:1:n-half_window
    %进行峰值判断
    if impulse_fft_5k(i)>90 && impulse_fft_5k(i)==max(impulse_fft_5k(i-half_window:i+half_window))
        position_impulse=[position_impulse,i];
    end
end

message_bin = zeros(len, 1);
for i=1:1:length(position_impulse)
    message_bin(ceil(position_impulse/4800)) = 1;
end



