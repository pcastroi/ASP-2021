function y = sdofBox(x,fs,m,r,s)
%sdofBox   Apply single-degree-of-freedom-system to input signal
% 
%USAGE
%   y = sdofBox(x,fs)
%   y = sdofBox(x,fs,m,r,s)
%
%INPUT ARGUMENTS
%    x : input signal [nSamples x 1]
%   fs : sampling frequency in Hz
%    m : mass (default, m = 50E-3)
%    r : damping (default, r = 1)
%    s : spring (default, s = 1E7) 

% 
%OUTPUT ARGUMENTS
%   y : output signal [nSamples x 1]


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 2 || nargin > 6
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(m); m = 50E-3; end
if nargin < 4 || isempty(r); r = 1;     end
if nargin < 5 || isempty(s); s = 1E7;   end
if nargin < 6 || isempty(F); F = 1E6;   end

% Check if input is a vector
if min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Ensure x is a colum vector
    x = x(:);
end


%% CALCULATE SDOF FREQUENCY DOMAIN RESPONSE
% 
% 
% Number of samples
N = length(x);

% Ensure that the DFT size is even-numbered
nfft = N + mod(N,2);

% Frequency vector in Hertz
f = fs/nfft * (0:nfft-1)';  

% Frequency vector in radiants
w = 2 * pi * f;                  

% Resonance frequency
w0 = sqrt(s / m);

% The SDOF system in the frequency domain
H = 1 / m * 1 ./ (w0^2 - w.^2 + 1i * w * r / m);


%% APPLY SDOF SYSTEM IN THE FREQUENCY DOMAIN
% 
% 
% DFT
X = fft(x,nfft);

% Multiply the frequency response function of the SDOF system
Y = H .* X;

% IDFT
y = ifft(Y, nfft, 'symmetric');

% Trim signal
y = y(1:N);  

