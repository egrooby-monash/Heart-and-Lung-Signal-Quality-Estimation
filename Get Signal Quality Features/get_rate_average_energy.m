function [rate_average_energy,rate_average_energy_2]=get_rate_average_energy(audio_downsampled_2000, Fs_2000)
%% Paper Information
% An objective measure of signal quality for pediatric lung auscultations
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9176539
%% Purpose
% Determine the average of temporal energy variations along each frequency
% channel over a range of 2-32Hz
%% Inputs
% audio_data: recording
% Fs_2000: sampling frequency
%% Output
% rate_average_energy: Rate average energy of all frequency channels within
% 2-32Hz
% rate_average_energy_2: Rate average energy of 2-32Hz freqnecy channels in
% entire frequency range
%% Method
% get power spectral density function
[~,~,psd_full,psd_full_freq] = get_psd_envelope(audio_downsampled_2000, Fs_2000);

% Fs_freq determiend from the get_psd_envelope function 
Fs_freq=80; 
% Finding optimal window size
p = nextpow2(Fs_freq*2);
window_size = 2^p;
% 50% overlap
noverlap=window_size/2; 

% rate_average_energy
meanPSD=zeros(1,length(psd_full_freq)); 
for i=1:length(psd_full_freq)
    [Pxx,F] = pwelch(psd_full(i,:),window_size,noverlap,window_size,Fs_freq);
    meanPSD(i)=meanfreq(Pxx(find(F>=2,1):find(F<=32,1,'last')),F(find(F>=2,1):find(F<=32,1,'last'))); 
end
rate_average_energy=mean(meanPSD);

% rate_average_energy_2
freq_range=find(psd_full_freq>=2,1):find(psd_full_freq<=32,1,'last');
meanPSD=zeros(1,length(freq_range)); 
for i=freq_range
    [Pxx,F] = pwelch(psd_full(i,:),window_size,noverlap,window_size,Fs_freq);
    meanPSD(i)=meanfreq(Pxx,F); 
end
rate_average_energy_2=mean(meanPSD); 
end