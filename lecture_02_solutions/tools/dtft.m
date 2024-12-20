function X = dtft(x,w)
%dtft   Approximate the discrete-time Fourier transform (DTFT)
%
%USAGE
%   X = dtft(x)
%   X = dtft(x,w)
%
%INPUT ARGUMENTS
%   x : length-N input signal (N x 1 | 1 x N) (x must be a vector)
%   w : frequency vector in radians/sample
%       (default, w = linspace(-pi,pi,2^12))
%
%OUTPUT ARGUMENTS
%   X : complex DTFT spectrum
%
%   dtft(...) plots the DTFT in a new figure.
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
if nargin < 2 || isempty(w); w = linspace(-pi,pi,2^12); end

% Ensure omega is a colum vector
w = w(:);

% Check if input is a vector
if min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Number of samples
    N = numel(x);
end


%% COMPUTE DTFT
%
%
% Complex exponential basis functions
ejw = exp(-1j*w);

% Number of frequencies at which DTFT should be computed
K = numel(w);

% Allocate memory
X = zeros(K,1);

% Loop over the number of samples
for n = 0:N-1
    % DTFT sum
    X = X + x(n+1) * ejw.^n;
end


%% PLOT SPECTRUM
%
%
% If no output is specified
if nargout == 0
    figure;
    hold on;
    plot(w/pi,abs(X),'color',[0 0.3895 0.9712],'linewidth',1.5)
    legend({'DTFT'})
    xlabel('$\omega / \pi$','interpreter','latex')
    ylabel('$|X(\omega)|$','interpreter','latex')
    grid on;
    xlim([w(1)/pi w(end)/pi])
end
