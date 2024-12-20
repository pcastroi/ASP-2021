clear
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: Biquad filters (LECTURE 07, SLIDE 40)
% •	write a function genFilterBiquad.m 
% •	visualize frequency response of different biquad filter types
% •	cascade two filters (e.g. two biquad low-pass filters or a low-pass
%   filter and a high-pass filter) 


%% ANALYZE BIQUAD FILTER
% 
% 
% Sampling frequency in Hertz
fs = 16E3;


%% CASCADE TWO LOW-PASS FILTERS
% 
% 
fc = 4E3;
type = 'lowpass';
[b1,a1] = genFilterBiquad(fs,fc,type);

%% CASCADE A LOW-PASS AND A HIGH-PASS FILTER
% 
% 
fc = 1E3;
type = 'highpass';
[b2,a2] = genFilterBiquad(fs,fc,type);

%% Verify Implementation + Plots
N_DFT=1024;

%Two Low-Pass Filters
a_2lp=convolve(a1,a1); 
b_2lp=convolve(b1,b1);

%Low-Pass and High-Pass
a_lphp=convolve(a1,a2); 
b_lphp=convolve(b1,b2);

[H1,w1] = calcFreqResponse(b_2lp,a_2lp,N_DFT);
[H2,w2] = calcFreqResponse(b_lphp,a_lphp,N_DFT);


figure
plot(w1,H1);
hold on
plot(w2,H2);
legend('Two Low-Pass Filters','Low-Pass and High-Pass Filters');grid on;
title('Linear Response H(w)')
hold off

figure
HdB1 = 20 * log10(abs(H1));
HdB2 = 20 * log10(abs(H2)); 
plot(w1,HdB1);
hold on
plot(w2,HdB2);
legend('Two Low-Pass Filters','Low-Pass and High-Pass Filters');grid on;
title('Magnitude Response |H(w)|')
hold off

figure
Hang1 = angle(H1);
Hang2 = angle(H2); 
plot(w1,Hang1);
hold on
plot(w2,Hang2);
legend('Two Low-Pass Filters','Low-Pass and High-Pass Filters');grid on;
title('Phase Response H(w)')
hold off


