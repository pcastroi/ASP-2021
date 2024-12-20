clear
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: DFT (LECTURE 02, SLIDE 17)
% •	write a function dft.m 
% •	write a function idft.m 
% •	write a function genSin.m 
% •	initialize user parameters (e.g. sampling frequency, parameters of the
%   sinusoid ... etc)  
% •	create a sinusoid x with multiple frequency components
% •	compute X = dft(x); and plot its magnitude spectrum in dB
% •	compute y = idft(X); and calculate the RMS between the reconstructed
%   time domain y signal and the original input signal x


%% USER PARAMETERS
% 
% 
f0 = [1000 2000 5000];
A0 = [1 1 1];
fs = 16000;
T = 0.02;

%% CREATE SIGNAL
% 
% 
[x,t] = genSin(fs,T,f0,A0);
figure
plot(t,x);
title('Signal');


%% FREQUENCY ANALYSIS
% 
% 
[X,w] = dft(x);
figure
plot((w*fs/(2*pi)),mag2db(abs(X))); % Should be simmetrical but the values are that low that matlab represents noise
title('DFT of the signal');


%% RECONSTRUCT TIME DOMAIN SIGNAL
% 
% 
y = idft(X);
figure
plot(t,y);
title('IDFT of DFT');

%% ROOT MEAN SQUARE ERROR
%
%
RMSE = sqrt(mean((x-y).^2));