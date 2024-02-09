function m=RSA_Dec(N,d,c)
if  (N<c)
    error('Message c must less than N,')
end

% c = mod(c,N);

% for i=1:d
%     c=mod(c*c,N);
% end
% m=c;
m=1;
z = sym(c);  
while d>0
    if mod(d,2)==1
        m=mod(m*z,N);
    end
        z=mod(z*z,N);
        d=floor(d/2);    
end
end