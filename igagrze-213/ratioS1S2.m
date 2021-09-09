function [meanratioS2S1,stdratioS2S1] = ratioS1S2(A,PCG)
%POWERABSS1S2 Summary of this function goes here
%   Detailed explanation goes here
[w,~]=size(A);
S1=zeros(w-1,1);

for i=1:w-1
    S1(i)=(max(PCG(A(i,1):A(i,2))))-(min(PCG(A(i,1):A(i,2))));
   
end

S2=zeros(w-1,1);

for i=1:w-1
    S2(i)=(max(PCG(A(i,3):A(i,4))))-(min(PCG(A(i,3):A(i,4))));
end

ratioS2S1=S2./S1;
ratioS2S1=ratioS2S1(~isnan(ratioS2S1) & ~isinf(ratioS2S1));
meanratioS2S1=mean(ratioS2S1);
stdratioS2S1=std(ratioS2S1);

end

