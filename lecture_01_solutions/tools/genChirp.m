function [x,t] = genChirp(fs,f0,T,f1,phi0)
%genChirp   Create a chirp signal
% 
%USAGE
%   [x,t] = genChirp(fs)
%   [x,t] = genChirp(fs,f0,T,f1,phi0)
%  
%INPUT ARGUMENTS
%     fs : sampling frequency in Hertz
%     f0 : instantaneous frequency in Hertz at time 0 (default, f0 = 1)
%      T : duration of chirp in seconds (default, T = 0.2)
%     f1 : instantaneous frequency in Hertz at time T (default, fs / 2)
%   phi0 : phase offset (default, phi0 = 0)
% 
%OUTPUT ARGUMENTS
%   x : chirp signal [fs * T x 1]
%   t : time vector in seconds [fs * T x 1]
% 
%   genChirp(...) plots the chirp signal in a new figure.

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
if nargin < 1 || nargin > 5
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 5 || isempty(phi0); phi0 = 0;      end
if nargin < 4 || isempty(f1);   f1   = fs / 2; end
if nargin < 3 || isempty(T);    T    = 200E-3; end
if nargin < 2 || isempty(f0);   f0   = 1;      end


%% CREATE CHIRP SIGNAL
% 
% 
% Discrete-time vector
Ts = 1 / fs;
t = (0:Ts:(T-Ts))';

% Sweep rate of frequency change
k = (f1 - f0) / T;

% Linear frequency function in Hertz
% f = f0 + k * t;

% Create chirp signal
x = sin(2 * pi * (f0 + k/2 .* t) .* t + phi0);


%% PLOT SIGNAL
% 
% 
% If no output arguments are specified
if nargout == 0
    figure;
    plot(t,x);
    xlabel('Time (s)')
    ylabel('Amplitude')
    title('Linear chirp signal')
    xlim([t(1) t(end)])
end