function [RMSSD,  RZC]=get_wavelet_mubarak(hs)
%% Paper Information
% Analysis of PCG signals using quality assessment and homomorphic filters for localization and classification of heart sounds
% https://reader.elsevier.com/reader/sd/pii/S0169260718303596?token=BCE2CE37A7B30CA802618D72F26C8110294D3BE20C6C531A50359E2E61DCE98550072BF9C21048BBCF075141E50D1C09&originRegion=us-east-1&originCreation=20210526053544

%% Purpose
% to calculate the features based on Muhammad's algorithm
% Q Mubarak, M U Akram, A Shaukat, F Hussain, S G Khawaja, W H Butt.
% Analysis of PCG signals using quality assessment and homomorphic filter
% for localization and classification of heart sounds. Computer Methods and
% Programs in Biomedicine, 2018, 164: 143-157. 
% written by Hong Tang, 2019-04-02

%% Input

%% Outputs
% RMSSD: root mmean square of successive diferences of wavelet
% decomposiiton
% RZC:zero crossing rate of wavelet decomposition

%% Method
% to be collumn vector
hs=hs(:);   

% Heart sound signal is decomposed through discrete wavelet tansform using
% Daubechies wavelets up second level and approximation coefficients at the
% second level are used for calculation of evaluation criteria. 

[ca1,~]=dwt(hs, 'db8');  % first level decomposition
[ca2,~]=dwt(ca1, 'db8'); % second level decomposition
whs=ca2(:);

% root mean square of successive difference, RMSSD
dif_hs=diff(whs);
RMSSD=sqrt(mean(dif_hs.^2));

% ratio of zero crossing in the signal to the length of signal, RZC
hs1=whs(1:end-1);
hs2=whs(2:end);
mhs=hs1.*hs2;
num_zcross=sum(mhs<0);
RZC=num_zcross/length(hs);
end