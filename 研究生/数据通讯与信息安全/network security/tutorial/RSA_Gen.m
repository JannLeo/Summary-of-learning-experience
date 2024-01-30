function [N,d,e] = RSA_Gen(p,q)
    % N= p * q  both p and q is the prime factor of the N
    N=p*q;
    disp("N="+N);
    % z is the relatively prime 
    z=(p-1)*(q-1);
    % find the suitable e which meets with requirement of the e.
    for e=N-2:-1:2
        % e and z is Coprime
        if(gcd(e,z)==1)
            break;
        end
    end
    disp("e="+e);
    for d=1:1:z
        % d meets the requirement ed % z ==1
        if(mod(e*d,z)==1)
            break;
        end
    end
    disp("d="+d);
end

