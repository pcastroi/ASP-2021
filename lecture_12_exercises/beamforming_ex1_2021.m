%% Acoustic Signal Processing 22001
% Beamforming - Exercise 1
% Fall 2020
% Samuel A. Verburg - saveri@elektro.dtu.dk

clc; clear

%% Define constants and load data
% Define speed of sound (in m/s)
c = 343; 

% Load the uniform linear array (ULA) data
% - recordings: L x nMics matrix with the signals of length L recorded by the nMics ULA mics.
% - mic_positions: nMics x 2 matrix with the position of the ULA mics. in 2D
% - fs: sampling frequency used for the recordings
load('ex1_data.mat')

% Plot the ULA mics. in 2D
figure 
scatter(mic_positions(:,1), mic_positions(:,2))
title('Mic. positions')
xlabel('x [m]'); ylabel('y [m]'); axis equal

% Take only the first column of mic_positions since the mics are placed along the x-axis
r = mic_positions(:,1);

% TO DO: Define nMics as the number of mics in the ULA and L as the length of the signals
% write your code here: 
nMics = 11;
% write your code here : 
L = 10;


% TO DO: Calculate the spacing between ULA mics. d.
% write your code here: 
d = 0.1;

% TO DO: Calculate the aperture length D (distance between the two most distant ULA mics.)
% write your code here: 
D = ;


%% Fourier Transform of the recordings
% TO DO: Using L and fs, calculate the frequency vector f (from 0 to fs/2-fs/L)
% write your code here: f = ...;


% TO DO: Calculate the wavenumbers k for the frequencies f
% write your code here: k = ...;


% TO DO: Calculate fft of the recordings
% write your code here: p = ...;


% TO DO: Define p1 as the one-sided spectrum (i.e. length(p1) = length(f) = nFreq)
% write your code here: p1 = ...;

nFreq = length(p1);

% TO DO: Plot the spectrum to identify the dominant frequency 
% write your code here: plot(...)

% Find the index of the dominant frequency
[~, iF] = max(abs(p1(1,:)));
disp(['The dominat frequency is ' num2str(f(iF)) ' Hz.'])

%% Define steering directions
% Number of steering directions nDirect
nDirect = 180;

% TO DO: define the steering directions uniformly from -pi/2 to pi/2 rads.
% write your code here: theta = ...;


%% Calculate the steering vector and beamformer output for the dominant frequency
% TO DO: Calculate r_1, the position of each mic. relative to the 1st mic.
% write your code here: r_1 = ...;


% TO DO: Using r_1 and theta, calculate the delays (phase shifts) that we
% need to introduce in each mic signal to steer the beam in each direction theta
% The matrix delay will thus be of size nMic x nDirect
% write your code here: delay = ...;


% TO DO: Calculate the steering vector v for the i^th frequency bin using k and delay
% write your code here: v = ...;

    
% TO DO: Calculate the beamformer output b for the dominant frequency using v and p1
% write your code here: b = ...;


% TO DO: Calculate the beamformer output power for plotting
% write your code here: beta = ...;


% Plot of the beamformer output power (in dB)
[~, iPeaks] = findpeaks(beta,'SortStr','descend');

figure
plot(180*theta/pi, 10*log10(beta));
hold on
scatter(180*theta(iPeaks(1:2))/pi, 10*log10(beta(iPeaks(1:2))))
title('Beamformer output power')
xlabel('Theta [deg]'); 

disp(['The direction of the 1st source is ' num2str(180*theta(iPeaks(1))/pi) ' deg.'])
disp(['The direction of the 2nd source is ' num2str(180*theta(iPeaks(2))/pi) ' deg.'])
