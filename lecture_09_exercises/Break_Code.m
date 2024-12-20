clear
close all
clc

% Install subfolders
addpath irs
addpath signals
addpath tools

%% Break-Coding Task
% USER PARAMETERS 
% Sampling frequency
fsHz = 48000;

% Window duration
winSec = 1;

% Noise duration
noiSec = winSec*100;

% Create Windows
N = 2*round(winSec*fsHz/2);
R = N;
M = pow2(nextpow2(N));
w1 = genWin(N,'rect','periodic');
w2 = genWin(N,'hann','periodic');

% Default parameters
x = randn(1,2*round(noiSec*fsHz/2));
y = randn(1,2*round(noiSec*fsHz/2));

x=x';
y=y';

% STFT analysis
[X, t, f] = stft(x,fsHz,w1,R,M);
[Y, t, f] = stft(y,fsHz,w2,R,M);

% Time-averaging of power spectra
XX = mean(X .* conj(X),2); % Rect Window
YY = mean(Y .* conj(Y),2); % Hamming Window
XY = mean(X .* conj(Y),2);

figure
hold on
semilogx(f,XX);
semilogx(f,YY);
semilogx(f,abs(XY));
legend('XX','YY','XY')
grid on
hold off