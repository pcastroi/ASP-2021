clear
close all
clc

% Random signal duration
Nx = ceil(1E3 * rand(1));

% Signal creation
x = randn(Nx,1);

% Window size
N = 8;

% Step size
R = 4;

% Overlap
O = N - R;

% Compute the number of frames
L = ceil((Nx - O) / R);

% Zero-padd input such that it can be divided into an integer number of
% frames 
x = cat(1,x,zeros(round((O + L * R) - Nx),1));

% Loop over the number of frames
for ii = 0 : L - 1
    
    % Sample indices
    idx = (1:N) + ii * R;
    
    % Time segmentation
    xHat = x(idx);
    
    % Windowing & zero-padding
    
    % DFT
    
end
