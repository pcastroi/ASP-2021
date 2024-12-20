function h = getIR(y,Hinv)
%getIR   Estimates the impulse response h by applying the inverse filter.
%
%USAGE
%   h = getIR(y,Hinv)
%
%INPUT ARGUMENTS
%      y : single channel measurement signal [N x M]
%   Hinv : complex spectrum of the inverse filter [N x 1]
% 
%OUTPUT ARGUMENTS
%   h : impulse response of the system [N x M]

%   Developed with Matlab 9.2.0.538062 (R2017a). Please send bug reports to
%   
%   Author  :  Marton Marschall, © 2017
%              Technical University of Denmark
%              mmars@dtu.dk
%
%   History :
%   v.0.1   2017/08/19
%   ***********************************************************************


%% CHECK INPUT ARGUMENTS
%
%
% Check for proper input arguments
if nargin ~= 2
    help(mfilename);
    error('Wrong number of input arguments!')
end


%% APPLY INVERSE FILTER
% 
% 
% -- ADD YOUR CODE HERE ----------------------------------------------
% heigth(y)
% width(y)
for ii=1:size(y,2)
Y(:,ii) = fft(y(:,ii));
H(:,ii) = Y(:,ii).*Hinv;
h(:,ii) = real(ifft(H(:,ii)));
% h = convolveFFT(y,ifft(Hinv));
end

end
