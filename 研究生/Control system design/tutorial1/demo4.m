s = tf('s');
G = 10/( s^2 + 2*s+4); 
Ks = 1*(2*s+1)/(0.1*s+1); 
Q = Ks*G;
figure(2);
bode(Q);
sys_c = feedback(Q,1); % to form closed loop transfer function
%with unity feedback
figure(3);
step(sys_c, 10) %this is to plot the step response covering the
%first 10 s