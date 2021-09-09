% function [vSQI] = get_variance_score(truncated_autocorrelation)
%
% A function to extract the sdr signal quality index from:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% % truncated_autocorrelation: The truncated autocorrelation found in the
% function "get_autocorrelation.m"
%
%% OUTPUTS:
% vSQI: Variance of the autocorrelation signal
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

function [vSQI] = get_variance_score(truncated_autocorrelation)

vSQI = var(truncated_autocorrelation);





