function [wavelet_feature] = get_wavelet_envelope(audio_data, Fs)
%% Paper Information
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% Get wavelet envelope

%% Inputs
% PCG: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording

%% Output
% wavelet envelope
%% Wavelet features:
wavelet_level = 3;
wavelet_name ='rbio3.9';

% Audio needs to be longer than 1 second for getDWT to work:
if(length(audio_data)< Fs*1.025)
    audio_data = [audio_data; zeros(round(0.025*Fs),1)];
end

[cD, ~] = getDWT(audio_data,wavelet_level,wavelet_name);

wavelet_feature = abs(cD(wavelet_level,:));
wavelet_feature = wavelet_feature(1:length(audio_data));
wavelet_feature =  normalise_signal(wavelet_feature)';
end