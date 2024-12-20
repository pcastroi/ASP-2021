%% Lecture 9
%
%
clear
close all
clc

% Install subfolders
addpath irs
addpath signals
addpath tools

% Sampling frequency
fsHz = 48000;

% Window duration
winSec = 1;

% Noise duration
noiSec = winSec*100;

% Create Windows
N = 2*round(winSec*fsHz/2);
R = N;
M = pow2(nextpow2(N));
w1 = genWin(N,'rect','periodic');
w2 = genWin(N,'hann','periodic');

x = randn(1,2*round(noiSec*fsHz/2));
x = x(:);
[y] = blackBox(x,fsHz,'system_a'); %Error system_b and system_c (zeropad)

%% Task 1
% FRF estimates
[H1,H2,C,f] = computeFRF(x,y,fsHz,w2,R,M);
%% Task 3
m=1;
r=1;
s=3.9478E7;

Model_par=[m r s];

[outSigT3] = sdofBox(x,fsHz,Model_par,length(x));
[H1T3,H2T3,CT3,fT3] = computeFRF(x,outSigT3,fsHz,w2,R,M);

%% Plots
% Coherence
figure
subplot(2,1,1)
plot(f,C);
title('Coherence of x and blackbox')
subplot(2,1,2)
plot(fT3,CT3);
title('Coherence of x and sdofBox')