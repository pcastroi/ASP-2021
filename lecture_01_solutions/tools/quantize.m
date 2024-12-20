function [y,delta] = quantize(x,nBits,type,xMin,xMax)
%quantize   Perform uniform quantization
%
%USAGE
%   [y,delta] = quantize(x)
%   [y,delta] = quantize(x,nBits,type,xMin,xMax)
%  
%INPUT ARGUMENTS
%       x : input signal
%   nBits : number of bits used for quantization (default, nBits = 12)
%    type : string specifying type of uniform quantization
%           'midtread' = 2^nBits - 1 quantization levels (default)
%           'midrise'  = 2^nBits quantization levels
%    xMin : minimum signal level (default, xMin = -1)
%    xMax : maximum signal level (default, xMax = 1)
% 
%OUTPUT ARGUMENTS
%       y : quantized signal
%   delta : quantization step size

%   Developed with Matlab 9.2.0.538062 (R2017a). Please send bug reports to
%   
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/08/19
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
if nargin < 5 || isempty(xMax);  xMax  = 1;          end
if nargin < 4 || isempty(xMin);  xMin  = -1;         end
if nargin < 3 || isempty(type);  type  = 'midtread'; end
if nargin < 2 || isempty(nBits); nBits = 12;         end

% Check range
if xMax <= xMin
    error(['Maximum signal level "xMax" must be larger than minimum ',...
        'signal level "xMin".'])
end


%% PERFORM UNIFORM QUANTIZATION
% 
% 
% Select type of quantization
switch(lower(type))
    case 'midtread'
        
        % Number of quantization levels
        L = round(2^nBits - 1);
        
        % Quantization step size
        delta = (xMax - xMin) / L;  
        
        % Perform quantization
        y = delta * floor(x/delta + 0.5);
                
    case 'midrise'
        
        % Number of quantization levels
        L = round(2^nBits);

        % Quantization step size
        delta = (xMax - xMin) / L;  
        
        % Perform quantization
        y = delta * (floor(x/delta) + 0.5);
        
    otherwise
        error('Quantization type "%s" is not supported',lower(type));
end


%% SATURATION
% 
% 
% Determine output range
qMax = xMax - delta / 2;
qMin = xMin + delta / 2;

% Limit signal range (handle overflow => saturation)
y = max(min(y,qMax),qMin);

