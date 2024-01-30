function f=myf(x)
    f=2*sin(x).*cos(x/2)./(1+sin(x).*exp(x)/(1+abs(x)));
end

