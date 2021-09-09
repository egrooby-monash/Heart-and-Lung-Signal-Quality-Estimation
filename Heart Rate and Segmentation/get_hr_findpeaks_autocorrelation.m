function  [heartRate,locs,numpeaks]=get_hr_findpeaks_autocorrelation(signal_autocorrelation,max_HR,Fs)
%% Purpose
% calculate heart rate
%% Input
% signal_autocorrelation= autocorrelation signal
% audio_data= lung sound
% Fs= sampling frequency
% max_HR=  maximum heart rate range
%% Output
% heartRate= heart rate
% loc= location of peaks
% num_peaks= number of peaks detected

min_index = round((60/max_HR)*Fs); 

[~, locs] = findpeaks(signal_autocorrelation,'MinPeakDistance' ,min_index);

true_index=median(diff(locs));
heartRate = 60/(true_index/Fs);
numpeaks=length(locs);
end