%% 计算虚数的模  用于计算经过点的K值
s=-3+4.8j;
a=(s+5)*(s+2)*(s+1.7)/(s+2.64);
abs(a)

%% 计算dB
a=7.6;
gain=10^(a/20);

%% 草稿
x=1/(0.8674+0.0529j);



%% 根据已知ξ wn 计算fd tf tr tp M0 ts
clear all;
E=0.31;
wn=6;
wd=wn*(sqrt(1-E^2));
fd=wd/(2*pi);
tf=1/fd;
tr=1.8/wn;
tp=pi/(wn*sqrt(1-(E^2)));
M0=exp((-1*E*pi)/(sqrt(1-E^2)));
ts=-4/(E*wn);

%% 求导
syms x;  % 定义符号变量 x
f = (x*(x+1))/((x+2)*(x+3));  % 定义一个函数
df_dx = diff(f, x);  % 计算导数
disp(df_dx);  % 显示导数表达式

%% 化简
syms s;

% 定义一个符号表达式
expr = (3*s^2+18*s)*(s+1)-(s^3+9*s^2);

% 使用 simplify 函数进行化简
simplified_expr = simplify(expr);

% 显示原始表达式和化简后的表达式
disp(['原始表达式： ' char(expr)]);
disp(['化简后的表达式： ' char(simplified_expr)]);

%% 解方程
% z^2-1.17z+0.338
% 使用 roots 函数解方程
roots_result = roots([1 -1.17 0.338]);

% 显示解
disp(['方程的根为: ' num2str(roots_result)]);


%% 求两点的距离
% 定义点A和点B的坐标
x1 = -3;
y1 = 4.8;

x2 = -2.64;
y2 = 0;

% 计算欧氏距离
distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);

% 显示结果
fprintf('两点之间的欧氏距离为: %.2f\n', distance);


%% Task1  画根轨迹
% Copy the root locus plot and present in your report. [1 mark]
% 1.2) Based on the root locus you have plotted, in the report, show the lowest 
% settling time at which the step response of the closed-loop system can 
% achieve, and justify your answers in the report. [2 marks]
% (Hint: Identify two conjugate complex poles on the loci which would give 
% the lowest settling time for an approximated second order system.)
clear all;
s = tf('s');
% G = (s+2)/((s^2 + s + 7.5)*(s+5)); 
G = (s+1)/(s^2*(s+9)); 
Ks = 1;
Q = Ks*G;
figure(1);
%Open loop locus of the G
rlocus(Q); 
% % Approximated second order system, which is calculated by close loop transfer function.
% sys_approx=(0.325*s+0.65)/(s^2 + 4.392*s + 12.85); 
% % Calculate the open loop transfer function to plot the open loop locus
% sys_1=sys_approx/(1-sys_approx);
% figure(2);
% rlocus(sys_1); 
% % From the figure 2 we can know the gain when the two-conjugate complex
% % poles meet.
% k=17.3;
% % Calculate close loop transfer function and multiple the k into it.
% sys=feedback(sys_1*k,1);
% figure(3);
% step(sys); 
%% Task2 设计PD控制器
% 2.1) Calculate the value of z1. This value should be positive. [3 marks]
% (Hint: Refer to lecture notes. Find the open loop poles and zeros first, and then 
% use phase condition to find the zero position for the given closed-loop poles).
% 2.2) Calculate the gain of the PD controller or the value of k. This value should 
% be positive. [1 mark]
% 2.3) Follow the verification steps listed below, copy all Matlab plots and present 
% these plots in the report. [1 mark] 
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


%% Task3  设计PID控制器
% 3.1) Re-calculate the new z1 and k values. [3 marks]
% [Hint: Again use the phase condition to find the zero position for the given closedloop poles.]
% 3.2) Follow the verification steps listed below, copy all the Matlab plots and present 
% these plots in the report. [1 mark]

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
%  Based on the root locus and step responses you have plotted, compare the 
% effects of PD controller and that of PID controller. [1 mark]
% 4.2) Modify the above codes to plot the step response for scalar controller with 
% the proportional gain of your own choice and compare its effect with that of PD 
% and PID controller. [2 marks
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


%% Task5
% 5.1) Copy the bode diagrams plotted above, and present in the report. Then 
% based on the bode diagrams, estimate the phase margin PM and crossover 
% frequency 𝜔𝑜 from the bode diagrams. [1 mark]
% 5.2) Derive the closed-loop transfer functions (considering the closed-loop 
% system employs unity-gain negative feedback control). [1 mark]
% [Hint: Note that the closed loop transfer function is 𝑇(𝑠) =
% 𝐺(𝑠)𝐾(𝑠)
% 1+𝐺(𝑠)𝐾(𝑠)
% and 𝜔𝑛 must 
% be obtained from the denominator of 𝑇(𝑠) as it may have non-unity DC gain.]
% 5.3) Check if the closed-loop bandwidth (≈ 𝜔𝑛) is approximately equal to the 
% crossover frequency (𝜔0), and the phase margin (in degrees) approximately equal to 
% the closed-loop damping ratio, 𝜁 × 100. [1 mark
s = tf('s');
G = 4/(0.9*s^2 + s+1); 
Ks = 1;
Q = Ks*G;
figure(1);
bode(Q); %to produce Bode diagrams for G(s)*K(s)

%% Task 6
% 6.1) Select 6.13 rad/s as the desirable crossover frequency. 
% 6.2) From the plotted Bode diagrams in task 5, determine the gain and phase 
% of the system at this frequency. 
% 6.3) Design a phase lead compensator for 𝐾(𝑠) which gives a crossover 
% frequency at 6.13 rad/s in 6.1) and a phase margin of 55
% o
% . [4 marks]
% [Hint: Refer to the lecture notes and tutorial questions to design a phase lead 
% compensator. Note that the transfer function of the lead compensator is 𝐾(𝑠) =
% 𝑘 (
% 𝛼𝜏𝑠+1
% 𝜏𝑠+1
% )].
% 6.4) Follow the steps given below, copy the plots and present in the report. Then 
% from the plots, predict the rise time, settling time and amount of overshoot of a closed 
% loop system’s step response. [1 mark]
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
% 7.1) Design the lag compensator based on the required steady-state error (i.e. 0.01 
% unit). [3 marks]
% [Hint: refer to the lecture notes and online tutorials. You can set 𝜔1 to be 10 times 
% less than the crossover frequency 𝜔𝑜 for the lead compensator designed in task 6].
% 7.2) Follow the steps given below, copy the plots and present in the report. Then 
% based on the Bode plots and step responses you have plotted, discuss and compare 
% the effects of phase lead and lead-lag compensators. [2 marks]
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

