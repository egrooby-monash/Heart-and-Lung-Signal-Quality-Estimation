function [heartRate,locs,num_peaks]=get_hr_findpeaks(envelope,max_HR,Fs)
%% Paper Information
% Building on represenation used in below paper
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% To calculate heart rate and systolicTimeInterval and locate S1 peaks

%% Inputs
% PCG: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording

%% Output
% heartRate: the heart rate of the PCG in beats per minute
% systolicTimeInterval: the duration of systole, as derived from the
% autocorrelation function, in seconds
% locs position of S1 peaks

%%%%%%%% should potentially change to +30 to be consistent with other methods
max_max_HR=max_HR+20;
y=envelope-mean(envelope);

%%%%%%%%  min peak height is not really doing much here should consider prominence value instead 
%[~, locs] = findpeaks(y,'MinPeakDistance' ,(60/max_max_HR)*Fs);
%heartRate=60/(mean(diff(locs))/Fs);
%num_peaks=length(locs);

[~, locs,p] = findpeaks(y,'MinPeakDistance' ,(30/max_max_HR)*Fs);
c=-1/(sqrt(2)*erfcinv(3/2));
scaledMAD=c*median(abs(p-median(p)));
lowthres=median(p)-2*scaledMAD;
num_peaks=sum(p>lowthres); 
locs=locs(p>lowthres); 
p=p(p>lowthres);
heartRate=30/(mean(diff(locs))/Fs); 
end