clear all, close all, clc

%% Q2:
s = tf('s');
G = (s + 4) / (s^2 + 4*s +3)
%a:
figure(1)
step(G)
%b:
figure(2)
impulse(G)

%c:
[A, B, C, D] = tf2ss([1 4], [1 4 3]);
obsv(A, C)
rank(obsv(A, C))

%d:
%C = [1 0]
Baug = [B eye(2) 0*B]; % [u I*wd 0*wn]
Daug = [0 0 0 1];   % D matrix passes noise through
sysC = ss(A,Baug,C,Daug);
%[b, a] = ss2tf(A, Baug, C, Daug);

dt = .01;
t = dt:dt:50;

uDIST = 0*randn(2,size(t,2)); % random disturbance
uNOISE = 0.05*randn(size(t));    % random noise
u = 0*t;
u(1:end) = 1;
uAUG = [u; uDIST; uNOISE];  % input w/ disturbance and noise

[y,t] = lsim(sysC,uAUG,t);         % noisy measurement

figure(3)
plot(t,y,'Color',[.5 .5 .5])
hold on

%e:
Vd = zeros(2);  % disturbance covariance
Vn = 0.05;       % noise covariance

% alternatively, possible to design using "LQR" code
%[Kf,P,E] = lqe(A,eye(2),C,Vd,Vn);  % design Kalman filter
Kf = (lqr(A',C',Vd,Vn))';   

%f:
sysTruth = ss(A,Baug,C,zeros(size(C,1),size(Baug,2)));
sysKF = ss(A-Kf*C,[B Kf],eye(2),0*[B Kf]);  % Kalman filter

[xtrue,t] = lsim(sysTruth,uAUG,t); % true state
[xhat,t] = lsim(sysKF,[u; y'],t);  % state estimate

%figure(4)
plot(t,xhat(:,1),'-','Color','r','LineWidth',2)
hold on
plot(t,xtrue(:,1),'Color',[0 0 0],'LineWidth',2)

%g:
figure(5)
[a, b] = ss2tf(A-Kf*C, [B Kf], eye(2), 0*[B Kf],1);
bode(a,b)