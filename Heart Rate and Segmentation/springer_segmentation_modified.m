function assigned_states= springer_segmentation_modified(audio_data,Fs, heartRate, systolicTimeInterval)
%% Paper Information
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% A function to assign states to a PCG recording using a duration dependant
% logisitic regression-based HMM, using the trained B_matrix and pi_vector
% trained in "trainSpringerSegmentationAlgorithm.m". Developed for use in
% the paper:

%% Inputs
% audio_data: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording
% heartRate: the heart rate of the PCG in beats per minute
% systolicTimeInterval: the duration of systole, as derived from the
% autocorrelation function, in seconds

%% Output
% assigned_states: the array of state values assigned to the original
% audio_data (in the original sampling frequency).

%% Get PCG Features:
[PCG_Features, featuresFs] = getSpringerPCGFeatures(audio_data, Fs);

%% Load the trained parameter matrices for Springer's HSMM model.
% The parameters were trained using 409 heart sounds from MIT heart
% sound database, i.e., recordings a0001-a0409.
load('Springer_B_matrix.mat', 'Springer_B_matrix');
load('Springer_pi_vector.mat', 'Springer_pi_vector');
load('Springer_total_obs_distribution.mat', 'Springer_total_obs_distribution');

[~, ~, qt] = viterbiDecodePCG_Springer_modified(PCG_Features, Springer_pi_vector, Springer_B_matrix, Springer_total_obs_distribution, heartRate, systolicTimeInterval, featuresFs);
assigned_states = expand_qt(qt, featuresFs, Fs, length(audio_data));

end
