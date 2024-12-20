function [X,w] = dftRadix2Full(x)
%dftRadix2Full   Full Radix-2 decimation in time algorithm.
%
%USAGE
%   [X,w] = dftRadix2Full(x)
%
%INPUT ARGUMENTS
%   x : length-N input signal (N x 1 | 1 x N) 
%       (x must be a vector and N must be a power of two)
%
%OUTPUT ARGUMENTS
%   X : complex DFT spectrum [N x 1]
%   w : frequency vector in radians/sample [N x 1]
%
%   dftRadix2Full(...) plots the DFT in a new figure.
%
%   See also dftRadix2 and dftRadix2Recursive.

%   Developed with Matlab 9.2.0.538062 (R2017a). Please send bug reports to
%
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/08/19
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin ~= 1
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Check if input is a vector
if any(size(x) == 0)
    error('Input signal x is an empty array.')
elseif min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Number of samples
    N = numel(x);
end

% Check if N is a power of 2 ...
if rem(log2(N),1) ~= 0
    error('The length of the input signal must be a power of two.')
end


%% RADIX-2: DECIMATION IN TIME
% 
% 
% Number of decimation stages
nStages = log2(N);

% Permute input into bit-reversed order
X = bitrevorder(x);

% Loop over the number of stages
for nn = 1 : nStages
    L  = 2^nn;
    L2 = L / 2;
    for ir = 1 : L2
        W = exp(-1i * 2 * pi * (ir - 1) / L);
        for it = ir : L : N
            ib = it + L2;
            temp  = X(ib) * W;
            X(ib) = X(it) - temp;
            X(it) = X(it) + temp;
        end
    end    
end

% Frequency axis
w = 2 * pi .* (0:N-1) / N;
    

%% PLOT SPECTRUM
%
%
% If no output is specified
if nargout == 0
    
    % Normalized frequency axis
    wNorm = w / pi;
    
    figure;
    hold on;
    plot(wNorm,abs(X),'color',[0 0.3895 0.9712],'linewidth',1.5)
    legend({'DFT'})
    xlabel('$\omega_{k} / \pi$','interpreter','latex')
    ylabel('$|X[k]|$','interpreter','latex')
    grid on;
    xlim([0 wNorm(end)])
end
