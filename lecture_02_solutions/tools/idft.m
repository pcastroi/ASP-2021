function x = idft(X,bLoop)
%idft   Compute the inverse discrete Fourier transform (IDFT)
%
%USAGE
%   x = idft(X)
%   x = idft(X,bLoop)
%
%INPUT ARGUMENTS
%       X : complex DFT spectrum (N x 1 | 1 x N) (X must be a vector)
%   bLoop : binary flag (default, bLoop = true) 
%           if true  => DFT is computed using two for-loops 
%           if false => DFT is computed using complex matrix multiplication 
%
%OUTPUT ARGUMENTS
%   x : length-N input signal (N x 1 | 1 x N) (x must be a vector)
%
%   idft(...) plots the IDFT in a new figure.
%
%   See also dft.

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
if min(size(X)) > 1
    error('Input signal x must be a vector.')
else
    % Ensure x is a colum vector
    X = X(:);

    % Measure number of samples
    N = numel(X);
end


%% COMPUTE IDFT
% 
% 
if bLoop
    % ================================
    % Compute IDFT using two for-loops
    % ================================
    % Allocate memory
    x = zeros(N,1);
    
    % Loop over the number of samples
    for n = 0 : N - 1
        
        % Loop over the number of frequencies
        for k = 0 : N - 1
            
            % DFT sum
            x(n+1) = x(n+1) + X(k+1) * exp(1j * 2 * pi / N * n * k);
        end

        % Normalization
        x(n+1) = real(x(n+1)) / N;
    end
else
    % ================================================
    % Compute IDFT using complex matrix multiplication
    % ================================================
    % Sample and frequency indices
    n = 0:1:N-1;
    k = 0:1:N-1;
    
    % Exponential basis functions
    wN = exp(1j * 2 * pi / N);
    
    % IDFT matrix
    W = wN.^(n'*k);
    
    % Calculate the IDFT
    x = real(1 / N * W * X);
end


%% PLOT TIME DOMAIN SIGNAL
%
%
% If no output is specified
if nargout == 0
    figure;
    hold on;
    stem(0:N-1,x,'color',[0 0.3895 0.9712],'linewidth',1.5)
    legend({'IDFT'})
    xlabel('$n$','interpreter','latex')
    ylabel('$x[n]$','interpreter','latex')
    grid on;
    xlim([0 N-1])
end
