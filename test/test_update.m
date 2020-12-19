% This script test the decoding ability using the given 'res.wav'
%Version 1.0. created on 2020.12.9, updated on 2020.12.9, author: swy
[message, fs] = audioread('tmp.wav');

%filter
message = filter(filter_4k_6k(), message);
figure(1);
plot(message);

%find the start of signal
preamble = [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];
preamble = bits2FSK(preamble);

bar = 0.8;
t = 1;
try_preamble = message(t:t+23999);
co = [0 0 0 0];
while co(2) < bar
    t = t+1;
    try_preamble = message(t:t+23999);
    co = corrcoef(try_preamble, preamble);
end

disp(t);
len = length(message);
data_bit = message(t+24000:len); 
%figure(2);
%plot(data_bit);

f = 6000;%目标频率
[n,~] = size(data_bit);%获取数据的长度值
window = 400;%设置窗口大小为400个采样点
impulse_fft_6k = zeros(n,1);%定义变量数组impulse_fft，用于存储每个时刻对应的数据段中该频率信号的强度
for i= 1:1:n-window
    %对从当前点开始的window长度的数据进行傅里叶变换
    y = fft(data_bit(i:i+window-1));
    y = abs(y);
    %得到目标频率傅里叶变换结果中对应的index
    index_impulse = round(f/fs*window);
    %考虑到声音通信过程中的频率偏移，我们取以目标频率为中心的5个频率采样点中最大的一个来代表目标频率的强度
    impulse_fft_6k(i)=max(y(index_impulse-2:index_impulse+2));
end

% 滑动平均（均值滤波）
sliding_window = 10;
impulse_fft_tmp = impulse_fft_6k;
for i = 1+sliding_window:1:n-sliding_window
    impulse_fft_tmp(i)=mean(impulse_fft_6k(i-sliding_window:i+sliding_window));
end
impulse_fft_6k = impulse_fft_tmp;
%figure(3)
%plot(impulse_fft_6k);

% peak
position_impulse=[];%用于存储峰值的index
half_window = 600;
for i= half_window+1:1:n-half_window
    %进行峰值判断
    if impulse_fft_6k(i)> 40 && impulse_fft_6k(i)==max(impulse_fft_6k(i-half_window:i+half_window))
        position_impulse=[position_impulse,i];
    end
end

message_bin = zeros(len, 1);
for i=1:1:length(position_impulse)
    message_bin(ceil(position_impulse/1200)) = 1;
end

real_message_start = 1;
last_one_index = 1;
for i=1:1:5
   if(message_bin(i) == 1)
        last_one_index = i;
    end
end
real_message_start = last_one_index+1;

real_message_bin = message_bin(real_message_start:len);
len = length(real_message_bin);
real_message_vec = real_message_bin;

real_message_bin = real_message_bin';

% 结果矩阵，每一行代表一个包，第一列为包编号, 每行50列，不足的列用-1补全（方便输出到xls）
result = [];
package_index = 1;
curr_ptr = 1;
bin_pre = [0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];

while (curr_ptr+8<len)
    curr_row = [];
    curr_len = bi2de(real_message_bin(curr_ptr:curr_ptr+7), 'left-msb');
    curr_ptr = curr_ptr+8;
    curr_row = [curr_row, package_index];
    package_index = package_index+1;
    if(curr_ptr+curr_len >= len)
        break;
    end
    curr_row = [curr_row, real_message_bin(curr_ptr:curr_ptr+curr_len-1)];
    curr_ptr = curr_ptr+curr_len;
    %将当前行补全
    curr_row_len = length(curr_row);
    if(curr_row_len>50)
        break;
    end
    if(curr_row_len < 50)
        for i=1:1:50-curr_row_len
            curr_row = [curr_row, -1];
        end
    end
    disp(package_index);
    disp(length(curr_row));
    %将当前行加入结果矩阵
    result = [result;curr_row];
    %寻找下一段前导码
    find_next = 0;
    while(curr_ptr+19 <= len)
        samecount = 0
        for p = 1:1:20
            if (bin_pre(p) == real_message_bin(curr_ptr+p-1))
                samecount = samecount +1;
            end
        end
        if samecount > 18
        %if isequal(bin_pre, real_message_bin(curr_ptr:curr_ptr+19))
            find_next = 1;
            break;
        end
        curr_ptr = curr_ptr+1;
    end
    if(find_next == 0)
        break;
    end
    curr_ptr = curr_ptr+20;
end

xlswrite('result.xls', result);

