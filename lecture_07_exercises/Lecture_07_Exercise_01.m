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
% DFT Window Size
N_DFT=1024;

% x = randn(N_DFT,1); % Random signal

%% CREATE FIR AND IIR FILTERS
% 
% 

% FIR
b1=ones(1,L)/L;
a1=1;

% IIR
Ts=1/fs;
Tcon=L*Ts;
alfa=exp(-Ts/Tcon);
b2=1-alfa;
a2=[1,-alfa];

%% COMPUTE FREQUENCY RESPONSE
% 
% 
[H1,w1] = calcFreqResponse(b1,a1,N_DFT);
[H2,w2] = calcFreqResponse(b2,a2,N_DFT);

% y1=ifft(H1.*fft(x));
% y2=ifft(H2.*fft(x));

%% VISUALIZE RESULTS
% 
% 
figure
plot(w1,H1);
hold on
plot(w2,H2);
legend('FIR','IIR');grid on;
title('Linear Response H(w)')
hold off

figure
HdB1 = 20 * log10(abs(H1));
HdB2 = 20 * log10(abs(H2)); 
plot(w1,HdB1);
hold on
plot(w2,HdB2);
legend('FIR','IIR');grid on;
title('Magnitude Response |H(w)|')
hold off

figure
Hang1 = angle(H1);
Hang2 = angle(H2); 
plot(w1,Hang1);
hold on
plot(w2,Hang2);
legend('FIR','IIR');grid on;
title('Phase Response H(w)')
hold off

% figure
% plot(abs(y1));hold on;plot(abs(x))
% figure
% plot(abs(y2));hold on;plot(abs(x))