function [X,t,f] = stft(x,fs,w,R,M)
%stft   Compute the short-time discrete Fourier transform
%
%USAGE
%   [X,t,f] = stft(x,fs)
%   [X,t,f] = stft(x,fs,w,R,M)
%
%INPUT ARGUMENTS
%    x : input signal [Nx x 1 | 1 x Nx] (x must be a vector)
%   fs : sampling frequency in Hertz
%    w : length-N vector containing the window function [N x 1 | 1 x N]
%        (default, w = hamming(2*round(fs*32E-3/2),'periodic'))
%    R : shift between adjacent windows in samples 
%        (default, R = round(numel(w)/4))
%    M : DFT size, windows are zero-padded if M > N
%        (default, M = pow2(nextpow2(numel(w))))
%
%OUTPUT ARGUMENTS
%   X : complex STFT matrix [M x L]
%   t : time vector in seconds [1 x L]
%   f : frequency vector in Hertz [M x 1]
%
%   stft(...) plots the STFT in a new figure.

%   Developed with Matlab 9.2.0.538062 (R2017a). Please send bug reports to
%
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/09/18
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 2 || nargin > 5
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(w)
    % Use a periodic window of length 32 milliseconds
    w = hamming(2*round(fs*32E-3/2),'periodic');
end
if nargin < 4 || isempty(R); R = round(numel(w)/4);        end
if nargin < 5 || isempty(M); M = pow2(nextpow2(numel(w))); end

% Check if input is a vector
if min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Ensure x is a colum vector
    x = x(:);
end

% Check if window is a vector
if min(size(w)) > 1
    error('Window function w must be a vector.')
else
    % Ensure w is a colum vector
    w = w(:);
end

% Window size
N = numel(w);

% Check if M is larger or equal to N
if M < N
    error('DFT size M must be larger or equal to the window size N.')
else
    % Size of zero-padding
    nZeros = M - N;
end


%% PREPARATION
% 
% 
% Length of input signal
Nx = length(x);

% Overlap between adjacent windows
O = N - R;

% Number of frames
L = ceil((Nx-O)/R);   

% Zero-padd input such that it can be divided into an integer number of
% frames 
x = cat(1,x,zeros(round((O + L * R)-Nx),1));

% Allocate memory for STFT matrix
X = zeros(M, L);     


%% FRAME-BASED PROCSESING
% 
% 
% Loop over the number of frames
for ii = 1:L
    
    % Time segmentation and windowing
    xw = x((1:N)+(ii-1) * R) .* w;
    
    % Zero-padding 
    xw = cat(1,xw,zeros(nZeros,1));
    
    % Compute and store the DFT
    X(:,ii) = fft(xw);
end

% Calculate the time and frequency vectors
t = (N/2+(0:L-1) * R) / fs;
f = fs/M * (0:M-1)';


%% PLOT STFT 
%
%
% If no output is specified
if nargout == 0
    
    figure;
    imagesc(t,f,20*log10(abs(X/M)));
    xlim([t(1) t(end)])
    ylim([f(1) fs/2])
    colorbar;
    axis xy
    xlabel('Time (s)')
    ylabel('Frequency (Hz)') 
end
