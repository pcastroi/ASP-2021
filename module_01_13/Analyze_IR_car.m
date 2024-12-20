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
fsHz = 48E3;

% Impulse response
% roomName = ;

%% LOAD RESPONSE
%
% Load impulse response
% h = readIR(roomName,fsHz); 
h = readIR('S1R1.wav',fsHz);
h = h(:,1);
% h = readIR('C:\Users\carol\Desktop\r1.wav',fsHz);
% teste=itaAudio;
% teste.time=[h];
% T = length(h)/fsHz; %measurement time
% t = 0:1/fsHz:T-1/fsHz;
% t = t.';

%% Truncate and select which IRs to process
% Truncate the IR (if needed) to remove most of the part that is just noise,
% keeping a short part to allow estimating the noise floor.

[hmax,sp] = max(h); %find starting point
h = [h(sp:end)];

% win = ones(length(h(:,1)),1); % creates a window w/ the IR length
% tt = 7; %truncation time
% win(fsHz*tt+1:end) = 0; % after tt secs everything = 0
% figure()
% plot(t,win); hold on; plot (t,h)
% title('truncating IR')
% legend('window','IR')
% 
% h_win = h.*win;
% figure()
% plot (t,h); hold on; plot (t,h_win)
% title('truncated IR')
% legend('before','after')

%% Calculate the EDC and reverberation time
% Choose an appropriate truncation time for the EDC calculation
trunctime = 1.5; %truncation time in seconds

% Calculate the EDC
[ EDC_log, t ] = calcEDC( h, fsHz, trunctime );

% Plot the EDC

ETC = 10*log10(h.^2);
figure()
plot (t,ETC) %choose truncation time by looking at this plot 
             %(when there is no decay anymore, it is only backgroud noise)
hold on
plot(t,EDC_log)
grid on


%% Choose appropriate fitting points for the RT60 calculation
L1 = -5;
L2 = -25;

% Select which EDC to process
% Calculate  the reverberation time
getReverbTime( EDC_log(:,1), fsHz, L1, L2)

%% Direct-to-reverberant energy ratio
% Select IRs with different source to receiver distances

% Split the direct path and the reverberant tail
% timeDirect = ;
% [d,r] = splitIR(h(:,1:2),fsHz,timeDirect);

% Calculate the DRR
% drr = ;

%% ENERGY DECAY RELIEF (STFT)
%
% Minimum EDR in dB
% floordB = ;
% Window size
% winSec = ;

% Block size and step size
% N = 2 * round(winSec * fsHz / 2);
% R = round(N / 4);

% Create analysis and synthesis window function
% w = cola(N,R,'hamming','ola');

% DFT size
% M = pow2(nextpow2(N));

% STFT

% Energy decay relief in dB

% Normalize to 0 dB

% Truncate to floordB

% Plot the EDRdB
%%
