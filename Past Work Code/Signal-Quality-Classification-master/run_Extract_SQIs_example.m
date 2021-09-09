%% Test feature extraction:
close all;
clear all;

% Load the options
springer_options = default_Springer_Signal_Quality_options;

% Load the hidden Markov model parameters that have been trained on a
% substantial database and saved. This loads the pi_vector and b_matrix
% variables which are passed to the getSignalQualityIndices.m function:
load('hmm.mat');

% Set the "figures" parameter to be true, in order to display the figures
% in the feature extraction functions
figures = true;

% Read the .wav file
[orignal_audio_data, originalFs] = wavread('example_PCG.wav');

% Downsample the .wav file to the frequency saved in the options file:
audio_data = resample(orignal_audio_data,springer_options.audio_Fs, originalFs);

% Extract the features
[seSQI, svdSQI, hSQI, ccSQI, sdrSQI, vSQI, mSQI, kSQI, bSQI] = getSignalQualityIndices(audio_data, springer_options.audio_Fs,pi_vector, b_matrix,figures);