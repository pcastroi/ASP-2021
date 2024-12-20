clear
close all
clc

% Install subfolders 
addpath tools
addpath signals


%% EXERCISE: Uniform quantization (LECTURE 01, SLIDE 36)
% •	write a function quantize.m 
% •	initialize user parameters (e.g. number of bits)  
% •	load and normalize a speech signal x such that its maximum is 1
% •	perform quantization 
% •	listen to the quantized signal 


%% USER PARAMETERS
% 
% 
% Vector with number of bits
bits = [12 10 8 5];

% Select type of uniform quantizer (either 'midtread' or 'midrise')
type = 'midrise'; 


%% CREATE SIGNAL
% 
% 
% Load speech file
[x,fs] = readAudio('speech@24kHz.wav');

% Normalize signal to have a maximum of one
x = x / max(abs(x));


%% PERFORM QUANTIZATION
%
%
% Number of bits
nBits = numel(bits);

% Loop over the number of bits
for ii = 1:nBits
    
    % Uniform quantization
    y = quantize(x,bits(ii),type);
          
    % Playback signal
    disp(['Press any key to play the quantized signal with b = ',...
        num2str(bits(ii)),' bits.'])
    pause;    
    soundsc(y,fs)
end

 