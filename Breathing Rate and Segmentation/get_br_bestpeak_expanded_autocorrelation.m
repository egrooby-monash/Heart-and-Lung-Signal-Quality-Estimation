function heartRate=get_br_bestpeak_expanded_autocorrelation(signal_autocorrelation,max_HR,min_HR,Fs)
%% Purpose
% calculate breathing/heart rate
%% Input
% signal_autocorrelation= autocorrelation signal
% audio_data= lung sound
% Fs= sampling frequency
% min_HR and max_HR= minimum and maximum breathing rate range
%% Output
% heartRate= heart/breathing rate in bpm

% min and max index to find heart rate
min_index = round((60/max_HR)*Fs); 
max_index = round((60/min_HR)*Fs); 
% find peaks
[~,locs,~,p] = findpeaks(signal_autocorrelation);
% find strongest peak based on correlation prominence
p=p(locs>=min_index & locs<=max_index); 
locs=locs(locs>=min_index & locs<=max_index); 
[~, bestpeak_loc]=max(p);
true_index=locs(bestpeak_loc)-1;

heartRate = 60/(true_index/Fs);
end
