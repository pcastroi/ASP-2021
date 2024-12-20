function gain = calcGainGSS(gamma,g1,g2,alpha,beta)
%calcGainGSS   Calculate generalized spectral subtraction gain function
% 
%   gain = max(beta, 1 - alpha * (abs(NN) ./ abs(XX)).^g1 ).^g2 
%   gain = max(beta, 1 - alpha * sqrt(gamma).^-g1 ).^g2 
% 
%USAGE
%   gain = calcGainGSS(gamma,g1,g2)
%   gain = calcGainGSS(gamma,g1,g2,alpha,beta)
% 
%INPUT ARGUMENTS
%   gamma : a posteriori SNR [nFFTBins x nFrames]
%      g1 : exponent 1 (default, g1 = 1)
%      g2 : exponent 2 (default, g2 = 1)
%           magnitude subtraction : g1 = 1 & g2 = 1   (default)
%                Wiener filtering : g1 = 2 & g2 = 1
%               power subtraction : g1 = 2 & g2 = 0.5
%   alpha : oversubtraction factor (default, alpha = 1)
%    beta : spectral floor (default, beta = 0)
% 
%OUTPUT ARGUMENTS
%   gain : gain function [nFFTBins x nFrames]
% 
%   calcGainGSS(...) plots the gain function in a new figure.
% 
%REFERENCES
%   [1] N. Virag, "Single channel speech enhancement based on masking
%       properties of the human auditory system", IEEE Transactions on
%       Speech and Audio Processing, 7(2), pp. 126–137, 1999. 

%   Developed with Matlab 8.6.0.267246 (R2015b). Please send bug reports to
%   
%   Author  :  Tobias May, © 2015
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2015/10/01
%   v.0.2   2017/10/31 replaced input mangitudes with a posteriori SNR 
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
if nargin < 2 || isempty(g1);    g1    = 1; end
if nargin < 3 || isempty(g2);    g2    = 1; end
if nargin < 4 || isempty(alpha); alpha = 1; end
if nargin < 5 || isempty(beta);  beta  = 0; end

% Check if input is real-valued
if not(isreal(gamma))
    error('A posteriori SNR "gamma" is not real.')
end
    
% Determine dimensionality
[nFFTBins,nFrames] = size(gamma);

% Replicate alpha to match with the dimensions of gamma
if isscalar(alpha)
    alpha = repmat(alpha,[nFFTBins nFrames]);
else
    if all(size(alpha) == [nFFTBins,nFrames])
        % Alpha has already the correct size
    elseif numel(alpha) == nFrames
        alpha = repmat(alpha,[nFFTBins 1]);
    else
        error(['Alpha must be either a scalar, a vector [1 x nFrames]',...
            ' or a matrix [nFFTBins x nFrames]'])
    end
end


%% COMPUTE GENERALIZED SPECTRAL SUBTRACTION GAIN FUNCTION
% 
% 
% Gain function 
gain = max(beta,1 - alpha .* sqrt(gamma).^-g1).^g2;

% Ensure a maximum gain of 1
gain = min(gain,1);


%% SHOW GAIN FUNCTION
% 
% 
% If no output is specified
if nargout == 0
    
    % Number of elements
    E = numel(gamma);
 
    % Randomly sample up to 10000 elements (the sort algorithm is quite
    % slow for longer sequences) 
    randIdx = randperm(E,min(1E4,E));
    
    % Sort data to get a proper input/output curve
    [input2plot,sortIdx] = sort(gamma(randIdx),'ascend');
    output2plot = gain(randIdx(sortIdx));
    
    % Plot input/output curve
    figure; 
    plot(10 * log10(input2plot+eps),20 * log10(output2plot+eps),...
        'linewidth',1.5,'color',[0 0.3895 0.9712])
    xlabel('A posteriori SNR (dB)')
    ylabel('Gain (dB)')
    grid on;
end
