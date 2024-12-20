function [b,a] = genFilterBiquad(fs,fc,type)
%genFilterBiquad   Create 2nd order IIR filter (biquad)
% 
%USAGE
%   [b,a] = genFilterBiquad(fs,fc)
%   [b,a] = genFilterBiquad(fs,fc,type)
% 
%INPUT ARGUMENTS
%     fs : sampling frequency in Hertz
%     fc : either cut-off frequency or edge frequencies in Hertz
%   type : string specifying filter type (default, type = 'lowpass')
%          'lowpass'    = low-pass filter
%          'highpass'   = high-pass filter
%          'bandpass'   = band-pass filter
%          'bandreject' = band-reject filter
% 
%OUTPUT ARGUMENTS
%   b : feedforward coefficients [1 x 3]
%   a : feedback coefficients [1 x 3]
%
%   genFilterBiquad(...) plots the frequency response in a new figure.

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
if nargin < 2 || nargin > 3
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(type); type = 'lowpass'; end


%% CALCULATE FILTER COEFFICIENTS
% 
% 
% Select filter type
switch(lower(type))
    case 'lowpass'
        if numel(fc) ~= 1
            error('"fcHz" must be a scalar')
        end
        
        K  = tan(pi * fc / fs);
        
        Q  = 1 / sqrt(2);
        b0 = (K^2 * Q) / (K^2*Q + K + Q);
        b1 = (2 * K^2 * Q) / (K^2*Q + K + Q);
        b2 = (K^2 * Q) / (K^2*Q + K + Q);
        
        a0 = 1;
        a1 = (2 * Q * (K^2-1)) / (K^2*Q + K + Q);
        a2 = (K^2 * Q - K + Q) / (K^2*Q + K + Q);
        
        b = [b0,b1,b2];
        a = [a0,a1,a2];
        
    case 'highpass'
        if numel(fc) ~= 1
            error('"fcHz" must be a scalar')
        end
                
        K  = tan(pi * fc / fs);
        
        Q  = 1 / sqrt(2);
        b0 = Q / (K^2*Q + K + Q);
        b1 = (-2*Q) / (K^2*Q + K + Q);
        b2 = Q / (K^2*Q + K + Q);
        
        a0 = 1;
        a1 = (2 * Q * (K^2-1)) / (K^2*Q + K + Q);
        a2 = (K^2 * Q - K + Q) / (K^2*Q + K + Q);
        
        b = [b0,b1,b2];
        a = [a0,a1,a2];
        
    case 'bandpass'
        if numel(fc) ~= 2
            error('Must be 2-dimensional')
        end
        fb = max(fc) - min(fc);
        fc = sqrt(prod(fc));
        Q  = fc / fb;
        
        K = tan(pi * fc / fs);
        
        b0 = K / (K^2*Q + K + Q);
        b1 = 0;
        b2 = -K / (K^2*Q + K + Q);
        
        a0 = 1;
        a1 = (2 * Q * (K^2-1)) / (K^2*Q + K + Q);
        a2 = (K^2 * Q - K + Q) / (K^2*Q + K + Q);
        
        b = [b0,b1,b2];
        a = [a0,a1,a2];
        
    case 'bandreject'
        if numel(fc) ~= 2
            error('Must be 2-dimensional')
        end
        fb = max(fc) - min(fc);
        fc = sqrt(prod(fc));
        Q  = fc / fb;
        
        K = tan(pi * fc / fs);
        
        b0 = Q * (1 + K^2) / (K^2*Q + K + Q);
        b1 = 2 * Q * (K^2 - 1) / (K^2*Q + K + Q);
        b2 = Q * (1 + K^2)  / (K^2*Q + K + Q);
        
        a0 = 1;
        a1 = (2 * Q * (K^2-1)) / (K^2*Q + K + Q);
        a2 = (K^2 * Q - K + Q) / (K^2*Q + K + Q);
        
        b = [b0,b1,b2];
        a = [a0,a1,a2];
        
    otherwise
        error('Filter type "%s" is not supported.',lower(type))
end


%% PLOT FREQUENCY RESPONSE
% 
% 
% If no output is specified
if nargout == 0
   
    calcFreqResponse(b,a);

end
