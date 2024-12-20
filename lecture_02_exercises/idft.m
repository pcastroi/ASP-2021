function x = idft(X)
N=length(X);
x=zeros(1,N);
    for n = 1:N
        for k = 1:N
            x(n) = x(n)+X(k)*exp(1i*(2*pi/N)*(k-1)*(n-1));
        end
    end
    x=x./N;
end