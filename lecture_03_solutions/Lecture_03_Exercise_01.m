clear
close all
clc

% Install subfolders
addpath tools


%% EXERCISE: Linear convolution (LECTURE 03, SLIDE 27)
% •	write a function convolve.m 
% •	verify your output y = convolve(x,h) with the result on slide 25


%% CREATE SIGNALS
% 
% 
% Input signal
x = [1 2 4 1 3];

% Impulse response
h = [2 1 2];


%% PERFORM CONVOLUTION
% 
% 
% Linear filtering
y = convolve(x,h) %#ok
