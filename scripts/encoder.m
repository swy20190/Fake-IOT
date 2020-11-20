function encoded_bits = encoder(msg_str)
%ENCODER convert message to binary sequence including lead code and package
%head
%Input:
%   A message including Chinese characters
%Output:
%   A bit vector which packages the message and is ready to be transfered to
%   sound wave.
%Version 1.0. created on 2020.11.16, updated on 2020.11.16, author: swy
msg_bin = str2bin(msg_str);
encoded_bits = msg_bin;

end

