% function [sample_entropy] = get_entropy(truncated_autocorrelation, M, r)
%
% A function to extract the sample entropy of the autocorrelation of a
% heart sound signal. Developed as part of:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% 
% This function requires the Matlab implementation of the "sampen.m" function from physionet:
% https://physionet.org/physiotools/sampen/
%
%% INPUTS:
% truncated_autocorrelation: The truncated autocorrelation found in the
% function "get_autocorrelation.m"
% M: maximum template length
% r: matching threshold
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

function [sample_entropy] = get_entropy(truncated_autocorrelation, M, r)

% Changed from m to M = m+1, as the physionet sampen function needs the maximum dimenstion M
M = M+1;
temp = sampen(truncated_autocorrelation,M,r,0,0,0);

% Again, changed from m to M below:
[sample_entropy]= temp(M);


