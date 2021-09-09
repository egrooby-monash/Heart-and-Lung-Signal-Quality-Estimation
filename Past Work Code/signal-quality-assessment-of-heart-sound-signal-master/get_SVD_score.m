% function SVD_SQI = get_SVD_score(truncated_autocorrelation,Fs)
%
% A function to extract the SVD signal quality index from the autocorrelation of a heart sound recording.
% This index is derived from the paper:
% D. Kumar et al., ?Noise detection during heart sound recording using 
% periodicity signatures.,? Physiol. Meas., vol. 32, no. 5, pp. 599?618, 
% May 2011.

% and implemented in:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% truncated_autocorrelation: The truncated autocorrelation found in the
% function "get_autocorrelation.m"
% Fs: the sampling frequency of the autocorrelation
%
%% OUTPUTS:
% SVD_SQI: the ratio of second to first singular values of the SVD of 
% windows of the autocorrelation
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

function SVD_SQI = get_SVD_score(truncated_autocorrelation,Fs)

rho = [];

% Set limits on the size of the window. 
% A sample of (215/500)*Fs corresponds to a heartrate of 140 BPM
% (2)*Fs corresponds to 30 BPM:
start_window_size = (215/500)*Fs;
stop_window_size = (2)*Fs;

% Split the autocorrelation into stacked windows
% Find the SVD
% Find the squared ratio of the second to first singular values:
for T = start_window_size:5:stop_window_size
    Y = [];
    for window = 0: floor(length(truncated_autocorrelation)/T)-1
        Y = [Y;truncated_autocorrelation(window*T +1: T*(window+1))];
    end
    S = svd(Y');
    if(numel(S) == 1)
        rho = [rho,10];
    else
        rho = [rho, ((S(2))/(S(1)))^2];
    end
    Y = [];
end

% Then, return the minimum ratio found:
SVD_SQI = min(rho);

