function y = expand(x,mu)
    y=sign(x).*(((1+mu).^abs(x)-1)/mu);
end