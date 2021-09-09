function heartRate=get_hr_peak_autocorrelation(signal_autocorrelation,max_HR,min_HR,Fs)
%% Purpose
% calculate heart rate
%% Input
% signal_autocorrelation= autocorrelation signal
% audio_data= lung sound
% Fs= sampling frequency
% min_HR and max_HR= minimum and maximum heart rate range
%% Output
% heartRate= heart rate in bpm

% min and max index to find heart rate
min_index = round((60/max_HR)*Fs); 
max_index = round((60/min_HR)*Fs); 

% find maximum peak within specified range
[~, index] = max(signal_autocorrelation(min_index:max_index));
true_index = index+min_index-1;

heartRate = 60/(true_index/Fs);
end
