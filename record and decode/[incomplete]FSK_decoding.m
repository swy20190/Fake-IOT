%算相关性，来确定前导码的位置
preamble = [1 0 1 0 1 0 1 0 1 0 1 0];
FSK_pre = 0;
t_begin=0;
t_end=1;
for i=1:length(y)
    t=t_begin:0.01:t_end;
    if(y(i)==1)
        FSK_pre=[FSK_pre,sin(40*pi*t).*(t>=t_begin & t<t_end)]
    elseif (y(i)==0)
        FSK_pre=[FSK_pre,sin(20*pi*t).*(t>=t_begin & t<t_end)]
    end
    t_begin=t_begin+1;
    t_end=t_end+1;
end
[data, fs] = audioread('message01.wav');
bar = 0.8;
t = 1;
try_preamble = data(t:t+1200);
co = [0 0 0 0];
while co(2) < bar
    t = t+1;
    try_preamble = data(t:t+1200);
    co = corrcoef(try_preamble, preamble);
end
%从t到t+1200这一段是前导码形成的波形，之后可开始解码

f = 40000;%目标频率
[n,~] = size(data);%获取数据的长度值
window = 100;%设置窗口大小为100个采样点
impulse_fft_40k = zeros(n,1);%定义变量数组impulse_fft，用于存储每个时刻对应的数据段中该频率信号的强度
for i= 1:1:n-window
    %对从当前点开始的window长度的数据进行傅里叶变换
    y = fft(data(i:i+window-1));
    y = abs(y);
    %得到目标频率傅里叶变换结果中对应的index
    index_impulse = round(f/fs*window);
    %考虑到声音通信过程中的频率偏移，我们取以目标频率为中心的5个频率采样点中最大的一个来代表目标频率的强度
    impulse_fft_40k(i)=max(y(index_impulse-2:index_impulse+2));
end
figure(1);
plot(impulse_fft_40k);

% 滑动平均（均值滤波）
sliding_window = 5;
impulse_fft_tmp = impulse_fft_40k;
for i = 1+sliding_window:1:n-sliding_window
    impulse_fft_tmp(i)=mean(impulse_fft_40k(i-sliding_window:i+sliding_window));
end
impulse_fft_40k = impulse_fft_tmp;
% 在figure中展示平滑后的impulse_fft
figure(2);
plot(impulse_fft_40k);

% 取出impulse 起始位置（峰的中间位置）
position_impulse=[];%用于存储峰值的index
half_window = 50;
for i= half_window+1:1:n-half_window
    %进行峰值判断
    if impulse_fft_40k(i)>0.3 && impulse_fft_40k(i)==max(impulse_fft_40k(i-half_window:i+half_window))
        position_impulse=[position_impulse,i];
    end
end
%同理列出20khz的脉冲开始位置，插空就可知整体01序列？
%包头部分可以确定位数，在位数内走一遍求值
