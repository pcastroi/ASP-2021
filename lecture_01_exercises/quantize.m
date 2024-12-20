function y = quantize(x,nBits,xMin,xMax)
    L=2^nBits;
    qss=(xMax-xMin)/L;
    qMin=xMin+qss/2;
    qMax=xMax-qss/2;
    y=qss*(floor(x/qss)+1/2);
    y=max(y, qMin);
    y=min(y, qMax);
end