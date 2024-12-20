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


% Auto− and cross−power calculation
phiLL = XL .* conj(XL);
phiRR = XR .* conj(XR);
phiLR = XL .* conj(XR);

a = [1 -alpha];
b = 1 - alpha;

dim = 2;

PhiLL = filter(b,a,phiLL,[],dim);
PhiRR = filter(b,a,phiRR,[],dim);
PhiLR = filter(b,a,phiLR,[],dim);

C = PhiLR ./ sqrt(PhiLL .* PhiRR);
end

