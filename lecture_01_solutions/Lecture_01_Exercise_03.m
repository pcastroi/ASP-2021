clear
close all
clc

% Install subfolders 
addpath tools
addpath signals


%% EXERCISE: Uniform versus nonuniform quantization (LECTURE 01, SLIDE 44)
% •	write the functions compress.m and expand.m 
% •	initialize user parameters (e.g. signal levels, number of bits ... etc)  
% •	implement the signal-to-quantization-noise ratio (SQNR) metric
% •	loop over the number of signal levels and adjust the level of x
% •	for a given signal level, loop over the number of bits
% •	compare uniform and nonuniform quantization using the SQNR metric
% •	plot the SQNR as a function of the signal level for both uniform and
%   nununiform quantization


%% USER PARAMETERS
% 
% 
% Vector with number of bits
bits = [12 10 8 5];

% Select type of uniform quantizer (either 'midtread' or 'midrise')
type = 'midrise';

% Compression factor for mu-law companding
mu = 255;

% Vector of level adjustments
leveldB = 10:-1:-60;


%% CREATE SIGNAL
% 
% 
% Load speech file
[x,fsHz] = readAudio('speech@24kHz.wav');

% Normalize signal to have a maximum of one
x = x / max(abs(x));


%% PERFORM QUANTIZATION AND SQNR ANALYSIS
% 
% 
% Number of levels and bits
nLevels = numel(leveldB);
nBits = numel(bits);

% Allocate memory
sqnr1 = zeros(nLevels,nBits);
sqnr2 = zeros(nLevels,nBits);

% Loop over the number of levels
for ii = 1 : nLevels
    
    % Adjust level of input signal
    xAdjusted = db2mag(leveldB(ii)) * x;
    
    % Loop over the number of bits
    for jj = 1:nBits
        
        % Uniform quantization
        y1 = quantize(xAdjusted,bits(jj),type);
        
        % Non-uniform quantization using mu-law companding
        y2 = compress(xAdjusted,mu);
        y2 = quantize(y2,bits(jj),type);
        y2 = expand(y2,mu);
        
        % Quantization error
        e1 = xAdjusted - y1;
        e2 = xAdjusted - y2;
        
        % Signal-to-quantization noise ratio (SQNR)
        sqnr1(ii,jj) = 10 * log10(var(y1) / var(e1));
        sqnr2(ii,jj) = 10 * log10(var(y2) / var(e2));
    end
end


%% PLOT RESULTS
% 
% 
% Create colormap
cmap = colormapVoicebox(size(sqnr1,2));

% Empty cell for legend
strLegend = cell(2*nBits,1);

figure;
hold on;
h = plot(leveldB,sqnr1,'-');
for ii=1:numel(h)
    set(h(ii),'color',cmap(ii,:),'linewidth',1.5)
    strLegend{ii} = ['midrise, $B=',num2str(bits(ii)),'$'];
end
h = plot(leveldB,sqnr2,'--');
for ii=1:numel(h)
    set(h(ii),'color',cmap(ii,:),'linewidth',1.5)
    strLegend{ii+nBits} = ['$\mu$-law, $B=',num2str(bits(ii)),'$'];
end
set(gca,'xdir','reverse')
xlabel('Level adjustment (dB)')
ylabel('SQNR (dB)')
grid on;
legend(strLegend,'interpreter','latex')
xlim([min(leveldB) max(leveldB)])
ylim([0 65])
