%This script is used for testing the functions and may be updated to
%satisfy the GUI
message = input('Please enter the message:\n', 's');
encoded_msg = encoder(message);
disp(encoded_msg);
wrapped_msg = wrap(encoded_msg, 8);
disp(wrapped_msg);
disp(bi2de(wrapped_msg,'left-msb'));