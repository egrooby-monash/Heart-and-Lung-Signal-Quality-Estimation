% function [seSQI, svdSQI, hSQI, ccSQI, sdrSQI, vSQI, mSQI, kSQI, bSQI] = getSignalQualityIndices(audio_data, Fs,pi_vector, b_matrix,figures)
%
% A function to extract signal quality indices from heart sound recordings.
% These indices are based on the paper:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% audio_data: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording
% pi_vector, b_matrix: the HMM parameters needed for the bSQI. Instead of
% being loaded for each signal, these should be loaded from the "hmm.mat"
% file once and passed to this function.
% figures: (optional) boolean variable for displaying figures
%
%% OUTPUTS:
% [seSQI, svdSQI, hSQI, ccSQI, sdrSQI, vSQI, mSQI, kSQI, bSQI]
% These are the nine signal quality indices derived from the PCG recordings
% as outlined in the above publication
%
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

function [seSQI, svdSQI, hSQI, ccSQI, sdrSQI, vSQI, mSQI, kSQI, bSQI] = getSignalQualityIndices(audio_data, Fs,pi_vector, b_matrix,figures)

%% Prelim
if nargin < 3
    figures = false;
end
springer_options = default_Springer_Signal_Quality_options;

%% Resample to the frequency set in the options file:
audio_downsampled = resample(audio_data,springer_options.audio_Fs,Fs);

%% Remove noise spikes in the signal using the method developed by Schmidt et al:
[audio_downsampled] = schmidt_spike_removal(audio_downsampled,springer_options.audio_Fs);

%% Get the truncated and untrancated autocorrelation functions:
[truncated_autocorrelation, untruncated_autocorrelation] = get_autocorrelation(audio_downsampled,springer_options.audio_Fs,figures);

%% Get the sample_entropy sqi:
M = 2;
r = 0.0008;
[seSQI] = get_entropy(truncated_autocorrelation, M, r);

%% Get the SVD sqi:
[svdSQI] = get_SVD_score(truncated_autocorrelation,springer_options.audio_Fs);

%% Get Hjorth activity score
[hSQI] = get_hjorth_activity_score(truncated_autocorrelation);

%% get ccSQI:
[ccSQI] = get_ccSQI(untruncated_autocorrelation, springer_options.audio_Fs, figures);

%% Get the sdrSQI
audio_downsampled_2000 = resample(audio_data,2000,Fs);
[sdrSQI] = get_signal_to_noise_psd_score(audio_downsampled_2000,2000);

%% Get the vSQI 
[vSQI] = get_variance_score(truncated_autocorrelation);

%% Get mSQI:
[mSQI, ~] = get_max_peak_in_autocorrelation(untruncated_autocorrelation, springer_options.audio_Fs,figures);

%% get kSQI:
[kSQI] = get_kurtosis_score(audio_data);

%% get bSQI
[bSQI] =get_bSQI(audio_data,Fs,pi_vector, b_matrix,figures);

