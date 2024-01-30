function c = RSA_Enc(N,e,m)

if  (N<m)
    error('Message m must less than N,')
end
c=1;
m = mod(m,N);
while e>0
    if mod(e,2)==1
        c=mod(c*m,N);
    end
    e=floor(e/2);
    m=mod(m*m,N);

end

end