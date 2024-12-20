function y = convolve(x,h)
%convolve   Linear convolution of two vectors in the time domain.
% 
%USAGE
%   y = convolve(x,h)
% 
%INPUT ARGUMENTS
%   x : input sequence [N x 1 | 1 x N]
%   h : impulse response [M x 1 | 1 x M]
% 
%OUTPUT ARGUMENTS
%   y : output sequence [N + M - 1 x 1]
% 
%   See also convolveFFT.

%   Developed with Matlab 9.2.0.538062 (R2017a). Please send bug reports to
%   
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark (DTU)
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/08/12
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin ~= 2
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Get dimensions
xDim = size(x);
hDim = size(h);

% Check if x and h are vectors
if min(xDim) > 1 || min(hDim) > 1
    error('x and h must be vectors.')
else
    % Ensure column vectors
    x = x(:);
    h = h(:);
    
    % Dimensionality of x and h
    N = max(xDim);
    M = max(hDim);
end


%% DIRECT IMPLEMENTATION OF CONVOLUTION SUM
% 
% 
% Length of output sequence
L = N + M - 1;

% Allocate memory
y = zeros(L,1);

% Loop over length of output sequence
for nn = 0 : L - 1
    
    % Loop over the number of overlapping samples
    for mm = 0 : nn
       
        % Calculate convolution sum for indices where x[mm] and h[nn-mm]
        % overlap by at least one element
        if mm <= N - 1 && (nn - mm >= 0 && nn - mm <= M - 1)
            y(nn + 1) = y(nn + 1) + x(mm + 1) * h(nn - mm + 1);
        end
    end
end
