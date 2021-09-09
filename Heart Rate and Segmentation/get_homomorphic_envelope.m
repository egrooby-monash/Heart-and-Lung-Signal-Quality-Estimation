function [homomorphic_envelope] = get_homomorphic_envelope(audio_data, Fs)
%% Paper Information
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% Get homomorphic envelope

%% Inputs
% PCG: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording

%% Output
% homomorphic envelope

%% Find the homomorphic envelope
homomorphic_envelope = Homomorphic_Envelope_with_Hilbert(audio_data, Fs);
% normalise the envelope:
homomorphic_envelope = normalise_signal(homomorphic_envelope);

end