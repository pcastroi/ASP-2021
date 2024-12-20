function [X,t,f] = stft(x,fs,w,R,M)

    %Make sure x and w are column vectors
    x = x(:);
    w = w(:);
    
    Nx = length(x);

    % Window size
    N = length(w);
    
    % Overlap
    O = N - R;
    
    % Compute the number of frames
    L = ceil((Nx - O) / R);
    
    % Zero-padded input such that it can be divided into an integer number
    % of frames 
    x = cat(1,x,zeros(round((O + L * R) - Nx),1));
    
    % Initialization of the 2D matrix X (M = rows; L = columns)
    X = zeros(M,L);
    
    %t : time vector in seconds [1 x L]
    t = 0:(Nx/fs)/L:(Nx/fs)-(Nx/fs)/L;
    
    %f : frequency vector in Hertz [M x 1]
    f = 0:fs/M:fs-fs/M; %f = 0:fs/(2*N):fs-fs/(2*N) for half the f
    f = f';
    
    % Loop over the number of frames
    for ii = 0 : L - 1
        
        % Sample indices
        idx = (1:N) + ii * R;

        % Time segmentation
        xHat = x(idx);

        % Windowing
        xHat = xHat .* w;
        
        % Zero-padding only if M =! N(could use the function also)
        if M ~= N
            xHat = cat(1,xHat,zeros(M-N,1));
        end
        % DFT
        X(:,(ii+1)) = fft(xHat,M);
    end
end