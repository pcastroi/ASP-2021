function gain = calcGainLOGMMSE(gamma,xi)
%calcGainLOGMMSE   Minimum mean-square error log-spectral amplitude estimator
% 
%USAGE
%   gain = calcGainLOGMMSE(gamma,xi)
% 
%INPUT ARGUMENTS
%   gamma : a posteriori SNR [nDFTBins x nFrames]
%      xi : a priori SNR [nDFTBins x nFrames]
% 
%OUTPUT ARGUMENTS
%   gain : gain function [nDFTBins x nFrames]
%
%   See also calcGainMMSE.
%
%REFERENCES
%   [1] Y. Ephraim and D. Malah, "Speech enhancement using a minimum
%       mean-square error log-spectral amplitude estimator", IEEE
%       Transactions on Acoustics, Speech and Signal Processing, 
%       ASSP-33(2):443–445, 1985. 

%   Developed with Matlab 9.3.0.713579 (R2017b). Please send bug reports to
%   
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/10/28
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin < 2 || nargin > 2
    help(mfilename);
    error('Wrong number of input arguments!')
end


%% COMPUTE LOG-MMSE GAIN FUNCTION
% 
% 
% Eq. (20) in [1]
vi   = xi ./ (1.0 + xi);
gain = vi .* exp(0.5*expint(vi .* gamma));

% Ensure a maximum gain of 1
gain = min(gain,1);
