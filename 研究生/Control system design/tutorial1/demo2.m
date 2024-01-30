
% First task script file
x = pi/100:pi/100:10*pi;
y = sin(x)./x;
y1 = 0.5.*y;
[minY, I] = min(y);

figure(1);
plot(x, y, 'k-', 'Linewidth',2);
grid;
figure(2);
plot(x, y, 'k-', x, y1, 'k--' , 'Linewidth',2);
grid;