%% Clear stuff
clear 
close all
clc

% Install subfolders
addpath tools

%% EXERCISE: Recovering the IR (LECTURE 04, Slide 34)
% (1) Create the function getIR.m that returns the IR of system given its
% output to the measurement signal and the inverse filter.

% (2) Check the 3 presets of the provided "black box" system
% (Test_Black_Box.m). Measure the IRs using your system.

% (3) Characterize the presets based on analyzing your measured IRs.

%% User parameters
fs = 48000; % Sampling frequency
Tsweep = 1; % Sweep duration
f0 = 10; % Start frequency
f1 = fs/2; % Stop frequency
Tsilence = 1; % Silence duration
Tin = 2E-3; % Fade-in duration
Tout = 1E-4; % Fade-out duration

% Select linear or exponential frequency increase
isExp = true;

%% Generate sweep signal
s_exp = genMeasSig(Tsweep,fs,f0,f1,Tsilence,Tin,Tout,isExp);
s_exp2 = genMeasSig(Tsweep,fs,f0,f1,Tsilence+1,Tin,Tout,isExp);


%% Create the inverse filter
[hinv, Hinv] = getInverse(s_exp);
[hinv2, Hinv2] = getInverse(s_exp2);


%% Create a measurement system
% Implement the function below:
h = getIR(s_exp, Hinv);
h2 = getIR(s_exp2, Hinv2);


%% Investigate the black box system
yA = blackBox(s_exp,fs,'system_a');
yB = blackBox(s_exp,fs,'system_b');
yC = blackBox(s_exp,fs,'system_c');

hA = getIR(yA, Hinv);
hB = getIR(yB, Hinv2(1:end-1));
hC = getIR(yC, Hinv2(1:end-1));

t = (1:size(s_exp,1))./fs;
t2 = (1:size(s_exp2(1:end-1),1))./fs;
figure
hold on
plot(t,hA)
plot(t2,hB,t2,hC)
hold off
xlim([0 0.5])
xlabel('Time [s]');
ylabel('Amplitude');
legend({'system a' 'system b' 'system c'});

% STFT parameters
N = 1024;          % Window size
M = N;             % Number of DFT points
R = 512;           % Step size
w = blackman(N);   % Analysis window

% Perform STFT analysis
[YA,tSec,fHz] = stft(yA,fs,w,R,M);
YB = stft(yB,fs,w,R,M);
YC = stft(yC,fs,w,R,M);
HA = stft(hA,fs,w,R,M);
HB = stft(hB,fs,w,R,M);
HC = stft(hC,fs,w,R,M);
 
% Dynamic range of the spectrogram in dB
DRdB = 100;

% Plot spectrograms
plotSTFT(tSec,fHz,YA,fs,false,DRdB);title('Recorded sweep (system a)');
plotSTFT(tSec,fHz,YB,fs,false,DRdB);title('Recorded sweep (system b)');
plotSTFT(tSec,fHz,YC,fs,false,DRdB);title('Recorded sweep (system c)');
plotSTFT(tSec,fHz,HA,fs,false,DRdB);title('Impulse response (system a)');
plotSTFT(tSec,fHz,HB,fs,false,DRdB);title('Impulse response (system b)');
plotSTFT(tSec,fHz,HC,fs,false,DRdB);title('Impulse response (system c)');


