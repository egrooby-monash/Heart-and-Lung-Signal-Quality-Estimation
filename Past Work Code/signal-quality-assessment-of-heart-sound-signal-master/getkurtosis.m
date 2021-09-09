function kur=getkurtosis(x)
% to calculate kurtosis of input signal
% x, a digital sequence

% to remove average
x=x-mean(x);

k1=sum(x.^4)/length(x);
k2=sum(x.^2)/length(x);

% to avoid inf, eps is used.
kur=k1/(k2^2+eps);



