% Clear stuff
clear variables
clear mex
close all
clc

%% Add paths
%addpath audio-playback tools
addpath('C:\Users\jbru\Documents\Local\22001\31210 - Acoustic Signal Processing\module_01_exercises\audio-playback');

startupHeaAudio %You need the audio-playback HEA toolbox from Module 01

%% User parameters
%fs = 48000;         %Hz, sampling frequency
fs = 12000; 
dt=1/fs;

% STFT parameters
N_stft = 2^10;  %2^14   %STFT window size in samples
nRepetitions = 100;   %number of repetitions

%silenceSec = 0;     %s, silence in the end
%cut_time=0.5;       %s, cut time in the begining (to avoid the initial tansient phase)

amp=0.1;       %amplitude out signal

channelsPlay = [1]; % Channels you will play signal to
channelsRec = [1 2]; % Channels you will record signal from


overlap = 0;       % window overlap (not implemented)
%  winType = 'hann'; % window type = Hanning
winType = 'rect';  % window type = Rectangular/Uniform

% 'pseudo' or 'random'
%  noiseType = 'random';
 noiseType = 'pseudo';

%Psuedo-noise
% N_prn=N_stft;
N_prn=2^18; %Change here for non-syncroniced prn



%% Create the test signal

switch(noiseType)
    case 'random'

        % Noise
        x = amp*randn(N_stft * nRepetitions,1);
        
    case 'pseudo'
        
        % Noise
        x = repmat(amp*randn(N_prn,1),[nRepetitions 1]);
            
end

N_total = length(x);

% Add silence
%x = cat(1,zeros(N_zeros_start,1),x,zeros(N_zeros_end,1));

% Noise with silence period
%x = cat(1,amp*randn(nSamples,1),zeros(round(fs * silenceSec),1));


%% Create the player object
%player = audioUtility('channelsPlay',channelsPlay,...
%    'channelsRec',channelsRec,'fs',fs); % This is the equivalent
player = HeaAudioDSP('channelsPlay',channelsPlay,'channelsRec',channelsRec,'fs',fs,...
    'devicePlayName','Focusrite USB (Focusrite USB Audio)',...
    'deviceRecName','Focusrite USB (Focusrite USB Audio)');

%% Play and record
%for measurment
y = player.playrec(x); %for random noise

%for simulations
% Sdof
m = 50e-2;
r = 1;
s = 1e5;
%SDOF_parameters = [m, r, s]; % m, r, s
% a = sdofBox(x,fs,m,r,s);%F=x; 
% y = [x a];

%
%cut=cut_time/dt; %cut away the first cut_time s
%samples_left=cut:length(x);
%y=y(samples_left,:);
%x=x(samples_left);
t=(0:(length(y(:,1))-1))*dt;

% Plot the recorded signal
figure
plot(t,[x y]')
legend('Played signal (x)','Recorded signal (y) - F','Recorded signal (y) - a')

F=y(:,1);
a=y(:,2);



%% ESTIMATE AUTO- AND CROSS-SPECTRAL DENSITIES
% 
% 
% STFT parameters
N=N_stft;
R = N - round(N * overlap);
M = pow2(ceil(log2(N)));
w = genWin(N,winType);

% STFT analysis
%X = stft(FTrim,fs,w,R,M);
%Y = stft(aTrim,fs,w,R,M);
X = stft(F,fs,w,R,M);
Y = stft(a,fs,w,R,M);

% Single-sided spectra
X = X(1:M/2+1,2:nRepetitions-1);
Y = Y(1:M/2+1,2:nRepetitions-1);

% Time-averaging
XX = mean(X .* conj(X),2);
YY = mean(Y .* conj(Y),2);
XY = mean(X .* conj(Y),2);


%% ESTIMATE H1, H2, COHERENCE AND SNR
% 
% 
% H1 estimate: Sensitivity to input noise
H1 = XY ./ XX;

% H2 estimate: Sensitivity to output noise
H2 = YY ./ conj(XY);

% Coherence
C = abs(XY).^2 ./ (XX .* YY); % => C = H1 ./ H2;

% SNR
SNR = C ./ (1 - C);



f=[1:length(XX)]*fs/length(XX);

figure(2)
loglog(f,abs(H1),f,abs(H2))
title('|H_1| and |H_2|')
legend('|H_1|','|H_2|')
ax=axis;
axis([0 fs/2 ax(3) ax(4)])
%axis([500 1000 0 1])

figure(3)
semilogx(f,C)
title('Coherence')
axis([0 fs/2 0 1])
%axis([500 1000 0 1])

save([datestr(now,'HH_MM_SS_') 'Real.mat']);
   


