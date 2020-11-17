%This script is used for testing the functions and may be updated to
%satisfy the GUI
message = input('Please enter the message:\n', 's');
encoded_msg = encoder(message);
disp(encoded_msg);
fsk_code = bits2FSK(encoded_msg);
plot(fsk_code);
FSK2WAV(fsk_code);