function [y] = filterbp(x,Fs)
%% Gives the filtered signal
% input = raw audio signal read as x
% Fs = sampling frequency
% output = band pass filtered signal with cut off frequencies of 0.5hz, and
% 350 hz
[b,a] = butter(6,2*[100 1200]./Fs,'bandpass');
y = filtfilt(B_low,A_low,x);
%audiowrite('filtered_signal.wav',y,Fs); % writing the filtered signal to an audio file
end

