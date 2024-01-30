%c=m^e mod N
% c=RSA_Enc(1235,54,2537);
% c=RSA_Enc(56,53,10);
% c= m^e mod N we need find a quick way to calculate c
%1. change the decimalism of e to binary of e
%2. if the lowest bit of the e is 1 record the number after multiply and mod N
%3. if the lowest bit of the e is 0 just calculate the lastnum (sqrt and mod N)
function [c]= RSA_Encryption(N,e,m) %Encrypt the public key (c)
    i=1; % The node point to the situation of the n_num
    bin=length(dec2bin(e)); %gGet the size of the n_num
    n_num = ones(1, bin); % Record the mod number (lastnum)
    lastnum=sym(m); % The current base number
    % Get the first binary of the bin_num
    % If it is 1 then store the lastnum to the n_num
    % n_num is record the mod number
    % lastnum is record the last time mod number
    while e % Until the e is 0
        if(bitget(e, 1)==1) % Get the lowest bit of the e
            n_num(i)=lastnum; % record the n_num(i) is current base number
        end
        lastnum=mod(lastnum*lastnum,N); % Sqrt the base number and mod to N
        i= i+1; % Move the node to next
        e=bitshift(e, -1); % Shift right one bit of the e
    end
    c=mod(prod(n_num),N);% Multiple continuously of the n_num(base number) and then mod to the N 
    disp(c);
end