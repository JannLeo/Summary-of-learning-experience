%% Task1
s = tf('s');
% G = (s+2)/((s^2 + s + 7.5)*(s+5)); 
G = (s+1)/(s*(s-3)); 
Ks = 1;
Q = Ks*G;
figure(1);
%Open loop locus of the G
rlocus(Q); 
% Approximated second order system, which is calculated by close loop transfer function.
sys_approx=(0.325*s+0.65)/(s^2 + 4.392*s + 12.85); 
% Calculate the open loop transfer function to plot the open loop locus
sys_1=sys_approx/(1-sys_approx);
figure(2);
rlocus(sys_1); 
% From the figure 2 we can know the gain when the two-conjugate complex
% poles meet.
k=17.3;
% Calculate close loop transfer function and multiple the k into it.
sys=feedback(sys_1*k,1);
figure(3);
step(sys); 
%% Task2
clear;
s = tf('s');
G = (s+2)/( (s^2 + s + 7.5)*(s+5)); 
Ks = (s+7.636); %The calculated PD contoller
Q = Ks*G;
figure(2);
rlocus(Q); 
k = 6.837; %when the point is (5,±5j), the k (gain) is equal to 6.837
sys_c = feedback(Q*k,1);
figure(3);
step(sys_c); %this is to plot the step response.


%% Task3
clear;
s = tf('s');
G = (s+2)/( (s^2 + s + 7.5)*(s+5)); 
Ks = (s+6.224)*(s+2)/s; %Calculated PID controller
Q = Ks*G;
figure(4);
rlocus(Q); 
k = 9.10; % when the point is (5,±5j), the k (gain) is equal to 9.10
sys_c = feedback(Q*k,1); 
disp(sys_c);
figure(5);
step(sys_c); % this is to plot the step response.
%% Task4
clear;
s = tf('s');
G = (s+2)/( (s^2 + s + 7.5)*(s+5)); 
Ks_PD = (s+7.636); %the value of z1 we have calculated (PD controller).
Q_PD = Ks_PD*G;
k = 6.837;
sys_PD = feedback(Q_PD*k,1);
Ks = (s+6.224)*(s+2)/s; %the value of z1 we have calculated (PID controller).
Q_PID = Ks*G;
figure(4);
rlocus(Q_PD,Q_PID);  % this is to plot the open loop locus
legend("Task_2_PD","Task_3_PID");
k = 9.10;
sys_PID = feedback(Q_PID*k,1); 
figure(5);
step(sys_PD,sys_PID); % this is to plot the step response.
legend("Task_2_PD","Task_3_PID");

%% Task4.2
s = tf('s');
G = (s+2)/( (s^2 + s + 7.5)*(s+5)); 
Ks = 114.514; %the dynamic part of the controller is set to 1.
Q = Ks*G;
sys_c = feedback(Q,1); 
figure(5);
step(sys_c); 

Ks_PD = (s+7.636); %the value of z1 we have calculated (PD controller).
Q_PD = Ks_PD*G;
k = 6.837;
sys_PD = feedback(Q_PD*k,1);
Ks = (s+6.224)*(s+2)/s; %the value of z1 we have calculated (PID controller).
Q_PID = Ks*G;

k = 9.10;
sys_PID = feedback(Q_PID*k,1); 
figure(5);
step(sys_PD,sys_PID,sys_c); % this is to plot the step response.
legend("Task_2_PD","Task_3_PID","Task_4_Progain");

