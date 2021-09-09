function [RMSSD,  RZC]=getFeature_Mubarak(hs,fs)
% to calculate the features based on Muhammad's algorithm
% Q Mubarak, M U Akram, A Shaukat, F Hussain, S G Khawaja, W H Butt.
% Analysis of PCG signals using quality assessment and homomorphic filter
% for localization and classification of heart sounds. Computer Methods and
% Programs in Biomedicine, 2018, 164: 143-157. 
% written by Hong Tang, 2019-04-02

hs=hs(:);   % to be collumn vector

% Heart sound signal is decomposed through discrete wavelet tansform using
% Daubechies wavelets up second level and approximation coefficients at the
% second level are used for calculation of evaluation criteria. 

[ca1,~]=dwt(hs, 'db8');  % first level decomposition
[ca2,~]=dwt(ca1, 'db8'); % second level decomposition
whs=ca2(:);
fs=fs/4;                 % scale to fs

% root mean square of successive difference, RMSSD
dif_hs=diff(whs);
RMSSD=sqrt(mean(dif_hs.^2));

% ratio of zero crossing in the signal to the length of signal, RZC
hs1=whs(1:end-1);
hs2=whs(2:end);
mhs=hs1.*hs2;
num_zcross=sum(mhs<0);
RZC=num_zcross/length(hs);

