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
% Sampling frequency
fsHz = 16E3;

% Duration in seconds
T = 20E-3;

% Vector with frequency components
f0 = [1000 2000 5000];

% Vector with amplitude values
A0 = [1 1 1];


%% CREATE SIGNAL
% 
% 
% Create a sinusoid with multiple frequency components
x = genSin(fsHz,T,f0,A0);


%% FREQUENCY ANALYSIS
% 
% 
% Compute DFT 
[X,w] = dft(x);

% Magnitude spectrum in dB
XdB = 10 * log10(abs(X).^2);

% Convert normalized angular frequencies to frequencies in Hertz
fHz = fsHz / (2 * pi) * w;

% Plot magnitude spectrum
figure;
plot(fHz,XdB);
xlim([0 fsHz/2])
grid on;
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')


%% RECONSTRUCT TIME DOMAIN SIGNAL
% 
% 
% Reconstruct time domain signal
y = idft(X);

% Check root mean square (RMS) error between x and y
assert(rms(x-y) < 1E-10,'x and y differ.')
