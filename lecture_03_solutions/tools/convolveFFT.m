function y = convolveFFT(x,h)
%convolveFFT   Linear convolution of two vectors using the FFT.
%
%USAGE
%   y = convolveFFT(x,h)
%
%INPUT ARGUMENTS
%   x : input sequence [N x 1 | 1 x N]
%   h : impulse response [M x 1 | 1 x M]
%
%OUTPUT ARGUMENTS
%   y : output sequence [N + M - 1 x 1]
%
%   See also convolve.

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


%% LINEAR CONVOLUTION VIA CIRCULAR CONVOLUTION USING THE DFT
%
%
% Length of output sequence
L = N + M - 1;

% Zero-padding
x = cat(1,x,zeros(L - N,1));
h = cat(1,h,zeros(L - M,1));

% DFTs
X = fft(x);
H = fft(h);

% Multiplication in the frequency domain
Y = X .* H;

% Go back to time domain
y = real(ifft(Y));

