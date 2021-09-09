function [peak_pos,assigned_states] = get_springer_hmm_peakpos_modified(audio_data, Fs,heartRate, systolicTimeInterval)

%% Paper Information
% Building on represenation used in below paper
% D. Springer et al., "Logistic Regression-HSMM-based Heart Sound
% Segmentation," IEEE Trans. Biomed. Eng., In Press, 2015.
% https://ieeexplore.ieee.org/document/7234876 

%% Purpose
% A function to detect the peaks in the PCG due to heart sounds by using
% the duration-dependant hidden Markov method developed by Springer et al

%% INPUTS:
% audio: the original audio
% Fs: the sampling frequency of the autocorrelation and audio
% pi_vector: the initial state probability vector for the HMM. This should
% be loaded from the "hmm.mat" file that was generate using a substantial
% database, which is then passed to this function
% b_matrix: the observation probability matrix. Loaded as above.
% figures: optional boolean variable dictating the display of figures
%
%% OUTPUTS:
% peak_pos: the HMM-derived peak positions (in samples)
% assigned_states is segmentation of heart sound with qt=1 corresponding to S1 and qt=3
% corresponding to S2

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

%% Find mid-position of qt segments
%Split into s1 sounds, s2 sounds and FHSounds
%S1 sounds
s1_segments = (qt ==1);
s2_segments = (qt ==3);

end_points_s1 = find(diff(s1_segments));
if(mod(length(end_points_s1),2))
    end_points_s1 = [end_points_s1, length(qt)];
end


end_points_s2 = find(diff(s2_segments));
if(mod(length(end_points_s2),2))
    
    end_points_s2 = [end_points_s2, length(qt)];
end

mid_points_s2 = zeros(1,length(end_points_s2)/2);
for i =1:2:length(end_points_s2)
    mid_points_s2((i+1)/2) = round((end_points_s2(i)+end_points_s2(i+1))/2);
end


mid_points_s1 = zeros(1,length(end_points_s1)/2);
for i =1:2:length(end_points_s1)
    mid_points_s1((i+1)/2) = round((end_points_s1(i)+end_points_s1(i+1))/2);
end

springer_options = default_Springer_HSMM_options;
%% Convert the peak positions from samples at the lower audio_segmentation_Fs to the Fs:
peak_pos = round(((sort([mid_points_s1 mid_points_s2]))./springer_options.audio_segmentation_Fs).*Fs);

% if(figures)
%     assigned_states = expand_qt(qt, springer_options.audio_segmentation_Fs, Fs, length(audio));
%     figure('Name','HMM-derived state sequence');
%     t1 = (1:length(audio))./Fs;
%     plot(t1,normalise_signal(audio),'k');
%     hold on;
%     plot(t1,assigned_states,'r--');
%     legend('Audio data', 'Derived states');
% end
% 
% 
% if(figures)
%     figure('Name','Schmidt HMM-derived Peak Positions');
%     plot(audio);
%     hold on;
%     plot(peak_pos,audio(peak_pos),'r*');
% end
