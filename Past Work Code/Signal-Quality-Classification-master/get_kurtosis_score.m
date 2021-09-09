% function kSQI = get_kurtosis_score(audio_data)
%
% A function to extract the kurtosis of the PCG signal.
% This index is derived from:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% audio_data: the audio data from a PCG recording
%
%% OUTPUTS:
% kSQI: the kurtosis of the autocorrelation of the PCG signal
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

function [kSQI] = get_kurtosis_score(audio_data)

kSQI = kurtosis(audio_data);