function p=percentilefreq(pxx,f,pi)
t=0;
for i=2:length(f)
t(i)=trapz(f(1:i),pxx(1:i));
end
t=100*t/max(t);
p=interp1(t,f,pi);

