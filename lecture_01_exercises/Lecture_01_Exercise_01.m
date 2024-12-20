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
fs=24*10^3;
f0=0.1*10^3;
f1=10*10^3;
T=2;
phi0=0;

%% CREATE CHIRP SIGNAL
%
%

[x,t] = genChirp(fs,f0,T,f1,phi0);

%% ITERATE ACROSS DECIMATION FACTORS
%  
% 
Dn=[1,2,4];
for k=1:numel(Dn)
    D=Dn(k);
    fs=(24*10^3)/D;
    [x,t] = genChirp(fs,f0,T,f1,phi0);
    pause(4);
    sound(x);
end

