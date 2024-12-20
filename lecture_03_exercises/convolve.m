function y = convolve(x,h)
%% Function that convolves the input x with h
%
%
    N = length(x);
    M = length(h);
    L = N+M-1;
    y = zeros(L,1);

    for n = 0:L-1
        for m = 0:n
            if (0<=m) && (m<=N-1) && (0<=n-m) && (n-m<=M-1)
                y(n+1) = y(n+1)+(x(m+1)*h(n-m+1));
            end
        end
    end
    y = y';
end