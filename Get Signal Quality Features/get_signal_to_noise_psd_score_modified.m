function [sdrSQI] = get_signal_to_noise_psd_score_modified(Pxx,F,signal_low,signal_high,noise_low)
%% Paper Information
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
% https://www.tandfonline.com/doi/abs/10.1080/03091902.2016.1213902
%% Purpose
% A function to extract the sdr signal quality inde
%% Inputs
% Pxx,F= power spectral density and associated frequencies
% signal_low, signal_high= frequency region for signal of interest
% noise_low= lower bound of noise frequency regions
%% Outputs
% sdrSQI: Spectral distribution ratio between the expected frequencies
% within the fundamental heart sounds and noise
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
% Look for ratio of frequencies where you expect to heart sounds
% (20-150 Hz) compared to those of just noise (upwards of 600 Hz).

%%%%% Need to do some research on this one %%%%%%%%
[~, pos1] = (min(abs(F-signal_low)));
[~, pos2] = (min(abs(F-signal_high)));
[~, pos3] = (min(abs(F-noise_low)));
Pxx = 10*log10(Pxx);
signal = sum(Pxx(pos1:pos2));
noise = sum(Pxx(pos3:end));
sdrSQI = signal/noise;

end

