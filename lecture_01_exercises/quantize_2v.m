function y = quantize_2v(x,nBits)
    L=2^nBits;
    xMax=1;
    xMin=-1;
    qss=(xMax-xMin)/L;
    qMin=xMin+qss/2;
    qMax=xMax-qss/2;
    y=qss*(floor(x/qss)+1/2);
    y=max(y, qMin);
    y=min(y, qMax);
end