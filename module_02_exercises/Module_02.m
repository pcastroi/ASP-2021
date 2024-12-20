clear
close all
clc

% Install subfolders
addpath irs
addpath signals
addpath tools


%% USER PARAMETERS
% 
% 
% Sampling frequency
fsHz = 16E3;

% Source signal
fileName = 'speech@24kHz.wav';

% Impulse response
roomName = 'Cortex_45deg.wav';
% roomName = 'Room_A_45deg.wav';
% roomName = 'Room_D_45deg.wav';
% roomName = 'bi_2021_10_5_16_50_44.wav'; % Our own HATS recording

% Window length
winSec = 8E-3; % default value = 8E-3

% Integration time constant for coherence estimation in seconds
tauSec=0.2; % Default value 0.2 seconds

%% CREATE BINAURAL SIGNAL
% 
% 
% Load source signal
s = readAudio(fileName,fsHz);
% s = s/max(abs(s));

% Load impulse response
h = readIR(roomName,fsHz);

% 2.1 Fast convolution using the overlap-save method
xL = convolveFFT_OLS(s,h(:,1));
xR = convolveFFT_OLS(s,h(:,2));

%% PERFORM COHERENCE-BASED DEREVERBERATION
% 
%
forit=1:10:1000; %number of iterations
DRR_temp=zeros(length(forit),1);
tau_temp=zeros(length(forit),1);
var=1;

% for i=forit
% tauSec = i/1000;
[sL_hat,sR_hat,G,w,R,M] = dereverb(xL,xR,fsHz,winSec,tauSec);

% 4. Experiments
brir = cat(2,h(:,1),h(:,2));

% Identify the direct-path component of the BRIR
hDirect = splitBRIR(brir,fsHz);

% Binaural reference signal without reverberation
sL = convolveFFT_OLS(s,hDirect(:,1));
sR = convolveFFT_OLS(s,hDirect(:,2));

% DRR
DRRpre = 10*log10((sum((sL).^2)+sum((sR).^2))./(sum((xL-sL).^2)+sum((xR-sR).^2)));
DRRpost = 10*log10((sum((sL).^2)+sum((sR).^2))./(sum((sL_hat-sL).^2)+sum((sR_hat-sR).^2)));

DRR = DRRpost - DRRpre;

tau_temp(var)=tauSec;
DRR_temp(var)=DRR;
var=var+1;
% end
% save('HATS.mat','DRR_temp','tau_temp')
%% Plots
figure
plot(linspace(0,length(h)/fsHz,length(h)),h)
title('Impulse Response of "Cortex45"','interpreter','latex');
axis tight
xlabel('Time (s)','interpreter','latex')
ylabel('Amplitude','interpreter','latex')
legend({'$h_L$' '$h_R$'},'interpreter','latex')

figure
subplot(2,1,1)
hold on
plot(linspace(0,numel(xL)/fsHz,numel(xL)),xL)
plot(linspace(0,numel(sL_hat)/fsHz,numel(sL_hat)),sL_hat)
title('Reverberant and dereverberated signals (Left channel)','interpreter','latex');
xlabel('Time (s)','interpreter','latex')
ylabel('Amplitude','interpreter','latex')
legend({'$x_L$' '$\hat{s}_L$'},'interpreter','latex')
hold off
subplot(2,1,2)
hold on
plot(linspace(0,numel(xR)/fsHz,numel(xR)),xR)
plot(linspace(0,numel(sR_hat)/fsHz,numel(sR_hat)),sR_hat)
title('Reverberant and dereverberated signals (Right channel)','interpreter','latex');
xlabel('Time (s)','interpreter','latex')
ylabel('Amplitude','interpreter','latex')
legend({'$x_R$' '$\hat{s}_R$'},'interpreter','latex')
hold off

DRdB = 60;
figure
subplot(3,1,1)
[SL,t,f] = stft(sL,fsHz,w,R,M);
XdB = 20 * log10(abs(SL));
XdB = XdB - max(XdB(:));
range = [max(XdB(:)) - DRdB max(XdB(:))];
imagesc(t(:)',f(:),XdB,range);
axis xy;
ylim([0 fsHz/2])
colormap(colormapVoicebox);
colorbar;
xlabel('Time (s)','interpreter','latex')
ylabel('Frequency (Hz)','interpreter','latex')
title('STFT of the dry signal ($s_L$)','interpreter','latex')
subplot(3,1,2)
[XL,t,f] = stft(xL,fsHz,w,R,M);
XdB = 20 * log10(abs(XL));
XdB = XdB - max(XdB(:));
range = [max(XdB(:)) - DRdB max(XdB(:))];
imagesc(t(:)',f(:),XdB,range);
axis xy;
ylim([0 fsHz/2])
colormap(colormapVoicebox);
colorbar;
xlabel('Time (s)','interpreter','latex')
ylabel('Frequency (Hz)','interpreter','latex')
title('STFT of the reverberant signal ($x_L$)','interpreter','latex')
subplot(3,1,3)
[SL_hat,t,f] = stft(sL_hat,fsHz,w,R,M);
XdB = 20 * log10(abs(SL_hat));
XdB = XdB - max(XdB(:));
range = [max(XdB(:)) - DRdB max(XdB(:))];
imagesc(t(:)',f(:),XdB,range);
axis xy;
ylim([0 fsHz/2])
colormap(colormapVoicebox);
colorbar;
xlabel('Time (s)','interpreter','latex')
ylabel('Frequency (Hz)','interpreter','latex')
title('STFT of the dereverberated signal ($$\hat{s_L}$$)','interpreter','latex')

figure
subplot(3,1,1)
[SR,t,f] = stft(sL,fsHz,w,R,M);
XdB = 20 * log10(abs(SR));
XdB = XdB - max(XdB(:));
range = [max(XdB(:)) - DRdB max(XdB(:))];
imagesc(t(:)',f(:),XdB,range);
axis xy;
ylim([0 fsHz/2])
colormap(colormapVoicebox);
colorbar;
xlabel('Time (s)','interpreter','latex')
ylabel('Frequency (Hz)','interpreter','latex')
title('STFT of the dry signal ($s_R$)','interpreter','latex')
subplot(3,1,2)
[XR,t,f] = stft(xL,fsHz,w,R,M);
XdB = 20 * log10(abs(XR));
XdB = XdB - max(XdB(:));
range = [max(XdB(:)) - DRdB max(XdB(:))];
imagesc(t(:)',f(:),XdB,range);
axis xy;
ylim([0 fsHz/2])
colormap(colormapVoicebox);
colorbar;
xlabel('Time (s)','interpreter','latex')
ylabel('Frequency (Hz)','interpreter','latex')
title('STFT of the reverberant signal ($x_R$)','interpreter','latex')
subplot(3,1,3)
[SR_hat,t,f] = stft(sL_hat,fsHz,w,R,M);
XdB = 20 * log10(abs(SR_hat));
XdB = XdB - max(XdB(:));
range = [max(XdB(:)) - DRdB max(XdB(:))];
imagesc(t(:)',f(:),XdB,range);
axis xy;
ylim([0 fsHz/2])
colormap(colormapVoicebox);
colorbar;
xlabel('Time (s)','interpreter','latex')
ylabel('Frequency (Hz)','interpreter','latex')
title('STFT of the dereverberated signal ($$\hat{s_R}$$)','interpreter','latex')
%% Sound
% sound([sL_hat sR_hat], fsHz)