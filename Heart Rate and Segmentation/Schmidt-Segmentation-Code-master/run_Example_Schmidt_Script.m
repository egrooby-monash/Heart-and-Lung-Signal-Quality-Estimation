%% Example_Schmidt_script
% A script to demonstrate the use of the Schmidt segmentation algorithm

close all;
clear all;

%% Load the default options:
% These options control options such as the original sampling frequency of
% the data, the sampling frequency for the derived features and whether the
% mex code should be used for the Viterbi decoding:
schmidt_options = default_Schmidt_HSMM_options;

%% Load the audio data and the annotations:
% These are 6 example PCG recordings, downsampled to 1000 Hz, with
% annotations of the R-peak and end-T-wave positions.
load('example_data.mat');

%% Split the data into train and test sets:
% Select the first 5 recordings for training and the sixth for testing:
train_recordings = example_data.example_audio_data([1:5]);
train_annotations = example_data.example_annotations([1:5],:);

test_recordings = example_data.example_audio_data(6);
test_annotations = example_data.example_annotations(6,:);


%% Train the HMM:
[B_matrix, pi_vector] = trainSchmidtSegmentationAlgorithm(train_recordings,train_annotations,schmidt_options.audio_Fs, false);


%% Run the HMM on an unseen test recording:
% And display the resulting segmentation
numPCGs = length(test_recordings);

for PCGi = 1:numPCGs
    [assigned_states] = runSchmidtSegmentationAlgorithm(test_recordings{PCGi}, schmidt_options.audio_Fs, B_matrix, pi_vector, true);
end


