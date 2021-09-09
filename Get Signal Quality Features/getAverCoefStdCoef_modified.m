function [aver_coef, std_coef]=getAverCoefStdCoef_modified(enve,dur)
%% Paper Information
% Automated Signal Quality Assessment for Heart Sound Signal by Novel Features and Evaluation in Open Public Datasets
% https://downloads.hindawi.com/journals/bmri/2021/7565398.pdf

%% Purpose
% cariac cycle variation 

%% Inputs
% enve, an envelope
% dur, overall cycle duration

%% Output
% correlation coefficients between adjacetive envelope cardiac cycle
% get average and std

%% Methods
L=length(enve);
% number of cardiac cycle
Ncyc=floor(L/dur);

% matrix
Mat=reshape(enve(1:Ncyc*dur),dur,Ncyc);

% is the number of cycle greater than 3?
if Ncyc>=3  
    coef1=zeros(Ncyc-2,1);
    coef2=zeros(Ncyc-2,1);
    for  k1=2:Ncyc-1
        % correlation between adjactive cycles
        dcoef1=xcorr(Mat(:,k1),Mat(:,k1-1),'coef');  
        coef1(k1-1,1)=max(abs(dcoef1));
        
        % correlation between adjactive cycles
        dcoef2=xcorr(Mat(:,k1),Mat(:,k1+1),'coef');  
        coef2(k1-1,1)=max(abs(dcoef2));
    end
    
    coef=[coef1 ; coef2];
    
    aver_coef=mean(coef);
    std_coef=std(coef);
else  % cycle number is too short
    aver_coef=0;    %  mannual set
    std_coef=2;   % mannual set
end
end


