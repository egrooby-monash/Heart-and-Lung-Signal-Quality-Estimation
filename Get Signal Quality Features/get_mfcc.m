function [coeffs,min_coeffs,max_coeffs,mean_coeffs,median_coeffs,mode_coeffs,var_coeffs] = get_mfcc(audio_data,Fs)
%% Paper Information
% Improving the quality of point of care diagnostics with real-time machine learning in low literacy LMIC settings
% https://dl.acm.org/doi/pdf/10.1145/3209811.3209815 
% Automatic signal quality index determination of radar-recorded heart sound signals using ensemble classification
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8731709
%% Purpose
% get Mel-frequency cepstral coefficient features
%% INPUTS:
% audio_data: the audio data from a PCG recording
% Fs: sampling frequency
%% OUTPUTS:
% coeffs= log energy + 13 MFCC coefficients
% minimum, maximum, mean, median, mode and variance of these features
% accross all windows

%13 features
%Frame the window using a hamming window and a window length of 25 ms with a sliding window of 10 ms.
coeffs = mfcc(audio_data,Fs,'WindowLength',round(0.025*Fs),...
    'OverlapLength',round(0.015*Fs),'NumCoeffs',13);
min_coeffs=min(coeffs);
max_coeffs=max(coeffs);
mean_coeffs=mean(coeffs);
median_coeffs=median(coeffs);
mode_coeffs=mode(coeffs);
var_coeffs=var(coeffs);


coeffs = mfcc(audio_data,Fs,'WindowLength',length(audio_data),'NumCoeffs',13);

end
