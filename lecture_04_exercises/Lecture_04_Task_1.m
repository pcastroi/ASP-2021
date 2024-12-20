clear
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: Exponential sweep (LECTURE 04, Slide 21)
%
% (1) Derive the expression for the exponential sweep
% (2) Extend the function genChirp.m to include exponential sweeps
% (3) Create a linear and an exponential chirp
% (4) Compare the two signals in the time, frequency and STFT domain


%% USER PARAMETERS
% 
% 
fs = 48000; % Sampling frequency
T = 1; % Sweep duration
f0 = 10; % Start frequency
f1 = fs/2; % Stop frequency
phi0 = 0; % Phase offset

% Select linear or exponential frequency increase
isExp1 = false;
isExp2 = true;

N = 2^9; % Number of samples
Ws = 100; % Window size


% Rectangular window
w = ones(1,Ws);
% Step size
R = N/2; % Hop Length depends of the N samples for each frame
M = N*2; % Frame Size depends of the N samples for each frame


%% CREATE SIGNALS
% 
% 
% Create a linear sweep 
[x1,t1] = genChirp(fs,f0,T,f1,phi0,isExp1);
% Create a logarithmic sweep
[x2,t2] = genChirp(fs,f0,T,f1,phi0,isExp2);


%% FREQUENCY ANALYSIS
% 
% 
% Calculate the magnitude spectra
Y1 = fft(x1,length(x1));
YdB1 = 20 * log10(abs(Y1)); % Magnitude spectrum in dB
Y2 = fft(x2,length(x2));
YdB2 = 20 * log10(abs(Y2)); % Magnitude spectrum in dB
fHz = linspace(f0,f1,fs); 

% Calculate the STFTs
[X1,T1,F1] = stft(x1,fs,w,R,M);
[X2,T2,F2] = stft(x2,fs,w,R,M);

%% SHOW RESULTS
% 
% 
d = tiledlayout(3,2,'Padding','Compact');
% Plot the time-domain signals
nexttile
plot(t1,x1);
grid on;
xlabel('Time (s)')
ylabel('Amplitude')
title('Linear chirp signal')
xlim([t1(1) t1(end)])

nexttile
plot(t2,x2);
grid on;
xlabel('Time (s)')
ylabel('Amplitude')
title('Exponential chirp signal')
xlim([t2(1) t2(end)])

% Plot the magnitude spectra // Why min(YdB1)=~40???
nexttile
semilogx(fHz,YdB1);
xlim([0 fs/2])
grid on;
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Magnitude Spectrum')


nexttile
semilogx(fHz,YdB2);
xlim([0 fs/2])
grid on;
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Magnitude Spectrum')


% Plot the STFTs
DRdB = 60;

% Spectrogram in dB
XdB1 = 20 * log10(abs(X1));
XdB2 = 20 * log10(abs(X2));

% Select dynamic range
range1 = [max(XdB1(:)) - DRdB max(XdB1(:))];
range2 = [max(XdB2(:)) - DRdB max(XdB2(:))];

% Select colormap
colormap(colormapVoicebox);

nexttile
imagesc(T1(:)',F1(:),XdB1,range1);
axis xy;
ylim([0 fs/2])
colorbar;
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT')

nexttile
imagesc(T2(:)',F2(:),XdB2,range2);
axis xy;
ylim([0 fs/2])
colorbar
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT')

bLog = true; % How can I make true work???
h1 = plotSTFT(T1,F1,X1,fs,bLog,DRdB);
h2 = plotSTFT(T2,F2,X2,fs,bLog,DRdB);