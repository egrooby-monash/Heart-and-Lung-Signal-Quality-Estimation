% function [mSQI] = get_peak_in_autocorrelation(untruncated_autocorrelation, Fs, figures)
%
% A function to extract amplitude of the maximum peak in the autocorrelation
% signal between lag values of 0.5 and 2.33 seconds.
% Developed as part of:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% 
% This function requires the Matlab implementation of the "sampen.m" function from physionet:
% https://physionet.org/physiotools/sampen/
%
%% INPUTS:
% untruncated_autocorrelation: The untruncated autocorrelation of the audio
% data from the PCG recording. Derived in "get_autocorrelation.m".
% Fs: the sampling frequency of the autocorrelation
% figures: optional boolean variable to display figures
%
%% OUTPUTS:
% sample_entropy: Sample entropy of the autocorrelation signal
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

function [mSQI, pos] = get_max_peak_in_autocorrelation(untruncated_autocorrelation, Fs,figures)
if nargin < 3
    figures = 0;
end

% Set the heart rate limits
% 0.43*Fs corresponds to 140 BPM
% 2*Fs corresponds to 30 BPM
start_point = round(Fs*0.43);
end_point = round(Fs*2);

% Find the amplitude and position of the maximum peak between these two limits:
[mSQI, pos] = max(untruncated_autocorrelation(start_point:end_point));
pos = pos + start_point + 1;

if(figures)
    figure('Name','mSQI plot');
    plot(untruncated_autocorrelation);
    hold on;
    plot(pos,mSQI,'ko');
    legend('Autocorrelation', 'Position of maximum peak between heart rate limits');
end


