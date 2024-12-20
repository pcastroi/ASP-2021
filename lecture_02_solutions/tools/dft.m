function [X,w] = dft(x,bLoop)
%dft   Compute the discrete Fourier transform (DFT)
%
%USAGE
%   [X,w] = dft(x)
%   [X,w] = dft(x,bLoop)
%
%INPUT ARGUMENTS
%       x : length-N input signal (N x 1 | 1 x N) (x must be a vector)
%   bLoop : binary flag (default, bLoop = true)
%           if true  => DFT is computed using two for-loops
%           if false => DFT is computed using complex matrix multiplication
%
%OUTPUT ARGUMENTS
%   X : complex DFT spectrum
%   w : normalized frequency vector in radians/sample [N x 1]
%
%   dft(...) plots the DFT in a new figure.
%
%   See also idft.

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
if nargin < 1 || nargin > 2
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 2 || isempty(bLoop); bLoop = true; end

% Check if input is a vector
if min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Ensure x is a colum vector
    x = x(:);
    
    % Measure number of samples
    N = numel(x);
end


%% COMPUTE DFT
%
%
if bLoop
    % ===============================
    % Compute DFT using two for-loops
    % ===============================
    % Allocate memory
    X = zeros(N,1);
    w = zeros(N,1);
        
    % Loop over the number of frequencies
    for k = 0 : N - 1
        
        % Frequency axis
        w(k+1) = 2 * pi .* k / N;
        
        % Loop over the number of samples
        for n = 0 : N - 1
            
            % DFT sum
            X(k+1) = X(k+1) + x(n+1) * exp(-1j * 2 * pi / N * n * k);
        end
    end
else
    % ===============================================
    % Compute DFT using complex matrix multiplication
    % ===============================================
    % Sample and frequency indices
    n = 0:1:N-1;
    k = 0:1:N-1;
    
    % Exponential basis functions
    wN = exp(-1j * 2 * pi / N);
    
    % DFT matrix
    W = wN.^(n'*k);
    
    % Calculate the DFT
    X = W * x;
    
    % Frequency axis
    w = 2 * pi .* k' / N;
end


%% PLOT SPECTRUM
%
%
% If no output is specified
if nargout == 0
    figure;
    hold on;
    plot(w/pi,abs(X),'color',[0 0.3895 0.9712],'linewidth',1.5)
    legend({'DFT'})
    xlabel('$\omega_{k} / \pi$','interpreter','latex')
    ylabel('$|X[k]|$','interpreter','latex')
    grid on;
    xlim([w(1)/pi w(end)/pi])
end
