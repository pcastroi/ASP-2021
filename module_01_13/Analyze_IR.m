%% Clear stuff
clear
close all
clc

%% Install subfolders
addpath irs
addpath signals
addpath tools

%% user parameters
% Sampling frequency
% fs = 48E3;

%% LOAD RESPONSE
%
% Load impulse response
% h = readIR(roomName,fs);

% meas_2021_10_5_16_18_18 / meas_2021_10_5_16_24_11
% sil/sweep 1-4/4-1

% meas_2021_10_5_16_21_45 / meas_2021_10_5_16_28_45
% sil/sweep 1-8/4-4

filename = 'meas_2021_10_5_16_21_45'; 
load(filename);

% STFT parameters
N = 1024;          % Window size
M = N;             % Number of DFT points
R = 512;           % Step size
w = blackman(N);   % Analysis window

DRdB = 100;

%% Choose the Impulse response
for i=1:width(h_norm)
h = h_norm(:,i);

% Perform STFT analysis of the recorded sweep
[Y,tSec,fHz] = stft(y(:,i),fs,w,R,M);
H = stft(h,fs,w,R,M);

% Plot STFTs
a=plotSTFT(tSec,fHz,Y,fs,false,DRdB);title(['Recording']);
b=plotSTFT(tSec,fHz,H,fs,false,DRdB);title(['Impulse Response']);

% Trunacte and select which IRs to process
% Truncate the IR (if needed) to remove most of the part that is just noise,
% keeping a short part to allow estimating the noise floor.

%% Calculate the EDC and reverberation time

% Choose an appropriate truncation time for the EDC calculation
trunctime = 3; % no truncation if trunctime = length(h)/fs

% Calculate the EDC
[EDC_log, t] = calcEDC(h, fs, trunctime);

% Plot the EDC
ETC_log = 10*log10(h.^2);
figure
title(['Channel' ' ' num2str(i)]);
hold on
plot (t,ETC_log) %choose truncation time by looking at this plot 
             %(when there is no decay anymore, it is only backgroud noise)

% Choose appropriate fitting points for the RT60 calculation
L1 = -5;
L2 = -25;
L3 = -35;

% Select which EDC to process
% Calculate  the reverberation time
getReverbTime(EDC_log, fs, L1, L2)
getReverbTime(EDC_log, fs, L1, L3)
% %% Direct-to-reverberant energy ratio
% % Select IRs with different source to receiver distances
% 
% % Split the direct path and the reverberant tail
% timeDirect = ;
% [d,r] = splitIR(h(:,1:2),fs,timeDirect);
% 
% % Calculate the DRR
% drr = ;
% 
% %% ENERGY DECAY RELIEF (STFT)
% %
% % Minimum EDR in dB
% floordB = ;
% % Window size
% winSec = ;
% 
% % Block size and step size
% N = 2 * round(winSec * fs / 2);
% R = round(N / 4);
% 
% % Create analysis and synthesis window function
% w = cola(N,R,'hamming','ola');
% 
% % DFT size
% M = pow2(nextpow2(N));
% 
% % STFT
% 
% % Energy decay relief in dB
% 
% % Normalize to 0 dB
% 
% % Truncate to floordB
% 
% % Plot the EDRdB

end
% %%
