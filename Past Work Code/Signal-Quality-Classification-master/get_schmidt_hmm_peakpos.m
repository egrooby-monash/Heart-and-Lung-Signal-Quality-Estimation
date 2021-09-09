% function [peak_pos] = get_schmidt_hmm_peakpos(audio, Fs, pi_vector, b_matrix,figures)
%
% A function to detect the peaks in the PCG due to heart sounds by using
% the duration-dependant hidden Markov method developed by Schmidt et al:
% S. E. Schmidt et al., "Segmentation of heart sound recordings by a
% duration-dependent hidden Markov model," Physiol. Meas., vol. 31,
% no. 4, pp. 513-29, Apr. 2010.
%
% Developed by David Springer for implementation in the paper:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
% This file has an op
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

function [peak_pos] = get_schmidt_hmm_peakpos(audio, Fs, pi_vector, b_matrix,figures)

if(nargin<5)
    figures = false;
end
%% Options:
springer_options = default_Springer_Signal_Quality_options;

%% Getting heart rate and systolic duration from autocorrelation
% As performed in Schmidt's paper:
[heart_rate, systolic_time] = getHeartRateSchmidt(audio, Fs);

%% Extract Homomorphic Envelope
% Downsampled from the original audio Fs to the lower
% "audio_segmentation_Fs"

sprintf('Calculating Homomorphic Envelope');
homomorphic_envelope = Homomorphic_Envelope_with_Hilbert(audio, Fs);
homomorphic_envelope = resample(homomorphic_envelope,springer_options.audio_segmentation_Fs, Fs);
homomorphic_envelope = normalise_signal(homomorphic_envelope);


%% Decoding
[~, ~, qt] = viterbiDecodePCG(homomorphic_envelope, pi_vector, b_matrix,heart_rate, systolic_time, springer_options.audio_segmentation_Fs);

%% Find mid-position of qt segments
%Split into s1 sounds, s2 sounds and FHSounds
%S1 sounds
s1_segments = (qt ==1);
s2_segments = (qt ==3);

end_points_s1 = find(diff(s1_segments));
if(mod(length(end_points_s1),2))
    end_points_s1 = [end_points_s1, length(homomorphic_envelope)];
end


end_points_s2 = find(diff(s2_segments));
if(mod(length(end_points_s2),2))
    
    end_points_s2 = [end_points_s2, length(homomorphic_envelope)];
end

mid_points_s2 = zeros(1,length(end_points_s2)/2);
for i =1:2:length(end_points_s2)
    mid_points_s2((i+1)/2) = round((end_points_s2(i)+end_points_s2(i+1))/2);
end


mid_points_s1 = zeros(1,length(end_points_s1)/2);
for i =1:2:length(end_points_s1)
    mid_points_s1((i+1)/2) = round((end_points_s1(i)+end_points_s1(i+1))/2);
end


%% Convert the peak positions from samples at the lower audio_segmentation_Fs to the Fs:
peak_pos = round(((sort([mid_points_s1 mid_points_s2]))./springer_options.audio_segmentation_Fs).*Fs);




if(figures)
    assigned_states = expand_qt(qt, springer_options.audio_segmentation_Fs, Fs, length(audio));
    figure('Name','HMM-derived state sequence');
    t1 = (1:length(audio))./Fs;
    plot(t1,normalise_signal(audio),'k');
    hold on;
    plot(t1,assigned_states,'r--');
    legend('Audio data', 'Derived states');
end


if(figures);
    figure('Name','Schmidt HMM-derived Peak Positions');
    plot(audio);
    hold on;
    plot(peak_pos,audio(peak_pos),'r*');
end
