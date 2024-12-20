function [x,t] = genSin(fs,T,f0,A0)
    Ts = 1/fs;
    t = 0:Ts:T-Ts;
    x = zeros(1,length(t));
    for i = 1:length(f0)
        x = x + A0(i)*sin(2*pi*f0(i).*t);
    end
end