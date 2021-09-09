% function assigned_states = runSchmidtSegmentationAlgorithm(audio_data, Fs, B_matrix, pi_vector, figures)
%
% A function to assign states to a PCG recording based on a trained
% duration-dependant HMM
%
%% INPUTS:
% audio_data: The raw audio data from the PCG recording
% Fs: the sampling frequency of the audio recording
% B_matrix: the observation matrix for the HMM, trained in the 
% "trainSchmidtSegmentationAlgorithm.m" function
% pi_vector: the initial state distribution, also trained in the 
% "trainSchmidtSegmentationAlgorithm.m" function
% figures: (optional) boolean variable for displaying figures
%
%% OUTPUTS:
% assigned_states: the array of state values assigned to the original
% audio_data (in the original sampling frequency).
%
% This code is derived from the paper:
% S. E. Schmidt et al., "Segmentation of heart sound recordings by a 
% duration-dependent hidden Markov model," Physiol. Meas., vol. 31,
% no. 4, pp. 513-29, Apr. 2010.
%
% Developed by David Springer for comparison purposes in the paper:
% D. Springer et al., ?Logistic Regression-HSMM-based Heart Sound 
% Segmentation,? IEEE Trans. Biomed. Eng., In Press, 2015.
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


function assigned_states = runSchmidtSegmentationAlgorithm_modified(audio_data, Fs, figures)

%% Preliminary
if(nargin < 5)
    figures = false;
end

load('hmm.mat','b_matrix');
load('hmm.mat', 'pi_vector');
% Ensure b_matrix is in correct format:
[len, wid] = size(b_matrix);
if(wid>len)
    b_matrix = b_matrix';
end
B_matrix=b_matrix; 

%% Load the trained parameter matrices for Springer's HSMM model.
% The parameters were trained using 409 heart sounds from MIT heart
% sound database, i.e., recordings a0001-a0409.
%load('Springer_B_matrix.mat', 'Springer_B_matrix');
%load('Springer_pi_vector.mat', 'Springer_pi_vector');
%B_matrix=Springer_B_matrix; 
%pi_vector=Springer_pi_vector;

%% Get PCG Features:
[PCG_Features, featuresFs] = getSchmidtPCGFeatures(audio_data, Fs);

%% Get PCG heart rate

[heartRate, systolicTimeInterval] = getHeartRateSchmidt_modified(audio_data, Fs);

[~, ~, qt] = viterbiDecodePCG_Schmidt_modified(PCG_Features, pi_vector, B_matrix,heartRate, systolicTimeInterval, featuresFs);

assigned_states = expand_qt(qt, featuresFs, Fs, length(audio_data));

if(figures)
   figure('Name','Derived state sequence');
   t1 = (1:length(audio_data))./Fs;
   plot(t1,audio_data,'k');
   hold on;
   plot(t1,assigned_states,'r--');
   legend('Audio data', 'Derived states');
end








