function heartRate=get_br_firstoutlierpeak_autocorrelation(signal_autocorrelation,max_HR,min_HR,Fs)
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

% min and max index to find heart rate
[~,locs,~,p] = findpeaks(signal_autocorrelation);
locs=locs(locs>=min_index&locs<=max_index);
p=p(locs>=min_index&locs<=max_index);
% find first peak with correlation prominence of greater than 0.05 
if max(p)<=0.05
    bestpeak_loc=find(p==max(p),1);
else
    bestpeak_loc=find(p>0.05,1);
end
index=locs(bestpeak_loc);
true_index = index-1;
heartRate = 60/(true_index/Fs);
end