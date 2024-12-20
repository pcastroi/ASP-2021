function [H1,H2,C,f] = computeFRF(x,y,fsHz,w,R,M)

if length(x)~=length(y)
    maxlen = max(length(x),length(y));
    x(end+1:maxlen) = 0;
    y(end+1:maxlen) = 0;
end

% STFT analysis
[X, t, f] = stft(x,fsHz,w,R,M);
Y = stft(y,fsHz,w,R,M);

% Time-averaging of power spectra
XX = mean(X .* conj(X),2); 
YY = mean(Y .* conj(Y),2); 
XY = mean(X .* conj(Y),2);

% H1 and H2
H1=XY./XX;
H2=YY./conj(XY);

% Coherence
C=(abs(XY).^2)./(XX.*YY);
end