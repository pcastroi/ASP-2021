clear
close all
clc

% Install subfolders
addpath signals
addpath tools

% Reset seed of random generator to guarantee reproducibility
rng(0);


%% USER PARAMETERS
% 
% 
% Sampling frequency
fsHz = 16E3;

% Number of bins used for histogram analysis
nBins = 128;

% SNR in dB
snrdB = 5;

% Source signal
fileName = 'l01s09.wav';


%% CREATE SIGNALS
% 
% 
% Load source signal
s = readAudio(fileName,fsHz);

% Create white Gaussian noise
d = randn(size(s));

% Mix speech with noise at predefined SNR
[x,s,d] = adjustSNR(s,d,snrdB);


%% SHOW PDFs
% 
% 
% Histogram analysis of clean speech
measurePDF(s,nBins,{'gamma' 'gaussian'});
title('Speech');

% Histogram analysis of noise 
measurePDF(d,nBins,'gaussian');
title('Noise');

% Histogram analysis of noisy speech
measurePDF(x,nBins,{'gamma' 'gaussian'});
title(['Noisy speech @ ',num2str(snrdB),' dB SNR']);
