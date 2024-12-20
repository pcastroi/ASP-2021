function [x,t] = genChirp(fs,f0,T,f1,phi0)
    t=0:(1/fs):(T-1/fs); % Ts = 1/fs
    x=sin(2*pi*(f0+((((f1-f0)/T)/2).*t)).*t+phi0);
end