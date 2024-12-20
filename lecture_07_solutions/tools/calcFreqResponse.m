function [H,w] = calcFreqResponse(b,a,N)
%calcFreqResponse   Calculate frequency response of digital filters
% 
%USAGE
%   [H,w] = genFilterBiquad(b)
%   [H,w] = genFilterBiquad(b,a,N)
% 
%INPUT ARGUMENTS
%   b : feedforward coefficients
%   a : feedback coefficients (default, a = 1)
%   N : number of frequency points (default, N = 1024)
% 
%OUTPUT ARGUMENTS
%   H : frequency response [N x 1]
%   w : frequency vector in radians/sample [N x 1]
%
%   calcFreqResponse(...) plots the frequency response in a new figure.

%   Developed with Matlab 9.2.0.538062 (R2017a). Please send bug reports to
%   
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark (DTU)
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/09/05
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 1 || nargin > 3
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(N); N = 2^10; end
if nargin < 2 || isempty(a); a = 1;    end


%% COMPUTE FREQUENCY RESPONSE
% 
% 
% Allocate memory
X = zeros(N,1);
Y = zeros(N,1);

% Normalized frequency vector
w = 2 * pi * (0:N-1)'/N;

% Contribution of numerator
for ii = 1 : numel(b)
%     X = X + (b(ii) .* exp(-1j*w*ii));
    X = X + (b(ii) .* exp(-1j*w*(ii-1)));
end

% Contribution of denominator
for ii = 1 : numel(a)
%     Y = Y + (a(ii) .* exp(-1j*w*ii));
    Y = Y + (a(ii) .* exp(-1j*w*(ii-1)));
end

% Frequency response
H = X ./ Y;


%% PLOT FREQUENCY RESPONSE
% 
% 
% If no output is specified
if nargout == 0
    
    % Frequency response in dB
    HdB = 20 * log10(abs(H));
    
    % Limit dynamic range to 100 dB
    maxVal = round(max(HdB)/10)*10;
    minVal = maxVal - 100;
    
    figure;
    plot(w/pi,HdB,'linewidth',1.5);
    grid on;
    xlabel('Frequency $(\omega / \pi)$','interpreter','latex')
    ylabel('Magnitude (dB)','interpreter','latex')
    xlim([0 1])
    ylim([minVal maxVal])
end