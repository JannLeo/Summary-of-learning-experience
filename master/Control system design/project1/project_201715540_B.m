%% Task5
s = tf('s');
G = 4/(0.9*s^2 + s+1); 
Ks = 1;
Q = Ks*G;
figure(1);
bode(Q); %to produce Bode diagrams for G(s)*K(s)

%% Task 6
clear;
s = tf('s');
G = 4/(0.9*s^2 + s+1); 
%the results of the lead compensator
%the value of k, a = 𝛼 and tau = 𝜏 values
k=3.53;
a=5.55;
tau=0.0692;
Ks = k*(a*tau*s+1)/(tau*s+1); 
Q = Ks*G;
figure(2);
bode(Q); %to produce Bode diagrams for G(s)*K(s)
sys_c = feedback(Q,1); % to form closed loop transfer function with unity feedback
figure(3);
step(sys_c, 10) %this is to plot the step response covering the first 10 s

%% Task 7
s = tf('s');
G = 4/(0.9*s^2 + s+1); 
%the results of the lead compensator
%the value of k, a = 𝛼 and tau = 𝜏 values
k=3.53;
a=5.55;
tau=0.0692;
Klead = k*(a*tau*s+1)/(tau*s+1); 
Q_lead = Klead*G;
sys_lead = feedback(Q_lead,1); 
%the results of the lag compensator based on the lead compensator
%the value of klag, a1 = 𝛼1 and tau1 = 𝜏1 values
a1=0.143;
tau1=4.314;
Klag = 1/a1*(a1*tau1*s+1)/(tau1*s+1);
Ks = Klead*Klag;
Q_leadlag = Ks*G;
figure(2);
bode(Q_lead,Q_leadlag); %to produce Bode diagrams include the 
legend("Task_6_lead","Task_7_leadlag");%add the tag to the two diagram
sys_leadlag = feedback(Q_leadlag,1); 
figure(3);
step(sys_lead,sys_leadlag, 10)
legend("Task_6_lead","Task_7_leadlag");%add the tag to the two diagram

%% Task 7.3
clear;
s = tf('s');
G = 4/(0.9*s^2 + s+1); 
Ks = 6.73; % the scalar controller
Q = Ks*G;
sys_c = feedback(Q,1); 
%the results of the lead compensator
%the value of k, a = 𝛼 and tau = 𝜏 values
k=3.53;
a=5.55;
tau=0.0692;
Klead = k*(a*tau*s+1)/(tau*s+1); 
Q_lead = Klead*G;
sys_lead = feedback(Q_lead,1); 
%the results of the lag compensator based on the lead compensator
%the value of klag, a1 = 𝛼1 and tau1 = 𝜏1 values
a1=0.143;
tau1=4.314;
Klag = 1/a1*(a1*tau1*s+1)/(tau1*s+1);
Ks = Klead*Klag;
Q_leadlag = Ks*G;
sys_leadlag = feedback(Q_leadlag,1); 
figure(3);
step(sys_lead,sys_leadlag,sys_c, 10);
legend("Task_6_lead","Task_7_leadlag","Task_7.3_scalar");%add the tag to the three diagram
