% [bSQI] = get_bSQI(audio_data,Fs,pi_vector, b_matrix,figures)
%
% A function to extract the bSQI metric, based on the agreement between two
% peak detectors within a tolerance.
%
% Implemented in:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% audio_data: the PCG data
% Fs: the sampling frequency of the audio data
% pi_vector, b_matrix - trained parameters for the HMM-based method. Loaded
% from the "hmm.mat" file which was trained on different, substantial,
% database as outlined in the paper by Springer et al.
% figures: optional boolean variable dictating the display of figures
%
%% OUTPUTS:
% bSQI: the evel of agreement between two beat detectors
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

function [bSQI] = get_bSQI_original(audio_data,Fs)
%% Get the peak positions from Liang's detector method:
[peak_pos_liang,~,~] = get_Liang_peaks_original(audio_data,Fs);
[peak_pos_hmm,~] = get_schmidt_hmm_peakpos_original(audio,Fs); 

%% Find agreement between detectors:
if(isempty(peak_pos_liang) || isempty(peak_pos_hmm))
    F1_score  = 0;
else
    [F1_score] = Bxb_compare(peak_pos_hmm, peak_pos_liang, 0.1*Fs);
end

bSQI = F1_score;