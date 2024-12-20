function [ EDCdB, t ] = calcEDC( h, fs, trunctime )
% Returns the logarithmic energy decay curve for a given impulse response.
%
%USAGE
%   [EDC_log, t] = calcEDC(h, fs)
%  
%INPUT ARGUMENTS
%          h : M channel impulse response (N samples long) [N x M]
%         fs : sampling rate in Hz
%   trunctime: Time in [s] at which IR is truncated before calculating the
%              EDC.

%OUTPUT ARGUMENTS
%    EDCdB : logarithmic energy decay curve [tSamples x M]
%          t : time vector [tSamples x 1]

if nargin < 3 || isempty(trunctime) || (trunctime * fs) > size(h,1)
    tSample = size(h,1);
else 
    tSample = floor(trunctime * fs);
end

% Truncate
win = ones(length(h(:,1)),1); % creates a window w/ the IR length
win(fs*trunctime+1:end) = 0; % after trunctime secs everything = 0
h_win = h.*win;

%% Calculate EDC

% cumsum() to approximate the integral

EDC = flipud(cumsum(h_win(end:-1:1).^2));
EDCdB = 10*log10(EDC/EDC(1));


% Return time vector
T = length(h)/fs; %measurement time
t = 0:1/fs:T-1/fs;
t = t.';

end

