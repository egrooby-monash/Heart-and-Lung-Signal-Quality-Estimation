function [bSQI] = get_bSQI_springer_liang_modified(audio_data,Fs)
%% Paper Information
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% https://www.tandfonline.com/doi/abs/10.1080/03091902.2016.1213902
%% Purpose
% A function to extract the bSQI metric, based on the agreement between two
% peak detectors within a tolerance. 
% 1. Liang et al. Method 
% Heart sound segmentation algorithm based on heart sound envelogram"
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=647841
% 2. Springer et al Method
% "Logistic regression-HSMM-based heart sound segmentation"
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7234876
%% Inputs
% audio_data: the PCG data
% Fs: the sampling frequency of the audio data
%% Output
% bSQI: the level of agreement between two beat detectors
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

%% Get the peak positions from Liang's detector method:
[peak_pos_liang,~,~] = get_Liang_peaks_modified(audio_data,Fs);
[heartRate, systolicTimeInterval] = getHeartRateSchmidt_modified(audio_data, Fs);
[peak_pos_hmm,~] = get_springer_hmm_peakpos_modified(audio, Fs,heartRate, systolicTimeInterval); 

%% Find agreement between detectors:
if(isempty(peak_pos_liang) || isempty(peak_pos_hmm))
    F1_score  = 0;
else
    % acceptint: acceptance interval (left and right) in samples
    % As 150ms is longer than the expected duration of the S1 and S2 heart sounds, this tolerance was decreased to 100ms  
    % S1 and S2 of adults is 122 +/- 32ms and 92+/-28ms with +/- being 95%
    % CI
    % factor is 5 and 95 percentile added together for term and 17+ age group
    % Term: 120-185, 17+: 60-115
    mean_factor=(120+185)/(60+115);  
    [F1_score] = Bxb_compare(peak_pos_hmm, peak_pos_liang, (0.1/mean_factor*Fs));
end

bSQI = F1_score;