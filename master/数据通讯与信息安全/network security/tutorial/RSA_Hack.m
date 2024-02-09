%% m= c^d mod N  Extended Euclidean Algorithm
% RSA always uses two big prime numbers to deal with the encryption process. The public key is obtained from the multiplication of both figures. However, we can break it by doing factorization to split the public key into two individual numbers. Cryptanalysis can perform the public key crack by knowing its value. The private key will be soon constructed after the two numbers retrieved. The public key is noted as “N”, while "N = P . Q". This technique is unclassified anymore to solve the RSA public and private key. If it is successfully factored into p and q then ɸ (N) = (P -1). (Q -1) can be further calculated. By having the public key e, the private key d will be solved. Factorization method is the best way to do the demolition. This study concerns to numbersfactorization. GCD calculation will produce the encryption "E" and decryption "D" keys.
% we know the N and c but don't know d
% so we need to calculate d , d can be calculated as mod(e*d,z)==1
% z is equal to (p-1)*(q-1) and N = p*q
% so we should calculated P and q through N and thus we can know 
% z and then calculate the d
% in conclusion we need calculate p
function [m]=RSA_Hack (N,e,c)
    format long;
    % c:ciphertext m:plaintext N:N=p*q e:e=gcd(e,z)  d=mod(e*d,z)=1
    % e:公钥 d：私钥 m:明文 c:密文 N:质数相乘
    % c= m^e mod N  m = c^d mod N.
    fa=factor(N);% set the Prime number array
    p=fa(1);% ergodic the first Prime number
    q=N/p; % get the q
    z=floor((p-1)*(q-1)); % get the z
    for i=1:1:length(fa)%ergodic to find the secret key d
        [g,u,~]=gcd(e,z); % e*u + z*~ = g . g is the common factor of the e and z 
        % if common factor is 1
        % it means e*u + z*~ = 1 and then e*u - 1 = -z*~
        % Because mod(e*d,z)=1 means e*d-1 %z =0
        % so (e*u -1) mod z = -z*~ mod z = 0
        % so d = u mod z to prevent the d is < 0
        if(g==1)
            d=mod(u,z);
            break;
        else % g ~= 1 so choose next prime factor to calculate gcd
            p=fa(i);
            q=N/p;
            z=(p-1)*(q-1);
        end
    end
    m=RSA_Dec(N,d,c); % calculate the m = c^d mod N.
    disp(m);
end