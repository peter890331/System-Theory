%Q1:
clear all, close all, clc
load testSys;

%% Q2:
hsvs = hsvd(sysFull); % Hankel singular values
figure
subplot(1,2,1)
semilogy(hsvs,'k','LineWidth',2)
hold on, grid on
semilogy(r,hsvs(r),'bo','LineWidth',2)
ylim([10^(-15) 100])
subplot(1,2,2)
plot(0:length(hsvs),[0; cumsum(hsvs)/sum(hsvs)],'k','LineWidth',2)
hold on, grid on
plot(r,sum(hsvs(1:r))/sum(hsvs),'bo','LineWidth',2)
set(gcf,'Position',[1 1 550 200])
set(gcf,'PaperPositionMode','auto')

%% Q3:
r=7;
figure
plot(0:length(hsvs),[0; cumsum(hsvs)/sum(hsvs)],'k','LineWidth',2)
hold on, grid on
plot(r,sum(hsvs(1:r))/sum(hsvs),'bo','LineWidth',2)
set(gcf,'Position',[1 1 550 200])
set(gcf,'PaperPositionMode','auto')

%% Q4:
sysBT = balred(sysFull,r);  % Balanced truncation

%% Q5:
figure
step(sysFull,0:1:50), hold on;
step(sysBT,0:1:50)

%% GA:
dt = 0.001;
PopSize = 25;
MaxGenerations = 10;
s = tf('s');
G = 1/((s+6)^2);

options = optimoptions(@ga,'PopulationSize',PopSize,'MaxGenerations',MaxGenerations);
[x,fval] = ga(@(K)pidtest(G,dt,K),3,-eye(3),zeros(3,1),[],[],[],[],[],options);
x