%传递函数模型 tf()
s = tf('s'); 
G = (s+1)*(s+2)/( (s^2 + s + 2)*(s+3));
%the dynamic part of the controller is set to 1.
Ks = 1; 
Q = Ks*G;
%Create figure window
figure(1); 
%Root locus plot of dynamic system
rlocus(Q); 
k=16.5;
%Feedback connection of multiple models
sys_c = feedback(Q*k,1); 
disp(sys_c);
figure(2);
%this is to plot the step response.
%Step response of dynamic system
step(sys_c);  
%why there is a difference between the actual settling time of the close-loop
%system and the settling time of the system with just the two chosen closedloop poles?
% Because Ts=4/ξWn  
%num = [16.5, 49.5, 33];
%den = [1, 20.5, 54.5, 39];
%H = tf(num,den);
sys_approx= balred(sys_c,2);
disp(sys_approx);

figure(3);
rlocus(sys_c);
figure(4);
rlocus(sys_approx);
