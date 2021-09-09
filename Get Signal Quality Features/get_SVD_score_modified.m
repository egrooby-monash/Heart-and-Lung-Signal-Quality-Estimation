function [SVD_SQI,HR] = get_SVD_score_modified(truncated_autocorrelation,max_HR,min_HR,Fs)
%% Paper Information
% This index is derived from the paper:
% D. Kumar et al., ?Noise detection during heart sound recording using 
% periodicity signatures.,? Physiol. Meas., vol. 32, no. 5, pp. 599?618, 
% May 2011.
% https://www.researchgate.net/publication/51037539_Noise_detection_during_heart_sound_recording_using_periodicity_signatures
% and implemented in:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% https://www.tandfonline.com/doi/abs/10.1080/03091902.2016.1213902
%% INPUTS:
% truncated_autocorrelation: The truncated autocorrelation found in the
% function "get_autocorrelation.m"
% Fs: the sampling frequency of the autocorrelation
% min_HR, max_HR= maximum and minimum heart rate range 
%% OUTPUTS:
% SVD_SQI: the ratio of second to first singular values of the SVD of 
% windows of the autocorrelation
%% Purpose
% A function to extract the SVD signal quality index from the autocorrelation of a heart sound recording.
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


start_window_size = round((60/max_HR)*Fs);
stop_window_size = round((60/min_HR)*Fs);

% Split the autocorrelation into stacked windows
% Find the SVD
% Find the squared ratio of the second to first singular values:
rho=zeros(1,length(start_window_size:5:stop_window_size));
count=1;
for T = start_window_size:5:stop_window_size
    %Y = [];
    
    Y=zeros(floor(length(truncated_autocorrelation)/T),T); 
    for window = 0: floor(length(truncated_autocorrelation)/T)-1
        Y(window+1,:)=truncated_autocorrelation(window*T +1: T*(window+1));
    end
    
    S = svd(Y');
    if(numel(S) == 1)
        rho(count)=10;
    else
        rho(count)=((S(2))/(S(1)))^2;
    end
    count=count+1;
end

% Then, return the minimum ratio found:
[SVD_SQI,loc] = min(rho);
HR=Fs/(start_window_size+(loc-1)*5)*60;

