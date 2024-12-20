clear
close all
clc

% Install subfolders 
addpath tools
addpath signals


%% EXERCISE: Aliasing (LECTURE 01, SLIDE 22 - 24)
% •	write a function genChirp.m 
% •	initialize user parameters (e.g. sampling frequency, chirp parameters,
%   decimation factors ... etc)  
% •	create a chirp signal x
% •	downsample x using various decimation factors (D = 1, 2 and 4) and
%   listen to the resulting signals 
% •	preprocess x with an FIR filter (b = fir1(31,0.95/D)) prior to
%   downsampling and listen to the resulting signals
% •	repeat the previous two points using a speech signal


%% USER PARAMETERS
% 
% 
fsHz = 24E3;   % Sampling frequency in Hertz
f0Hz = 100;    % Instantaneous frequency in Hertz at time 0
f1Hz = 10000;  % Instantaneous frequency in Hertz at time TSec
TSec = 2;      % Chirp duration in seconds

% Binary flag indicating if a chirp or a speech signal should be used
bChirp = true;

% Decimation factors
decim = [1 2 4];


%% CREATE SIGNAL
%
%
% Check if chirp is requested
if bChirp
    % Chirp signal
    data = genChirp(fsHz,f0Hz,TSec,f1Hz);
else
    % Speech file
    data = readAudio('speech@24kHz.wav',fsHz); %#ok
end


%% ITERATE ACROSS DECIMATION FACTORS
%  
% 
% Check if decimation factors are integer values
if any(rem(decim,1) ~= 0)
    error('Decimation factors must be integer values.')
end

% Number of iterations
nIter = numel(decim);

% Allocate memory
x = cell(nIter,1);
xLP = cell(nIter,1);

% Loop over number of iterations
for ii = 1 : nIter
    
    % Sampling frequency
    decimfsHz = fsHz / decim(ii); 
    
    % Design FIR low-pass filter
    b = fir1(31,0.95 / decim(ii));
    
    % Apply low-pass filter
    dataLP = filter(b,1,data);
    
    % Decimate signals
    x{ii} = data(1:decim(ii):end);
    xLP{ii} = dataLP(1:decim(ii):end);
    
    % Playback signals
    disp(['Press any key to play the decimated signal x (D = ',...
        num2str(decim(ii)),').'])
    pause;
    soundsc(x{ii},decimfsHz)
    disp(['Press any key to play the low-pass filtered and decimated ',...
        'signal xLP (D = ',num2str(decim(ii)),').'])
    pause;
    soundsc(xLP{ii},decimfsHz)
end
