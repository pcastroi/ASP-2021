function [b,a] = genFilterBiquad(fs,fc,type)

if contains(type,'lowpass')
    K=tan(pi*fc/fs);
    Q=1/sqrt(2);
    a(1)=1;
    a(2)=(2*Q*(K^2-1))/(K^2*Q+K+Q);
    a(3)=(K^2*Q-K+Q)/(K^2*Q+K+Q);
    b(1)=K^2*Q/(K^2*Q+K+Q);
    b(2)=2*K^2*Q/(K^2*Q+K+Q);
    b(3)=b(1);
elseif contains(type,'highpass')
    K=tan(pi*fc/fs);
    Q=1/sqrt(2);
    a(1)=1;
    a(2)=(2*Q*(K^2-1))/(K^2*Q+K+Q);
    a(3)=(K^2*Q-K+Q)/(K^2*Q+K+Q);
    b(1)=Q/(K^2*Q+K+Q);
    b(2)=-2*Q/(K^2*Q+K+Q);
    b(3)=b(1);
elseif contains(type,'bandpass')
    f1=fc(1);
    f2=fc(2);
    K=tan(pi*sqrt(f1*f2/fs));
    Q=sqrt(f1*f2)/f2-f1;
    b(1)=K/(K^2*Q+K+Q);
    b(2)=0;
    b(3)=-b(1);
elseif contains(type,'bandreject')
    f1=fc(1);
    f2=fc(2);
    K=tan(pi*sqrt(f1*f2/fs));
    Q=sqrt(f1*f2)/f2-f1;
    a(1)=1;
    a(2)=(2*Q*(K^2-1))/(K^2*Q+K+Q);
    a(3)=(K^2*Q-K+Q)/(K^2*Q+K+Q);
    b(1)=Q*(1+K^2)/(K^2*Q+K+Q);
    b(2)=2*Q*(K^2-1)/(K^2*Q+K+Q);
    b(3)=b(1);
end
end