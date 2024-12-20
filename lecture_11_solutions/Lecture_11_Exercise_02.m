clear
% close all
clc

% Install subfolders
addpath signals
addpath tools

% Reset seed of random generator to guarantee reproducibility
rng(0);


%% USER PARAMETERS
% 
% 
% Sampling frequency
fsHz = 16E3;

% SNR in dB
snrdB = 10;

% Source signal
fileName = 'l01s09.wav';

% STFT window length in seconds
winSec = 32E-3;

% Initial noise-only segment
initSec = 1000E-3;

% Smoothing time constant for the decision-direct approach
tauSec = 0.396;

% Gain functions
gain = {...
    'gss'     ,...
    'logmmse' ,...
    };


%% CREATE SIGNALS
% 
% 
% Load source signal
s = readAudio(fileName,fsHz);

% Number of zeros
nZeros = round(initSec*fsHz);

% Zero-pad speech signal
s = cat(1,zeros(nZeros,1),s);

% Create white Gaussian noise
d = randn(size(s));

% Compute scaling factor
[~,~,~,C] = adjustSNR(s(nZeros+1:end),d(nZeros+1:end),snrdB);

% Scale the noise
d = d * C;

% Mix speech with noise
x = s + d;


%% PERFORM NOISE REDUCTION
%
%
% Number of gain functions
nMethods = numel(gain);

% Allocate memory
sHat = zeros(numel(x),nMethods);

% Loop over the number of gain functions
for ii = 1 : numel(gain)
    
    % Perform noise reduction
    sHat(:,ii) = denoise(x,fsHz,winSec,tauSec,initSec,gain{ii});
end


%% STFT ANALYSIS
% 
% 
% Analyze noisy speech
[X,tSec,fHz] = stft(x,fsHz);

% Allocate memory for enhanced spectra
Y = zeros([size(X),numel(gain)]);

% Analyze enhanced speech
for ii = 1 : numel(gain)
    Y(:,:,ii) = stft(sHat(:,ii),fsHz);
end

% Find maximum across all STFT representations (normalize maximum to 0 dB)
maxVal = max(cat(1,abs(X(:)),abs(Y(:))));

% Noisy speech
figure;
imagesc(tSec,fHz,20 * log10(abs(X)/maxVal),[-60 0]);
axis xy;
ylim([0 fsHz/2]);
colormap(colormapVoicebox);
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Noisy speech $|X[k,\lambda]|^2$','interpreter','latex')
colorbar;

% Enhanced speech
for ii = 1 : numel(gain)
    figure;
    imagesc(tSec,fHz,20 * log10(abs(Y(:,:,ii))/maxVal),[-60 0]);
    axis xy;
    ylim([0 fsHz/2]);
    colormap(colormapVoicebox);
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    title(['Enhanced speech $\hat{S}[k,\lambda]$ using ',...
        upper(gain{ii})],'interpreter','latex')
    colorbar;
end

    
%% LISTEN 
% 
% 
if 0
    soundsc(x,fsHz)
    soundsc(sHat(:,1),fsHz)
    soundsc(sHat(:,2),fsHz)
end