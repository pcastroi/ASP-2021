function [outSig] = sdofBox(inSig,fs,Model_par,n)
% outSig should have a resonant frequency at 1kHz, not 2kHz.
% The SDOF system in the frequency domain
m=Model_par(1);
r=Model_par(2);
s=Model_par(3);

f = linspace(0,fs/2-1,length(inSig));
w = 2*pi*f;
w0 = sqrt(s/m);
H = 1/m * 1./(w0^2-w.^2+1i*w*r/m);

X = fft(inSig,n);
X = X(1:length(f));
H = H(:);
Y = H.*X;
y = ifft(Y,'symmetric');
outSig = y(1:length(inSig));   % return signal with same length as in