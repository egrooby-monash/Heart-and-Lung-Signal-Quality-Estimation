function heartRate=get_br_firstpeak_autocorrelation(signal_autocorrelation,max_HR,min_HR,Fs)

%% Purpose
% calculate breathing/heart rate
%% Input
% signal_autocorrelation= autocorrelation signal
% audio_data= lung sound
% Fs= sampling frequency
% min_HR and max_HR= minimum and maximum breathing rate range
%% Output
% heartRate= heart/breathing rate in bpm
min_index = round((60/max_HR)*Fs);
max_index = round((60/min_HR)*Fs); 


[~,locs,~,p] = findpeaks(signal_autocorrelation);
p=p(locs>=min_index & locs<=max_index);
locs=locs(locs>=min_index & locs<=max_index);

% find first peak with correlation prominence of max_prominence/2 in the
% specified heart rate range 

bestpeak_loc=find(p>max(p)/2,1);
index=locs(bestpeak_loc);

true_index = index-1;
heartRate = 60/(true_index/Fs);
end