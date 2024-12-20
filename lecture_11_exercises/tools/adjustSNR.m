function [x,s,n,C] = adjustSNR(s,n,snrdB)
%adjustSNR   Adjust the signal-to-noise ratio (SNR) between two signals.
%   The SNR is controlled by adjusting the overall level of the noise. Both
%   signals must be of equal size. 
% 
%USAGE
%   [x,s,n,C] = adjustSNR(s,n,snrdB)
%
%INPUT ARGUMENTS
%       s : speech signal [nSamples x 1]
%       n : noise signal [nSamples x 1]
%   snrdB : SNR in dB
% 
%OUTPUT ARGUMENTS
%   x : noisy target  [nSamples x 1]
%   s : target signal [nSamples x 1]
%   n : noise signal  [nSamples x 1]
% 
%   adjustSNR(...) plots the three signals in a new figure.
% 
%EXAMPLE
%  % Load some music (y & Fs)
%  load handel
%
%  % Mix signal with Gaussian noise at 11 dB SNR
%  adjustSNR(y,randn(size(y)),0);

%   Developed with Matlab 8.3.0.532 (R2014a). Please send bug reports to:
%   
%   Author  :  Tobias May, © 2014
%              Technical University of Denmark (DTU)
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2014/10/14
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS  
% 
% 
% Check for proper input arguments
if nargin ~= 3 
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Check dimensions
if min(size(s)) > 1
    error('Single channel input required!')
end

% Check dimensions
if numel(s) ~= numel(n)
    error('Speech and noise must be of equal size!')
end


%% ADJUST SNR
% 
% 
% Check if required SNR is finite
if isfinite(snrdB) 
    % Power of target and noise signal (remove DC)
    energyTarget = mean( (s - mean(s) ).^2 );
    energyNoise = mean( (n  - mean(n) ).^2 );
    
    % Compute scaling factor for noise signal
    C = sqrt( energyTarget / (energyNoise * 10^(snrdB/10)) );
    
    % Scale the noise to get required SNR
    n = C * n;

else
    error(['Specified SNR is not valid: ',num2str(snrdB), ' dB.'])
end
    
% Noisy speech
x = s + n;


%% SHOW NOISY TARGET
% 
% 
% Plot signals
if nargout == 0

    figure;hold on;
    hM = plot(x);
    hN = plot(n);
    hS = plot(s);
    grid on;xlim([1 numel(x)]);
    xlabel('Number of samples')
    ylabel('Amplitude')
    set(hM,'color',[0 0 0])
    set(hS,'color',[0 0.5 0])
    set(hN,'color',[0.5 0.5 0.5])
    legend({'mix' 'noise' 'target'})
end