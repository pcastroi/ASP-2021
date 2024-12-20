clear
close all
clc

forit=1:10:1000;

filename={ '.mat' '.mat' '.mat'};
figure
hold on
load('HATS.mat')
plot(forit,DRR_temp)
load('RoomA.mat')
plot(forit,DRR_temp)
load('RoomD.mat')
plot(forit,DRR_temp)
load('Cortex45.mat')
plot(forit,DRR_temp)
legend('HATS','RoomA','RoomD','Cortex45','interpreter','latex')
title('tauSec length influence','interpreter','latex')
ylabel('$$\Delta$$DRR','interpreter','latex')
xlabel('$$\tau$$ (ms)','interpreter','latex')
hold off
