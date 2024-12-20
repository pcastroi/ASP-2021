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

% Cut-off frequency in Hertz
fc = 4000;

% Filter type
type = 'lowpass';

% Create filter coefficients
[b,a] = genFilterBiquad(fs,fc,type);

% Compute frequency response
calcFreqResponse(b,a);
ylim([-60 0])
title('Low-pass filter')


%% CASCADE TWO LOW-PASS FILTERS
% 
% 
%  Convolve filter coefficients
b2 = convolve(b,b);
a2 = convolve(a,a);

% Compute frequency response
calcFreqResponse(b2,a2);
ylim([-60 0])
title('Two cascaded low-pass filter')


%% CASCADE A LOW-PASS AND A HIGH-PASS FILTER
% 
% 
% Low-pass filter parameters
fc1 = 4000;
type1 = 'lowpass';

% High-pass filter parameters
fc2 = 1000;
type2 = 'highpass';

% Create filter coefficients
[b1,a1] = genFilterBiquad(fs,fc1,type1);
[b2,a2] = genFilterBiquad(fs,fc2,type2);

%  Convolve filter coefficients
a3 = convolve(a1,a2);
b3 = convolve(b1,b2);

% Compute frequency response
calcFreqResponse(b3,a3);
ylim([-60 0])
title('Cascaded low- and high-pass filter')
