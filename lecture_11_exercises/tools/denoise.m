function [sHat,gain] = denoise(x,fsHz,winSec,tauSec,initSec,gainType)
%denoise   Noise reduction in the STFT domain.
% 
%USAGE
%   sHat = denoise(x,fsHz)
%   sHat = denoise(x,fsHz,winSec,tauSec,initSec,gainType)
% 
%INPUT ARGUMENTS
%           x : noisy speech signal [nSamples x 1]
%        fsHz : sampling frequency in Hertz
%      winSec : window size in seconds (default, winSec = 32E-3)
%      tauSec : time constant controlling the smoothing of the a priori SNR
%               (default, tauSec = 0.396) 
%     initSec : initial noise-only segment in seconds across which the
%               noise power is estimated (default, initSec = 100E-3) 
%    gainType : gain function used for noise suppresion
%                   'gss' = generalized spectral subtraction [4]
%                  'mmse' = MMSE spectral amplitude estimator [1]
%               'logmmse' = MMSE log-spectral amplitude estimator [2]
% 
%OUTPUT ARGUMENTS
%   sHat : enhanced signal [nSamples x 1]
%      G : time-varying gain function
% 
%   denoise(...) plots the applied gain in a new figure. 
% 
%REFERENCES
%   [1] Y. Ephraim and D. Malah, "Speech enhancement using a minimum
%       mean-square error short-time spectral amplitude estimator", IEEE
%       Transactions on Acoustics, Speech and Signal Processing,
%       ASSP-32(6):1109–1121, 1984. 
% 
%   [2] Y. Ephraim and D. Malah, "Speech enhancement using a minimum
%       mean-square error log-spectral amplitude estimator", IEEE
%       Transactions on Acoustics, Speech and Signal Processing, 
%       ASSP-33(2):443–445, 1985. 
% 
%   [3] O. Cappe, "Elimination of the musical noise phenomenon with the
%       Ephraim and Malah noise suppressor", IEEE Transactions on Speech
%       and Audio Processing, 2(2):345–349, 1994.  
% 
%   [4] N. Virag, "Single channel speech enhancement based on masking
%       properties of the human auditory system", IEEE Transactions on
%       Speech and Audio Processing, 7(2), pp. 126–137, 1999. 

%   Developed with Matlab 9.1.0.441655 (R2016b). Please send bug reports to
%   
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/10/29
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 2 || nargin > 6
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(winSec);   winSec   = 32E-3;     end
if nargin < 4 || isempty(tauSec);   tauSec   = 396E-3;    end
if nargin < 5 || isempty(initSec);  initSec  = 100E-3;    end
if nargin < 6 || isempty(gainType); gainType = 'logmmse'; end

% Check size of x
if min(size(x)) > 1
    error('Single-channel input required.');
end

% Check winSec
if ~isnumeric(winSec) || winSec < 0
    error('The window size "winSec" must be numeric and nonnegative.');
end

% Check tauSec
if ~isnumeric(tauSec) || tauSec < 0
    error('The time constant "tauSec" must be numeric and nonnegative.');
end


%% INITIALIZE PARAMETERS
% 
% 
% Window size, step size and overlap
N = 2 * round(winSec * fsHz / 2);
R = round(N / 4);
O = N - R;

% Reconstruction method 
ola = 'wola';

% Create analysis and synthesis window function
w = cola(N,R,'hamming',ola);

% DFT size 
M = pow2(nextpow2(N));


%% SHORT-TIME FOURIER TRANSFORM (STFT)
% 
% 
% STFT representation of the noisy speech signal
[X,tSec,fHz] = stft(x,fsHz,w,R,M);

% Get dimensionality
[nDFTBins,nFrames] = size(X);


%% ESTIMATE THE NOISE PSD
% 
%
P=ceil((initSec-(O/fsHz))/(R/fsHz));
sig_hatD2=(1/P)*sum(abs(X(1:P,:)).^2,2);
alphaDD=exp(-(R/(fsHz*tauSec)));

%% ESTIMATE CLEAN SPEECH MAGNITUDE
% 
% 
% Preallocate memory
gain = zeros(nDFTBins,nFrames);
SHat = zeros(nDFTBins,nFrames);
xi = zeros(nDFTBins,nFrames);
gamma=zeros(nDFTBins,nFrames);

% Loop over the number of frames
for ii = 1 : nFrames
    
    
    % Calculate the a posteriori SNR (gamma)
    gamma = (abs(X(:,ii)).^2)/sig_hatD2;
        
    
    % Calculate the a priori SNR (xi) using the decision-directed approach
    if ii == 1
        % Inital condition
        xi(:,ii) = alphaDD+(1-alphaDD)*max(gamma(:,ii)-1,0);
    else
        % Recursion
		xi(:,ii) = sum(alphaDD*((abs(SHat(:,ii-1)).^2)./sig_hatD2')+(1-alphaDD)*max(gamma(:,ii)-1,0),2);
    end
        
        
    % Derive gain function
    switch(lower(gainType))
        case 'gss'
            % Generalized spectral subtraction
            gain(:,ii) = calcGainGSS(gamma(:,ii));
        case 'mmse'
            % MMSE spectral amplitude estimator 
            gain(:,ii) = calcGainMMSE(gamma(:,ii),xi(:,ii));
        case 'logmmse'
            % MMSE log-spectral amplitude estimator 
            gain(:,ii) = calcGainLOGMMSE(gamma(:,ii),xi(:,ii));
        otherwise
            error('Gain function "%s" is not supported!',lower(gainType));
    end
    
    % Apply gain function to obtain an estimate of the clean speech signal
    SHat(:,ii) = X(:,ii) .* gain(:,ii);    
end


%% INVERSE SHORT-TIME FOURIER TRANSFORM (ISTFT)
% 
% 
% Reconstruct time-domain signals using the weighted overlap add method
sHat = istft(SHat,w,R,ola,numel(x));


%% PLOT RESULTS
% 
% 
% Show gain function
if nargout == 0 
    
    samplesSec = (0:numel(x)-1)/fsHz;
    
    figure;
    hold on;
    plot(samplesSec,x,'color',[0.5 0.5 0.5]);
    plot(samplesSec,sHat,'color',[0 0.3895 0.9712]);
    legend({'$x[n]$' '$\hat{s}[n]$'},'interpreter','latex')
    xlim([samplesSec(1) samplesSec(end)]);
    xlabel('Time (s)')
    ylabel('Amplitude')
    grid on;
    
    figure;
    imagesc(tSec,fHz,gain,[0 1]);
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    title('Gain function')
    xlim([tSec(1) tSec(end)])
    ylim([0 fsHz/2])    
    axis xy
    colorbar;    
end

