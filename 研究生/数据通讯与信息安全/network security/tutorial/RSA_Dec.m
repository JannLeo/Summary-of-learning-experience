% m = c^d mod N. we need to make the calculation faster and simplify the
% process.

function [m]=RSA_Dec(N,d,c)
    i=1;% The node point to the situation of the n_num
    bin=length(dec2bin(d));
    n_num = ones(1, bin); % Record the mod number (lastnum) initialize the array
    lastnum=sym(c);% The current base number
    while d % Until the d is 0
        if(bitget(d, 1)==1) % Get the lowest bit of the d
            n_num(i)=lastnum; % record the n_num(i) is current base number
        end
        lastnum=mod(lastnum*lastnum,N); % Sqrt the base number and mod to N
        i= i +1; % Move the node to next
        d=bitshift(d, -1); % Shift right one bit of the d
    end
    m=mod(prod(n_num),N);% Multiple continuously of the n_num(base number) and then mod to the N 
    disp(m);
end