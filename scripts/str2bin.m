function msg_bits = str2bin(msg_str)
%STR2BIN convert a string to bit vector, the original stream may include
%Chinese characters.
%Input:
%   msg_str: the original string
%Output:
%   msg_bits: the encoded 01 vector, every 8 bits present a number
%Version 1.0. created on 2020.11.16, updated on 2020.11.16, author: swy
native = unicode2native(msg_str);
msg_bin = de2bi(native, 8, 'left-msb');
len = size(msg_bin, 1).*size(msg_bin, 2);
msg_bits = reshape(double(msg_bin).',len,1).';
end

