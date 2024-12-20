function [sL,sR,G] = dereverb(xL,xR,fs,winSec ,tauSec)
%dereverb   Coherencebased dereverberation algorithm
%
%USAGE
%   [sL,sR,G] = dereverb(xL,xR,fs)
%   [sL,sR,G] = dereverb(xL,xR,fs,winSec,tauSec)
%
%INPUT ARGUMENTS
%       xL : left ear input signal [nSamples x 1]
%       xR : right ear input signal [nSamples x 1]
%       fs : sampling frequency in Hertz
%   winSec : window size in seconds across which the short-term
%             interaural coherence function is estimated
%             (default, winSec = 8E-3)
%   tauSec : time constant controlling the smoothing of the auto- and
%             cross-power spectral density estimates across time
%             (default, tauSec = ??????? )
%
%OUTPUT ARGUMENTS
%   sL : enhanced left ear signal [nSamples x 1]
%   sR : enhanced right ear signal [nSamples x 1]
%    G : time-varying gain function

% Set default values
if nargin < 5 || isempty(winSec); winSec = 8E-3; end

end