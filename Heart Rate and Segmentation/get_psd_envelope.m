function [psd,psd_original,P,F] = get_psd_envelope(audio_data, Fs)
%% Paper Information
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% Get power spectral density envelope

%% Inputs
% PCG: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording

%% Output
% psd envelope
%% Power spectral density feature:
%psd = get_PSD_feature_Springer_HMM(audio_data, Fs, 40,60)';
[psd,psd_original,P,F] = get_PSD_feature_Springer_HMM_modified(audio_data, Fs, 40,60);
%psd = resample(psd', length(audio_data), length(psd));
psd = resample(psd', Fs, 80);
psd = normalise_signal(psd);
%psd_original = resample(psd_original', length(audio_data), length(psd_original));
psd_original = resample(psd_original', Fs, 80);
psd_original = normalise_signal(psd_original);
end
