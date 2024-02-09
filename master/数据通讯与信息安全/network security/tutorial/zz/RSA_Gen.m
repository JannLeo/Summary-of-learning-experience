function [N,d,e] = RSA_Gen(p,q)

z = (p-1)*(q-1);
N = p * q;


for i = 2:1:N-2
    if(gcd(i,z) == 1)
        e=i;
        break;
    end
end

for d=1:1:z
    if (mod(e*d - 1 ,z) == 0)
        break;
    end
end

end