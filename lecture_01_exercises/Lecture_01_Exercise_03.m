clear
close all
clc

% Install subfolders 
addpath tools
addpath signals


%% EXERCISE: Uniform versus nonuniform quantization (LECTURE 01, SLIDE 38)
% •	write the functions compress.m and expand.m 
% •	initialize user parameters (e.g. signal levels, number of bits ... etc)  
% •	implement the signal-to-quantization-noise ratio (SQNR) metric
% •	loop over the number of signal levels and adjust the level of x
% •	for a given signal level, loop over the number of bits
% •	compare uniform and nonuniform quantization using the SQNR metric
% •	plot the SQNR as a function of the signal level for both uniform and
%   nununiform quantization


%% USER PARAMETERS
% 
% 
xMin=-1;
xMax=1;
nBits=6; % Can be changed to see the differences
leveldB=-20; % Can be changed to see the differences
mu=255;

%% CREATE SIGNAL
% 
% 
[x,fs] = readAudio('speech@24kHz.wav');
x = x / max(abs(x));
xAdjusted = db2mag(leveldB) * x;

%% PERFORM QUANTIZATION AND SQNR ANALYSIS
% 
% 
y1 = quantize_2v(xAdjusted,nBits);
y2 = expand(quantize_2v(compress(xAdjusted,mu),nBits),mu);

sqnr_1 = 10*log10(var(y1)/var(y1-xAdjusted));
sqnr_2 = 10*log10(var(y2)/var(y2-xAdjusted));


%% PLOT RESULTS
% 
% 
figure
plot(y1,'g');
title('Original Signal vs Y1 vs Y2');
hold on
plot(y2,'r');
plot(xAdjusted);
hold off

