function [bSQI] = get_bSQI_modified(peak_pos_main,peak_pos_alt,Fs)
%% Paper Information
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% https://www.tandfonline.com/doi/abs/10.1080/03091902.2016.1213902
%% Purpose
% A function to extract the bSQI metric, based on the agreement between two
% peak detectors within a tolerance. 
%% Inputs
% peak_pos_main and peak_pos_alt are the locations of the S1 and S2 heart
% sounds
% Fs: sampling frequency
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
%% Find agreement between detectors:
if(isempty(peak_pos_main) || isempty(peak_pos_alt))
    F1_score  = 0;
else
    mean_factor=1;
    [F1_score] = Bxb_compare(peak_pos_main, peak_pos_alt, (0.1/mean_factor*Fs));
end

bSQI = F1_score;