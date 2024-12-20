clear 
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: Inverse filter (LECTURE 04, Slide 33)
% 
% (1) Apply windowing and zero-padding to the sweep to create the
% measurement signal. Implement the windowing in fade.m, and zero-padding
% in padZeros.m
% (2) Construct the inverse filter for the measurement signal (use the
% getInverse.m template).
% (3) Plot the inverse filter time and frequency domains.
% (4) Apply the inverse filter to the original sweep.


%% USER PARAMETERS
% 
% 
fs = 48000; % Sampling frequency
Tsweep = 1; % Sweep duration
f0 = 1; % Start frequency
f1 = fs/2; % Stop frequency
Tsilence = 1; % Silence duration
Tin = 2E-3; % Fade-in duration
Tout = 1E-4; % Fade-out duration

% Select linear or exponential frequency increase
isExp = true;

N = 2^9; % Number of samples
Ws = 2^9; % Window Size

% Rectangular window
w = ones(1,Ws);
% Step size
R = N/2; % Hop Length depends of the N samples for each frame
M = N*2; % Frame Size depends of the N samples for each frame

%% CREATE SIGNALS
% 
% 
% Generate the measurement signal
s_exp = genMeasSig(Tsweep,fs,f0,f1,Tsilence,Tin,Tout,isExp);

%% Create the inverse filter
% 
%
% Implement the following function using the provided template.
[hinvB, Hinv] = getInverse(s_exp);

% Investigate the inverse filter by looking at the time signal, the
% magnitude spectrum, etc.

DRdB = 80;
t1 = linspace(0,Tsweep+Tsilence,length(hinvB));

YdB1 = 20 * log10(abs(Hinv)); 
fHz1 = linspace(f0,f1,length(Hinv));

[X,T,F] = stft(hinvB,fs,w,R,M);
XdB = 20 * log10(abs(X));
range = [max(XdB(:)) - DRdB max(XdB(:))];


%% Plotting 1
d = tiledlayout(3,3,'Padding','Compact');
nexttile(2)
plot(t1,hinvB);
grid on;
xlabel('Time (s)')
ylabel('Amplitude')
title('Deconvolution Filter')
xlim([t1(1) t1(end)])

nexttile(5)
imagesc(T(:)',F(:),XdB,range);
axis xy;
ylim([0 fs/2])
colorbar;
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT')

nexttile(8)
semilogx(fHz1,YdB1);
xlim([0 fs/2])
grid on;
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Magnitude Spectrum')

%% What happens if the sweep signal does not span the entire frequency range?
% Your deconvoluton filter is not going to have information for all f
% The impulse response cannot be a delta because we are missing information

%% Ploting 2
t3 = linspace(0,Tsweep+Tsilence,length(s_exp));

YdB2 = 20 * log10(abs(fft(s_exp))); 
fHz2 = linspace(f0,f1,length(fft(s_exp)));

[X2,T2,F2] = stft(s_exp,fs,w,R,M);
XdB2 = 20 * log10(abs(X2));
range2 = [max(XdB2(:)) - DRdB max(XdB2(:))];

nexttile(1)
plot(t3,s_exp);
grid on;
xlabel('Time (s)')
ylabel('Amplitude')
title('Measurement Signal')
xlim([t3(1) t3(end)])

nexttile(4)
imagesc(T2(:)',F2(:),XdB2,range2);
axis xy;
ylim([0 fs/2])
colorbar;
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT')

nexttile(7)
semilogx(fHz2,YdB2);
xlim([0 fs/2])
grid on;
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
title('Magnitude Spectrum')


%% Apply the inverse filter to the original sweep
imp_r=getIR(s_exp,Hinv);
IMP_r=fft(imp_r);

t2 = linspace(0,Tsweep+Tsilence,length(imp_r));

% IMP_rdB = 20 * log10(abs(IMP_r)); 
fHz2 = linspace(f0,f1,length(IMP_r));

[I,Ti,Fi] = stft(imp_r,fs,w,R,M);
IdB = 20 * log10(abs(I));
rangeI = [max(IdB(:)) - DRdB max(IdB(:))];

%% Plotting 3
nexttile(3)
plot(t2,imp_r);
grid on;
xlabel('Time (s)')
ylabel('Amplitude')
title('Impulse Response (Dirac´s \delta)')
xlim([t2(1) t2(end)])

nexttile(6)
imagesc(Ti(:)',Fi(:),IdB,rangeI);
axis xy;
ylim([0 fs/2])
xlim([0 0.02])
colorbar;
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT')

nexttile(9)
semilogx(fHz2,abs(IMP_r));
xlim([0 fs/2])
ylim([0 2])
grid on;
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Amplitude "Spectrum"')