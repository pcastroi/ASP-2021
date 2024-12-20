function [H,w] = calcFreqResponse(b,a,N_DFT)
N = numel(a);
M = numel(b);

k=0:N_DFT-1;
w=(2*pi/N_DFT).*k;

H=zeros(N_DFT,1);

for ww=1:length(w)
    numerator=0;
    denominator=0;
    for j=1:M
       numerator=numerator+b(j)*exp(-1i*w(ww)*j);
    end
    for k=1:N
       denominator=denominator+a(k)*exp(-1i*w(ww)*k);
    end
    H(ww)=numerator/denominator;
end


end