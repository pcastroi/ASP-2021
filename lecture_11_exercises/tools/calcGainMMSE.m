function gain = calcGainMMSE(gamma,xi)
%calcGainMMSE   Minimum mean-square error spectral amplitude estimator
% 
%USAGE
%   gain = calcGainMMSE(gamma,xi)
% 
%INPUT ARGUMENTS
%   gamma : a posteriori SNR [nFFTBins x nFrames]
%      xi : a priori SNR [nFFTBins x nFrames]
% 
%OUTPUT ARGUMENTS
%   gain : gain function [nFFTBins x nFrames]
%
%   See also calcGainLOGMMSE.
% 
%REFERENCES
%   [1] Y. Ephraim and D. Malah, "Speech enhancement using a minimum
%       mean-square error short-time spectral amplitude estimator", IEEE
%       Transactions on Acoustics, Speech and Signal Processing,
%       ASSP-32(6):1109–1121, 1984. 

%   Developed with Matlab 9.3.0.713579 (R2017b). Please send bug reports to
%   
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/10/27
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 2 || nargin > 2
    help(mfilename);
    error('Wrong number of input arguments!')
end


%% COMPUTE MMSE GAIN FUNCTION
% 
% 
% Eq. (7) in [1]
vi   = xi ./ (1.0 + xi) .* gamma;
gain = (1 + vi) .* besseli(0,vi./2) + vi .*  besseli(1,vi./2);
gain = gain .* sqrt(pi .* vi) ./ (2 * gamma) .* exp(-vi./2);

% Ensure a maximum gain of 1
gain = min(gain,1);
