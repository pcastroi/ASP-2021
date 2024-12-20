clear
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: FFT (LECTURE 02, SLIDE 39)
% •	write a function dftRadix2.m 
% •	initialize user parameter N (e.g. N = 2^10)
% •	create a random sequence of N samples 
% •	use tic & toc commands to compare runtime of dft(x) and dftRadix2(x)


%% USER PARAMETERS
% 
% 
% Number of samples
N = 2^10;


%% CREATE SIGNAL
% 
% 
% Random sequence
x = randn(N,1);


%% COMPUTE DFT
% 
% 
% DFT using two for-loops
tic;
X1 = dft(x,true);
t1 = toc;

% DFT using matrix multiplication
tic;
X2 = dft(x,false);
t2 = toc;

% Radix-2: Decimation-in-time using two for-loops 
tic;
X3 = dftRadix2(x,true);
t3 = toc;

% Radix-2: Decimation-in-time using matrix multiplication
tic;
X4 = dftRadix2(x,false);
t4 = toc;

% Recursive Radix-2: Decimation-in-time 
tic;
X5 = dftRadix2Recursive(x);
t5 = toc;
 
% Full Radix-2: Decimation-in-time 
tic;
X6 = dftRadix2Full(x);
t6 = toc;

% Matlab's highly optimized FFT
tic;
X7 = fft(x);
t7 = toc;


%% SHOW RESULTS
% 
% 
% Display processing time
fprintf('DFT using two for-loops:\t\t\t\t\t\t%f seconds\n',t1);
fprintf('DFT using matrix multiplication:\t\t\t\t%f seconds\n',t2);
fprintf('DFT using Radix-2 (1 iteration, for-loops):\t\t%f seconds\n',t3);
fprintf('DFT using Radix-2 (1 iteration, matrix-based):\t%f seconds\n',t4);
fprintf('DFT using recursive Radix-2:\t\t\t\t\t%f seconds\n',t5);
fprintf('DFT using full Radix-2:\t\t\t\t\t\t\t%f seconds\n',t6);
fprintf('DFT using Matlabs FFT:\t\t\t\t\t\t\t%f seconds\n',t7);

% Error threshold 
thres = 1E-12;

% Check mean squared error between spectra
assert(calcMSE(abs(X1),abs(X7))<thres,'Spectra of dft and fft differ.')
assert(calcMSE(abs(X2),abs(X7))<thres,'Spectra of dft and fft differ.')
assert(calcMSE(abs(X3),abs(X7))<thres,'Spectra of fftRadix2 and fft differ.')
assert(calcMSE(abs(X4),abs(X7))<thres,'Spectra of dftRadix2Recursive and fft differ.')
assert(calcMSE(abs(X5),abs(X7))<thres,'Spectra of dftRadix2Full and fft differ.')
assert(calcMSE(abs(X6),abs(X7))<thres,'Spectra of dftRadix2Full and fft differ.')
