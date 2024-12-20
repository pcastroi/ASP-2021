function C = estCohere(XL,XR,alpha)
%estCohere   Estimate the shortterm interaural coherence
%
%USAGE
%   C = estCohere(XL,XR,alpha)
%
%INPUT ARGUMENTS
%      XL : left ear STFT representation [M x L]
%      XR : right ear STFT representation [M x L]
%   alpha : smoothing coefficient which controls the averaging of
%           the autoand cross power spectral densities across
%           adjacent time frames
%
%OUTPUT ARGUMENTS
%   C : shortterm interaural coherence [M x L]

end