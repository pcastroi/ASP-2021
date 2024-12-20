clear
close all
clc

% Install subfolders
addpath irs
addpath signals
addpath tools


%% EXERCISE: Overlap-save method (LECTURE 03, SLIDE 52)
% •	write a function convolveFFT_OLS.m 
% •	select various BRIRs
% •	process left and right BRIR channels separately
% •	construct a binaural signal by combining the processed left- and right-ear channels
% •	listen to the binaural signal using soundsc()
% •	compare processing speed when using the function convolve (be careful,
%   this will only be possible for relatively short impulse responses) 


%% USER PARAMETERS
% 
% 
% Name of binaural room impulse response (BRIR)
fNameIR = 'washing_machine.wav';

% Signal name
fNameSignal = 'speech@24kHz.wav';


%% LOAD SIGNALS
% 
% 
% Read impulse response / Be careful, h is [nSamples x 2 channels]
[h,fsHz] = readIR(fNameIR);

% Read audio signal (automatically resample input to match the sampling
% frequency of the impulse response)  
x = readAudio(fNameSignal,fsHz);


%% PERFORM CONVOLUTION
% 
% 
% 
% DFT Size / Can be determined by minimizing Eq. 24
% N=2^4;
% Find the optimal N / DFT Size 
Nx = length(x);
M = length(h);
N = optimalN(Nx,M);

% Binary flag: x should be padded with M-1 zeros?
bZeroPad=true;

yL = convolveFFT_OLS(x,h(:,1),N,bZeroPad); % For the L channel
yR = convolveFFT_OLS(x,h(:,2),N,bZeroPad); % For the R channel

soundsc(cat(2,yL,yR),fsHz);