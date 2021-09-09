function [aver_coef, std_coef]=getAverCoefStdCoef(enve,dur)
% correlation coefficients between adjacetive envelope cardiac cycle
% get average and std
% input: enve, an envelope
% dur, overall cycle duration


L=length(enve);
Ncyc=floor(L/dur);   % number of cardiac cycle

Mat=reshape(enve(1:Ncyc*dur),dur,Ncyc);  % matrix

if Ncyc>=3  % is the number of cycle greater than 3?

c=0;
for  k1=2:Ncyc-1
        c=c+1;
        dcoef1=xcorr(Mat(:,k1),Mat(:,k1-1),'coef');  % correlation betwee adjactive cycles
        coef1(c,1)=max(abs(dcoef1));
        
        dcoef2=xcorr(Mat(:,k1),Mat(:,k1+1),'coef');  % correlation betwee adjactive cycles
        coef2(c,1)=max(abs(dcoef2));  
        
        clear dcoef1 dcoef2;
end

coef=[coef1 ; coef2];

aver_coef=mean(coef);
std_coef=std(coef);

else  % cycle number is too short
    
aver_coef=0;    %  mannual set
std_coef=2;   % mannual set

end
