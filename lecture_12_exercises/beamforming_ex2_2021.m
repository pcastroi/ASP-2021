%% Acoustic Signal Processing 22001
% Beamforming - Exercise 2
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
load('ex2_data.mat')

% Plot the ULA mics. in 2D
figure 
scatter(mic_positions(:,1), mic_positions(:,2))
title('Mic. positions')
xlabel('x [m]'); ylabel('y [m]'); axis equal

% Take only the first column of mic_positions since the mics are placed along the x-axis
r = mic_positions(:,1); 

% Play recording for the first mic. (make sure headphones/speaker are conneted)
soundsc(recordings(:,1), fs)

% TO DO: Define nMics as the number of mics in the ULA and L as the length of the signals
% write your code here: nMics = ...;
% write your code here : L = ...;


% TO DO: Calculate the spacing between ULA mics. d.
% write your code here: d = ...;

% TO DO: Calculate the aperture length D (distance between the two most distant ULA mics.)
% write your code here: D = ...;

% TO DO: Calculate the max. frequency that the ULA can resolve.
% write your code here: f_ULA = ...;

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

%% Define steering directions
% Number of steering directions nDirect
nDirect = 180;

% TO DO: define the steering directions uniformly from -pi/2 to pi/2 rads.
% write your code here: theta = ...;


%% Calculate the steering vector and beamformer output for each frequency
% TO DO: Calculate r_1, the position of each mic. relative to the 1st mic.
% write your code here: r_1 = ...;


% TO DO: Using r_1 and theta, calculate the delays (phase shifts) that we
% need to introduce in each mic signal to steer the beam in each direction theta
% The matrix delay will thus be of size nMic x nDirect
% write your code here: delay = ...;


% Initialize the beamformer output b
b = zeros(nDirect,nFreq);

% Calculte the beamformer output for each frequency bin
for iF = 1:nFreq
    % TO DO: Calculate the steering vector v for the i^th frequency bin using k and delay
    % write your code here: v = ...;

    
    % TO DO: Calculate the beamformer output b for the i^th frequency bin using v and p1
    % write your code here: b(:,iF) = ...;

    
end

% TO DO: Calculate the beamformer output power for plotting
% write your code here: beta = ...;


% Plot of the beamformer output power (in dB) across frequencies
% - observe the aliasing above f_ULA
% - observe how the low frequencies are not very directional (why?)
figure
imagesc(180*theta/pi, f, 10*log10(beta.'));
ylim([50, f_ULA*2]) 
title('Beamformer output power')
ylabel('Frequency [Hz]'); xlabel('Theta [deg]'); 
set(gca,'YDir','normal');

%% Cumulative beamformer power
% TO DO: Calculate the cumulative beamformer power across frequency. 
% Do NOT include the frequencies above f_ULA (f > f_ULA) and the less 
% directional low frequencies (e.g. freqs. lower than 500 Hz).
% write your code here: beta_cum = ...;



% Find the direction of the two sources present in the signals
[peak,iPeak] = findpeaks(beta_cum); 

% Plot beta_cum to observe the directions
figure
plot(180*theta/pi, beta_cum); 
hold on
scatter(180*theta(iPeak)/pi, peak)
title('Cumulative beamformer power')
xlabel('steering direction [deg]'); ylabel('beamformer output power')

%% Filter recordings
% Calculate the inverse Fourier transform of the beamformer output 
% corresponding to the direction of speech (in this case that is the first
% peak iPeak(1))
b_s = ifft([b(iPeak(1),:), flip(conj(b(iPeak(1),2:end)),2)]);

% Listen to the original recording
soundsc(recordings(:,1), fs)
pause(L/fs)
clear playsnd
pause(1)

% Listen to the filtered speech
% - note that the low frequencies are not denoised (why?)
% - note the artifacts present in the background noise (why?)  
soundsc(b_s,fs)



