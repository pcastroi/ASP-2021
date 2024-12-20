function [X,w] = dftRadix2Recursive(x)
%dftRadix2Recursive   Recursive Radix-2 decimation in time algorithm. 
%
%USAGE
%   [X,w] = dftRadix2Recursive(x)
%
%INPUT ARGUMENTS
%   x : length-N input signal (N x 1 | 1 x N) (x must be a vector)
%
%OUTPUT ARGUMENTS
%   X : complex DFT spectrum [N x 1]
%   w : frequency vector in radians/sample [N x 1]
%
%   dftRadix2Recursive(...) plots the DFT in a new figure.
%
%   See also dftRadix2 and dftRadix2Full.

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

% Check if N is a power of 2
if rem(log2(N),1) ~= 0
    error('The length of the input signal must be a power of two.')
end


%% RECURSIVE RADIX-2: DECIMATION IN TIME
%
%
% Check if N is a power of 2 and larger or equal to 2
if rem(log2(N),1) == 0 && log2(N) > 0 
    % ============================================================
    % Radix-2: decimate by a factor of two
    % ============================================================
    % Split x into its even and odd-numbered components (Eq. 16)
    xe = x(1:2:N-1);
    xo = x(2:2:N);
    
    % Frequency vector
    kHalf = (0 : N/2-1)';
    
    % Exponential basis functions for N-point DFT
    % (only required for k=0,1,...,N/2-1)
    wN = exp(-1j*2*pi/N*kHalf);
        
    % Compute two N/2-point DFTs (Eq. 17)
    Xe = dftRadix2Recursive(xe(:));
    Xo = dftRadix2Recursive(xo(:));
        
    % Apply wN to Xo according to the butterfly simplification
    Xo = Xo .* wN;
    
    % Combine both N/2-point DFTs (Eq. 18)
    X = [Xe + Xo; Xe - Xo];
    
    % Frequency axis
    w = 2 * pi .* (0:N-1) / N;    
else
    % ============================================================
    % Problem can't be divided any further => compute DFT directly
    % ============================================================
    % Sample and frequency indices
    n = 0:1:N-1;
    k = 0:1:N-1;
    
    % Exponential basis functions
    wN = exp(-1j * 2 * pi / N);
    
    % DFT matrix
    w = wN.^(n'*k);
    
    % Calculate DFT
    X = w * x;
end


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
