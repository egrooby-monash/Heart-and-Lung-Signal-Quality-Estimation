% function [sdrSQI] = get_signal_to_noise_psd_score(audio_data, Fs)
%
% A function to extract the sdr signal quality index from:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% audio_data: The audio data of the heart sound recording
% Fs: the sampling frequency of the audio recording. This should be greater
% than 2000 Hz, as this function finds the ratio of the power between
% 20-150 Hz and the power above 600 Hz. In order to have any power above
% 600 Hz, the sampling frequency must be greater than 1200 Hz. 
%
%% OUTPUTS:
% sdrSQI: Spectral distribution ratio between the expected frequencies
% within the fundamental heart sounds and noise
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

function [sdrSQI] = get_signal_to_noise_psd_score(audio_data,Fs)

if Fs < 2000
    warning('The sampling frequency in sdrSQI is low. This may result in innacutate calculation of the signal quality index');
end


%Get the PSD using Welch's method
%Set window size to 2 seconds, to contain at least one heart cycle
%Set the overlap to 50%
%Set the number of FFT points to roughly the Fsuency, so that we get about a 1 Hz resolution (which should be acceptable, as we are looking for difference in the spectrum far larger than 1 Hz)

% Find the next greatest power of 2 from the sampling frequency
p = nextpow2(Fs*2);
window_size = 2^p;


[Pxx,F] = pwelch(audio_data,window_size,window_size/2,window_size,Fs);

% Look for ratio of frequencies where you expect to heart heart sounds
% (20-150 Hz) compared to those of just noise (upwards of 600 Hz).

[~, pos1] = (min(abs(F-20)));
[~, pos2] = (min(abs(F-150)));

[~, pos3] = (min(abs(F-(600))));

Pxx = 10*log10(Pxx);

signal = sum(Pxx(pos1:pos2));

noise = sum(Pxx(pos3:end));

sdrSQI = signal/noise;



