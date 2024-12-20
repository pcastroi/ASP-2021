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
fsHz = 48000;

% Source signal
fileName = 'speech@24kHz.wav';

% Select either 'system_a', 'system_b' or 'system_c'
preset = 'system_a';


%% CREATE SIGNALS
% 
% 
% Load source signal
x = readAudio(fileName,fsHz);

% Apply black box
y = blackBox(x,fsHz,preset);


%% PLOT RESULTS
% 
% 
% Show system input and output 
figure;
plot(x)
hold on;
plot(y)
legend({'input' 'output'})
title(strrep(preset,'_',' '))


%% Play input and output sounds
% 
% 
if 0
    soundsc(x,fsHz);
    soundsc(y,fsHz);
end
