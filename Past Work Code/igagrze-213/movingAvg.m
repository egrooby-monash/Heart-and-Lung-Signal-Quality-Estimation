%function y=movingAvg(s, size)
function y=movingAvg(s, size)

%m=s(end);
m=mean(s(1:size));%Change
y=s*0;
Norm=1/size;
sm=sum(s(1:size));
sh=round(size/2);


y(1)=m;%Change
for i=2:sh
    y(i)=(y(i-1)+sm*Norm)/2;
end
for i=2:length(s)-size-1
    sm=sm - s(i-1) + s(i+size-1);
    y(i+sh-1)=sm*Norm;
end
m=mean(s(end-size+1:end));
for i=length(s)-sh-1:length(s)
    y(i)=(y(i-1)+m)/2;
end