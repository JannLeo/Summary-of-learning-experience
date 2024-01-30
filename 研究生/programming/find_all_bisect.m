function all_roots = find_all_bisect(f,xmin,xmax,Nx)
    x = linspace(xmin,xmax,Nx);
    all_roots = [];
    for i=1:length(x)-1
        if f(x(i))*f(x(i+1))<0
            root= mybisect(f,x(i),x(i+1),10000);
            if abs(f(root))<1
                all_roots = [all_roots root];
            end
        end
    end
end