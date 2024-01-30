function all_roots=incremental_search(f,xmin,xmax,Nx)
    x=linspace(xmin,xmax,Nx);
    all_roots=[];
    for i=1:length(x)-1
        if f(x(i))*f(x(i+1))<0
            xr=(x(i)+x(i+1))/2;
            root=fzero(f,xr);
            disp(root)
            disp(f)
            disp(xr)
            all_roots=[all_roots root];
        end
    end
end

