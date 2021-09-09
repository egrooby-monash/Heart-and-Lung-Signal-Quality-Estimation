function [hilbert_envelope] = get_hilbert_envelope(audio_data, Fs)
%% Paper Information
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% Get hilbert envelope

%% Inputs
% PCG: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording

%% Output
% hilbert envelope
%% Method
hilbert_envelope = Hilbert_Envelope(audio_data, Fs);
hilbert_envelope = normalise_signal(hilbert_envelope);
end
