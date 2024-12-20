function x = fade(x, Nin, Nout)
%fade   Apply a raised cosine window for fade in and fade out
% 
%USAGE
%   y = fade(x, Nin, Nout)
%  
%INPUT ARGUMENTS
%         x : input signal [N x 1]
%   Nfadein : number of samples to fade in
%  Nfadeout : number of samples to fade out
% 
%OUTPUT ARGUMENTS
%   x : signal with raised cosine window applied [N x 1]



%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin < 1 || nargin > 3
    help(mfilename);
    error('Wrong number of input arguments!')
end

% Set default values
if nargin < 3 || isempty(Nout); Nout = 10; end
if nargin < 2 || isempty(Nin);  Nin  = 10; end

% Check if input is a vector
if min(size(x)) > 1
    error('Input signal x must be a vector.')
else
    % Ensure x is a colum vector
    x = x(:);
end


%% WINDOWING 
% 
% 
% Dimensionality
N = numel(x);

% Reduce abrupt discontinuities at signal start and end, by fading in over
% number of samples specified by Nin and Nout.

% Create raised cosine windows for fade in and out
% -- ADD YOUR CODE HERE --------------------------------------------------
% Create Hann Window
wIn = hann(Nin*2); % fade in (first half of the window)
wIn = wIn(1:Nin);
wOut = hann(Nout*2); % fade out (second half of the window)
wOut = wOut(Nout+1:Nout*2);

% Apply window
x(1:Nin) = x(1:Nin) .* wIn;
x(N-Nout+1:N) = x(N-Nout+1:N) .* wOut;

end

