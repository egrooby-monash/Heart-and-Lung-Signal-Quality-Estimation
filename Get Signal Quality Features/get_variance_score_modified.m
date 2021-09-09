function [vSQI_autocorr,vSQI_audio,vSQI_pow] = get_variance_score_modified(truncated_autocorrelation,audio_data,pow)
%% Paper Information
% Improving the quality of point of care diagnostics with real-time machine learning in low literacy LMIC setting
% https://dl.acm.org/doi/pdf/10.1145/3209811.3209815 
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% https://www.tandfonline.com/doi/abs/10.1080/03091902.2016.1213902
%% Purpose
% Variance of signals of interest
%% INPUTS:
% truncated_autocorrelation: The truncated autocorrelation found in the
% function "get_autocorrelation.m"
% audio_data: 10 second chest sound recording
% pow: power
%% OUTPUTS:
% vSQI_autocorr: Variance of the autocorrelation signal
% vSQI_audio: variance of time domain signal 
% vSQI_pow: variance of power
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
vSQI_autocorr = var(truncated_autocorrelation);

vSQI_audio = var(audio_data);
vSQI_pow = var(pow);
end






