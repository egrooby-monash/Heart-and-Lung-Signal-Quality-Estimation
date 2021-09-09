function [signal_autocorrelation,signal_autocorrelation_filtered]=get_hr_autocorrelation(envelope,Fs)
%% Purpose
% get autocorrelation signal 
%% Input
% envelope= envelope of chest sound
% Fs= sampling frequency
%% Output
% filtered and unfiltered autocorrelation signals 
y=envelope-mean(envelope);
[c] = xcorr(y,'coeff');
signal_autocorrelation = c(length(envelope)+1:end);

% Low-pass filter the autocorrelation:
if Fs<15
    signal_autocorrelation_filtered = signal_autocorrelation;
else
    signal_autocorrelation_filtered = butterworth_low_pass_filter(signal_autocorrelation,1,15,Fs, false);
end
end