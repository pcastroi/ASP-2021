function [pdf,binCenter] = measurePDF(x,nBins,strPDF)
%measurePDF   Estimate probability density function
%
%USAGE
%   [pdf,binCenter] = measurePDF(x)
%   [pdf,binCenter] = measurePDF(x,nBins,strPDF)
%
%INPUT ARGUMENTS
%        x : one-dimensional input signal [nSamples x 1]
%    nBins : number of histogram bins (default, nBins = 128)
%   strPDF : string or cell array specifying one or more of the following
%            theoretical PDFs that should be plotted along with the
%            histogram analysis: 'gaussian','laplace','gamma'
%            (default, strPDF = 'Gaussian')
%
%OUTPUT ARGUMENTS
%         pdf : measured probability density function [1 x nBins]
%   binCenter : bin centers of histogram analysis [1 x nBins]
% 
%   measurePDF(...) plots the pdf in a new figure.

%   Developed with Matlab 9.3.0.713579 (R2017b). Please send bug reports to
%
%   Author  :  Tobias May, © 2017
%              Technical University of Denmark
%              tobmay@elektro.dtu.dk
%
%   History :
%   v.0.1   2017/10/30
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
if nargin < 2 || isempty(nBins);  nBins  = 128;        end
if nargin < 3 || isempty(strPDF); strPDF = 'gaussian'; end

% Check size of x
if min(size(x)) > 1
    error('One-dimensional input required.');
else
    N = numel(x);
end


%% MEASURE DISTRIBUTION PARAMETERS
%
%
% Mean
mu = mean(x);

% ... and standard deviation
sigma = std(x);


%% MEASURE PDF
%
%
% Range of standard deviations
nSigma = 4;

% Define histogram bins (sigma range)
binCenter = mu + linspace(-nSigma*sigma,nSigma*sigma,nBins);

% Histogram analysis
h = hist(x,binCenter);

% Normalize counts to produce pdf
pdf = h / N;


%% THEORETICAL PDF
% 
% 
% Handle strings / cells
if ~iscell(strPDF)
    strPDF = {strPDF};
end

% Number of theoretical PDFs
nPDFs = numel(strPDF);

% Allocate memory
pdfTheory = zeros(numel(binCenter),nPDFs);

% Loop over the number of theoretical PDFs
for ii = 1 : nPDFs
    switch(strPDF{ii})
        case 'gaussian'
            
            % Gaussian pdf            
            pdfTheory(:,ii) = 1 / (sqrt(2*pi) * sigma) * ...
                exp(-(binCenter-mu).^2/(2*sigma^2));
            
        case 'laplace'
            
            % Two-sided exponential (Laplace) pdf
            pdfTheory(:,ii) = 1 / (sqrt(2*pi) * sigma) * ...
                exp(-sqrt(2) .* abs(binCenter-mu)/sigma);
            
        case 'gamma'
            
            % Two-sided gamma pdf
            pdfTheory(:,ii) = nthroot(3,4) / (2 * sqrt( 2 * pi * sigma))...
                * (1 ./ sqrt(abs(binCenter-mu))) .* ... 
                exp(-sqrt(3)/2 * abs(binCenter-mu)/sigma);
            
        otherwise
            error('Theoretical PDF "%s" is not supported.',lower(strPDF{ii}))
    end
end

% Area
area = diff(binCenter(1:2));

% Normalize pdf by the area
pdfTheory = pdfTheory * area;  
    

%% PLOT PDF
%
%
% If no output is specified
if nargout == 0
        
    figure;
    hold on;
    bar(binCenter,pdf,1,'facecolor',[0 0 0],'edgecolor',[1 1 1]);
    grid on;    
   
    % Overlay theoretical pdf
    hPlot = plot(binCenter,pdfTheory,'color',[153/255 0 0],'linewidth',2);
    
    % Line style
    strLineStyle = {'-' '--' '-.' ':'};
    
    for ii = 1 : numel(hPlot)
       set(hPlot(ii),'linestyle',strLineStyle{ii})
    end
    
    legend({'data' strPDF{:}}) %#ok
    xlim([binCenter(1) binCenter(end)])
    xlabel('x');
    ylabel('f(x)');
end
