function y = compress(x,mu)
    y=sign(x).*log(1+mu.*abs(x))/log(1+mu);
end