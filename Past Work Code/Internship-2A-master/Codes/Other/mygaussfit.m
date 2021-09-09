function [sigma,mu]=gaussfit(f,pxx)
px=pxx-min(pxx);
px=100*px/max(px);
px=round(px);
d=[];
for i=1:length(f)
d=[d,f(i)*ones(1,px(i))];
end
plot(f,px)
hold on,
hist(d,1000)
hold on,
y=exp( -(f-mean(d)).^2 / (2*var(d)) );
plot(f,100*y);
mu=mean(d);
sigma=std(d);
