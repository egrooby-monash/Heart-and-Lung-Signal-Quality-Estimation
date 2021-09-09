% function [hSQI] = get_hjorth_activity_score(truncated_acf)
%
% A function to extract the Hjorth activity score from the autocorrelation of a
% heart sound signal. Developed as part of:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% 
%
%% INPUTS:
% truncated_acf: The truncated autocorrelation function of the heart sound
% signal. Derived in: get_autocorrelation.m
%
%% OUTPUTS:
% hSQI: Hjorth activity of the autocorrelation signal 
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

function [hSQI] = get_hjorth_activity_score(truncated_acf)

hSQI = (2*pi/length(truncated_acf))*sum(truncated_acf.^2);




