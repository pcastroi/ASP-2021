clear
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: Frequency response of filters (LECTURE 07, SLIDE 18)
% •	write a function calcFreqResponse.m 
% •	create FIR and IIR moving average filter coefficients 
% •	calculate and visualize frequency response of FIR and IIR filter


%% USER SETTINGS 
% 
% 
% Sampling frequency in Hertz
fs = 16E3;

% Length of moving average FIR filter
L = 5;


%% CREATE FIR AND IIR FILTERS
% 
% 
% FIR filter coefficients
bFIR = ones(L,1)/L;

% Sampling period
Ts = 1 / fs;

% Map FIR filter length to IIR time constant
tau = L * Ts;

% Smoothing coefficient
alpha = exp(-Ts/tau);

% IIR filter coefficients
bIIR = 1-alpha;
aIIR = [1 -alpha];


%% COMPUTE FREQUENCY RESPONSE
% 
% 
% Compute frequency response of FIR filter
[H_FIR,w] = calcFreqResponse(bFIR);

% Compute frequency response of IIR filter
H_IIR = calcFreqResponse(bIIR,aIIR);


%% VISUALIZE RESULTS
% 
% 
% Magnitude response
figure;
subplot(211)
hold on;
plot(w/pi,20*log10(abs(H_FIR)))
plot(w/pi,20*log10(abs(H_IIR)))
grid on;
xlim([0 1])
ylim([-60 0])
xlabel('$\omega / \pi$','interpreter','latex')
ylabel('$20 \log_{10}(|H(\omega)|)$','interpreter','latex')
legend({'FIR' 'IIR'})

% Phase response
subplot(212)
hold on;
plot(w/pi,angle(H_FIR))
plot(w/pi,angle(H_IIR))
grid on;
xlim([0 1])
xlabel('$\omega / \pi$','interpreter','latex')
ylabel('$\angle H(\omega)$','interpreter','latex')
