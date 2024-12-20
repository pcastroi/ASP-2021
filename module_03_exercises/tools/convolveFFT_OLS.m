function y = convolveFFT_OLS(x,h,N,bZeroPad)

x = x(:);
h = h(:);

Nx = numel(x);
M = numel(h);

x = cat(1,zeros(M-1,1),x);

if nargin < 4 || isempty(bZeroPad)
    bZeroPad = true;
end

if bZeroPad
    
    x = cat(1,x,zeros(M-1,1));
    Ny = Nx + M - 1;
    
else
    
    Ny = Nx;
    
end

if nargin < 3 || isempty(N)
    [N,~] = optimalN(Nx,M); 
end


L = N - M + 1;

hZrpd = [h; zeros(N-numel(h),1)];

H = fft(hZrpd);


nBlock = ceil(numel(x)/L);

x = cat(1,x,zeros(nBlock * L - Nx,1));

ySgmt = cell(nBlock,1);

for idx_block = 1:nBlock
       
    xSgmnt = x((idx_block - 1) * L + 1 : (idx_block * L) + (M - 1));
    Xm = fft(xSgmnt);
    Ym = Xm .* H;
    ym = ifft(Ym);
    ySgmt{idx_block} = ym(M:end);
    
end

y = cat(1, ySgmt{:});

y = y(1:Ny);

end