function [meanSumS1, meanSumS2, stdSumS1, stdSumS2] = powerAbsS1S2(A,PCG)
%POWERABSS1S2 Summary of this function goes here
%   Detailed explanation goes here
[w,~]=size(A);
S1=zeros(w,1);
S2=zeros(w,1);
for i=1:w-1
    S1(i)=sum(abs(PCG(A(i,1):A(i,2))));
end
meanSumS1=mean(S1);
stdSumS1=std(S1);

for i=1:w-1
    S2(i)=sum(abs(PCG(A(i,3):A(i,4)))); 
end

S2(isnan(S2))=[];
S2(isinf(S2))=[];
S1(isnan(S1))=[];
S1(isinf(S1))=[];

meanSumS2=mean(S2);
stdSumS2=std(S2);

end

