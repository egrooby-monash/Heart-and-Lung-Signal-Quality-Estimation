function heartRate=get_br_earlypeak_autocorrelation(signal_autocorrelation,max_HR,min_HR,Fs)
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

% find all peaks within range of interest
[peaks,locs,~,p] = findpeaks(signal_autocorrelation);
p=p(locs>=min_index & locs<=max_index);
locs=locs(locs>=min_index & locs<=max_index);
peaks=peaks(locs>=min_index & locs<=max_index);
[~,I]=max(peaks);
index=locs(I);
val=0;
max_p=max(p);
% check if there is an earlier peak than max peak found
while val<0.05*Fs
    [val,I]=min(abs(locs-index/2));
    prom=p(I);
    if val<0.1*Fs && prom>max_p/2
        index=locs(I);
    else
        break
    end
end
true_index = index-1;
heartRate = 60/(true_index/Fs);
end