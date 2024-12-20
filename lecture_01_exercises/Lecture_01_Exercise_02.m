clear
close all
clc

% Install subfolders 
addpath tools
addpath signals


%% EXERCISE: Uniform quantization (LECTURE 01, SLIDE 30)
% •	write a function quantize.m 
% •	initialize user parameters (e.g. number of bits)  
% •	load and normalize a speech signal x such that its maximum is 1
% •	perform quantization 
% •	listen to the quantized signal 


%% USER PARAMETERS
% 
% 
xMin=-1;
xMax=1;
nBits=4; % Can be changed to see the differences

%% CREATE SIGNAL
% 
% 
[x,fs] = readAudio('speech@24kHz.wav');
x = x / max(abs(x));

%% PERFORM QUANTIZATION
%
%
y = quantize(x,nBits,xMin,xMax);
plot(y);
soundsc(y,fs);
