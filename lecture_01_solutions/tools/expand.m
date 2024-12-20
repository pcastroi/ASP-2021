function y = expand(x,mu)
%expand   Convert mu-law compressed signal to linear amplitudes using expansion.
%
%USAGE
%   y = expand(x)
%   y = expand(x,mu)
%  
%INPUT ARGUMENTS
%    x : input signal (mu-law compressed)
%   mu : compression factor (default, mu = 255)
% 
%OUTPUT ARGUMENTS
%   y : expanded signal (linear amplitudes)
% 
%   See also compress.

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
if nargin < 1 || nargin > 2
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 2 || isempty(mu); mu = 255; end

% Check range of compression factor
if mu <= 0
    error('Compression factor "mu" must be larger than 0.')
end


%% PERFORM EXPANSION
% 
% 
% mu-law expansion
y = sign(x) .* ((1 + mu).^abs(x) - 1) / mu;
