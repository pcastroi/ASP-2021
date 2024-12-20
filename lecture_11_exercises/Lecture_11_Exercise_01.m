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

% SNR in dB
snrdB = 5;

% Source signal
fileName = 'l01s09.wav';

% Window length
winSec = 32E-3;

% Initial noise-only segment
initSec = 100E-3; % [0.1 0.5 1]

% Smoothing time constant for the decision-direct approach
tauSec = 0.396;

% Gain functions
gain = {...
    'gss'     ,...
    'mmse'    ,...
    'logmmse' ,...
    };


%% CREATE SIGNALS
% 
% 
% Load source signal
s = readAudio(fileName,fsHz);

% Number of zeros
nZeros = round(initSec*fsHz);

% Zero-pad speech signal
s = cat(1,zeros(nZeros,1),s);

% Create white Gaussian noise
d = randn(size(s));

% Compute scaling factor
[~,~,~,G] = adjustSNR(s(nZeros+1:end),d(nZeros+1:end),snrdB);

% Scale the noise
d = d * G;

% Mix speech with noise
x = s + d;


%% PERFORM NOISE REDUCTION
%
%
% Number of gain functions
nMethods = numel(gain);

% Allocate memory
sHat = zeros(numel(x),nMethods);

% Loop over the number of gain functions
for ii = 1 : numel(gain)
    
    % Perform noise reduction
denoise(x,fsHz,winSec,tauSec,initSec,gain{ii});
end

%% LISTEN 
% 
% 
if 0
    soundsc(x,fsHz);
    soundsc(sHat(:,1),fsHz);
    soundsc(sHat(:,2),fsHz);
    soundsc(sHat(:,3),fsHz);
end

