function [m,d]=RSA_Hack(N,e,c)
format long;
factors=factor(N);
p=factors(1);
q=N/p;
z = (p-1)*(q-1);

for i=1:length(p)
    [g, x, ~] = gcd(e, z);
    if g ~= 1
        p=factors(i);
        q=N/p;
        z = (p-1)*(q-1);
    else
        d = mod(x, z);
    end

end
% for d=1:1:z
%    if (mod(e*d - 1 ,z) == 0)
%        break;
%    end
% end
%%m=powermod(c,d,N);
m=RSA_Dec(N,d,c);
end