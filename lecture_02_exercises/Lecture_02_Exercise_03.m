clear
close all
clc

% Install subfolders
addpath tools
addpath signals


%% EXERCISE: STFT (LECTURE 02, SLIDE 46)
% •	write a function stft.m 
% •	initialize user parameters (sampling frequency, STFT parameters ... etc)
% •	load a signal x (e.g. speech or a linear chirp signal)
% •	visualize the STFT in dB for different window sizes


%% USER PARAMETERS
%
%
f0 = 0;
fs = 16000;
T = 2;
f1 = fs/2;
phi0 = 0;
N = 2^10;
% Rectangular window
Ws = 2^8;
w = ones(1,Ws);
% Step size
R = N/2; % Hop Length depends of the N samples for each frame
M = N*2; % Frame Size depends of the N samples for each frame


%% CREATE SIGNAL
%
%
[x,t] = genChirp(fs,f0,T,f1,phi0);
% [x,fs] = readAudio('DoYouDareToComputeTheSTFT.wav');
%% STFT
% 
% 
[X,t,f] = stft(x,fs,w,R,M);

%% STFT Plot
%
%
% Default settings for plotting
bLog = false;
DRdB = 60; 
h = plotSTFT(t,f,X,fs,bLog,DRdB);