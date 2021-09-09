function systolicTimeInterval=get_systolicTimeInterval(signal_autocorrelation,heartRate,max_HR,Fs)
%% Purpose
%  Get systolic time interval
%% Input
% signal_autocorrelation= autocorrelation of heart sound
% heartRate= heart rate of heart sound recording
% max_HR= maximum possible heart sound
% Fs= sampling frequency
%% Output
% systolic time interval

%% Find the systolic time interval:
% From Schmidt: "The systolic duration is defined as the time from lag zero
% to the highest peak in the interval between 200 ms and half of the heart
% cycle duration"

max_sys_duration = round(((60/heartRate)*Fs)/2);
% min_sys_duration = round(0.2*Fs);
% This corresponds to 150bpm. which is 120+30 where the formula is
sysHR=max_HR+30;
min_sys_duration =  round(((60/sysHR)*Fs)/2);

[~, pos] = max(signal_autocorrelation(min_sys_duration:max_sys_duration));
systolicTimeInterval = (min_sys_duration+pos)/Fs;
end

