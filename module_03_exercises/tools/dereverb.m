function [sL,sR,G,w,R,M] = dereverb(xL,xR,fs,winSec,tauSec)
%dereverb   Coherencebased dereverberation algorithm
%
%USAGE
%   [sL,sR,G] = dereverb(xL,xR,fs)
%   [sL,sR,G] = dereverb(xL,xR,fs,winSec,tauSec)
%
%INPUT ARGUMENTS
%       xL : left ear input signal [nSamples x 1]
%       xR : right ear input signal [nSamples x 1]
%       fs : sampling frequency in Hertz
%   winSec : window size in seconds across which the short-term
%             interaural coherence function is estimated
%             (default, winSec = 8E-3)
%   tauSec : time constant controlling the smoothing of the auto- and
%             cross-power spectral density estimates across time
%             (default, tauSec = 0.2 )
%
%OUTPUT ARGUMENTS
%   sL : enhanced left ear signal [nSamples x 1]
%   sR : enhanced right ear signal [nSamples x 1]
%    G : time-varying gain function

% Set default values
if nargin < 5 || isempty(winSec); winSec = 8E-3; end
if nargin < 5 || isempty(tauSec); tauSec = 0.2; end

% 3.1.1 Compute the STFT representations of the left and right ear signals
method = 'wola';
N = 2 * round(winSec * fs / 2);
R = round(N / 4);
w = cola(N,R,'hamming',method);
M = pow2(nextpow2(N));

% Check if window satisfies constant overlap add criterion
bPlot = false;
[bCola,offset] = iscola(w,R,method,bPlot);

[XL,t,f] = stft(xL,fs,w,R,M);
XR = stft(xR,fs,w,R,M);

% 3.4 estimates the short-term IC based on the STFT representations of 
%     the left and right ear signals XL and XR
alpha = exp(-R / (tauSec * fs));
C = estCohere(XL,XR,alpha);

% 3.5 
G = abs(C) .^ 2;

% figure
% imagesc(G)
% ylim([1 size(G,1)/2])
% ylabel('Frequency samples ($k$)','interpreter','latex')
% xlabel('Frames ($$\lambda /2$$)','interpreter','latex')
% colorbar

% Gain function plot
figure()
surf(t,f,G(1:numel(f),:),'EdgeColor','none')
axis xy;
axis tight;
ylim([1 fs/2])
colormap(colormapVoicebox); view(0,90);
xlabel('Time (s)','interpreter','latex');
colorbar;
caxis([0 1])
ylabel('Frequency (HZ)','interpreter','latex');
title('Gain function','interpreter','latex');
set(gca, 'XScale');

SL = abs(XL) .* G .* exp(1i * angle(XL));
SR = abs(XR) .* G .* exp(1i * angle(XR));

% 3.2
sL = istft(SL,w,R,method,numel(xL));
sR = istft(SR,w,R,method,numel(xR));
end

