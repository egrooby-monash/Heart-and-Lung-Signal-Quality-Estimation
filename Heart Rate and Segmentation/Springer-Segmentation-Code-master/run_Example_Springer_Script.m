%% Example Springer script
% A script to demonstrate the use of the Springer segmentation algorithm

%% Copyright (C) 2016  David Springer
% dave.springer@gmail.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%
close all;
clear all;

%% Load the default options:
% These options control options such as the original sampling frequency of
% the data, the sampling frequency for the derived features and whether the
% mex code should be used for the Viterbi decoding:
springer_options = default_Springer_HSMM_options;

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
[B_matrix, pi_vector, total_obs_distribution] = trainSpringerSegmentationAlgorithm(train_recordings,train_annotations,springer_options.audio_Fs, false);

%% Run the HMM on an unseen test recording:
% And display the resulting segmentation
numPCGs = length(test_recordings);

for PCGi = 1:numPCGs
    [assigned_states] = runSpringerSegmentationAlgorithm(test_recordings{PCGi}, springer_options.audio_Fs, B_matrix, pi_vector, total_obs_distribution, true);
end

