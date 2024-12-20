function y = convolveFFT_OLS(x,h,N,bZeroPad)
Nx = max(size(x));
M = length(h);
L = N - M + 1; %Number of samples for each block
nBlocks=ceil(Nx/L); % Number of blocks

% Zero pad h[n] to length N [nSamples x 2 channels]
h = cat(1,h,zeros(N - M,1));

% DFT of h
H = fft(h);

% Pad x[n] with M - 1 preceding zeros
x = cat(1,zeros(M-1,1),x);

% Allocate memory
y = zeros(nBlocks*L,1);

% Zero-pad input such that an integer number of blocks can be processed
x = cat(1,x,zeros(nBlocks * L - Nx,1));

% Segment x into overlapping blocks of length N with M - 1 overlap
for j=1:nBlocks
    xm = x((1:L + M - 1) + (j-1) * L);
    
    % Xm[k] = DFT{xm[n]}
    Xm=fft(xm);
    
    % Ym[k] = Xm[k]H[k]
    Ym=Xm.*H;
    
    % ym[n] = IDFT{Ym[k]}
    ym=ifft(Ym);
    
    % discard  first M-1 points
    y((1:L) + (j-1) * L) = ym(M:L + M - 1);

end
end