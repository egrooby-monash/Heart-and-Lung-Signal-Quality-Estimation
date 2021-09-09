function [psd,Fs]=power_spectrum(audio_data,f_low,f_high,fs)
%% Paper Information
% 150-450Hz gives the biggest difference in inspiration and expiration
% Another paper Breath Analysis of Respiratory Flow using Tracheal Sounds
% Saiful Huq et al. stated 300-450Hz had the biggest difference.
% Detected inspiratory peaks for analysis.
% They also considered 70-300, 600-800, 800-1000 and 1000-1200
% https://ieeexplore.ieee.org/abstract/document/4458134
% https://ieeexplore.ieee.org/abstract/document/5627437/ 
% https://idp.springer.com/authorize/casa?redirect_uri=https://link.springer.com/article/10.1007/s11517-012-0869-9&casa_token=TmU9i9f_WNEAAAAA:OkDtkVaSmGkeBRE3i_E-T_WExYIZ63nTaGbvuzySzFahnoTYsnbSreppwOs3F9rOA8NplGo74HK0IBSF 
%% Purpose
% signal with prominent breath sounds
%% Input
% audio_data= lung sound
% fs= sampling frequency
% f_low, f_high= frequency of interest
%% Output
% psd= power spectral density
% Fs= sampling frequency of power spectral density

%Bandpass 50-2500Hz
audio_data = butterworth_low_pass_filter(audio_data,2,min(2500,fs/2-1),fs);
audio_data = butterworth_high_pass_filter(audio_data,3,50,fs);


% returns the spectrogram at the cyclical frequencies specified in f.
window=200/1000*fs; %200 ms window
noverlap=window*0.5; %50% overlap
% [~,F,~,P] = spectrogram(audio_data,window,noverlap,1:1:round(fs/2),fs); 
% 
% [~, low_limit_position] = min(abs(F - f_low));
% [~, high_limit_position] = min(abs(F - f_high));
% 
% % Find the mean PSD over the frequency range of interest:
% psd = mean(P(low_limit_position:high_limit_position,:));
% 
% %psd = resample(psd',fs,fs/noverlap);
% %psd(psd<0)=0;
% psd=psd/max(psd);
% %psd = normalise_signal(psd);


[s,f,~]=stft(audio_data,fs,'Window',hann(window,'periodic'),'OverlapLength',noverlap,'Centered',1==0);
% 150-450Hz gives the biggest difference in inspiration and expiration
% Another paper Breath Analysis of Respiratory Flow using Tracheal Sounds
% Saiful Huq et al. stated 300-450Hz had the biggest difference.
% Detected inspiratory peaks for analysis.
% They also considered 70-300, 600-800, 800-1000 and 1000-1200
begin=find(f>=f_low,1,'first');
fin=find(f<=f_high,1,'last');
temp=s(begin:fin,:);
psd=mean(abs(temp).^2);
psd=psd/max(psd); 

Fs=10;
end






