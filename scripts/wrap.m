function wrapped_bits = wrap(original_bits, package_size)
%WRAP wrap the original bin-code with preamble & package header
%Input: 
%   original_bits: the original bit vector 
%   package_size: package size (measured by bits)
%Output:
%   wrapped_bits: the wrapped bit vector which can be transferred into
%   sound vector
%Version 1.0. created on 2020.11.16, updated on 2020.11.16, author: swy

preamble = [0, 1, 0, 1, 0, 1, 0, 1];
wrapped_bits = [];
package_index = 0;
len = length(original_bits);
while len>0
    package_length = 0;
    % add preamble
    wrapped_bits = [wrapped_bits preamble];
    % add package header
    % package index
    package_index_code = de2bi(package_index,8,'left-msb');
    wrapped_bits = [wrapped_bits package_index_code];
    % package length
    if len>=package_size
        package_length = package_size;
    else
        package_length = len;
    end
    package_length_code = de2bi(package_length, 8, 'left-msb');
    wrapped_bits = [wrapped_bits package_length_code];
    % payload
    payload = original_bits(:,package_index*package_size + 1:package_index*package_size+package_length);
    wrapped_bits = [wrapped_bits payload];
    % update index 
    package_index = package_index+1;
    len = len - package_length;
end

end

