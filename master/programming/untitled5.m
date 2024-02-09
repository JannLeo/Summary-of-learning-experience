 %% test 1
 clear all
 close all 
 clc

 x=linspace(-4*pi,4*pi,1000);
 plot(x,myf(x),'-r','LineWidth',3);
 set(gca,'FontSize',14)
 xlabel('x')
 ylabel('Function f')

 %% Test 2
 clear all
 close all 
 clc

 x=linspace(-4*pi,4*pi,1000);
 plot(x,myf(x),'LineWidth',3);
 set(gca,'FontSize',14)
 xlabel('x')
 ylabel('Function f')