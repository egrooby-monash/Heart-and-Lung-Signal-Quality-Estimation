% function [truncated_autocorrelation untruncated_autocorrelation] = get_autocorrelation(audio_data,Fs,figures)
%
% A function to extract the truncated and untrancated autocorrelation of the heart sound recordings.
%
% This function is based on the paper:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% audio_data: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording
% figures: (optional) boolean variable for displaying figures
%
%% OUTPUTS:
% truncated_autocorrelation: the autocorrelation function, truncated from
% the first minimum after the first spike (due to overlap at zero lag) to 5
% seconds later
% untruncated_autocorrelation: the original autocorrelation function
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

function [truncated_autocorrelation, untruncated_autocorrelation] = get_autocorrelation(audio_data, Fs,figures)

if nargin <3
    figures = false;
end

% Find the envelope of the audio signal using the Hilbert transform
audio_env = abs(hilbert(audio_data));

% Find the autocorrelation:
acf = autocorr(audio_env,length(audio_env)-1, [] , 2);


% Low-pass filter the autocorrelation:
acf = butterworth_low_pass_filter(acf',1,15,Fs, false);
% acf = butterworth_high_pass_filter(acf,2,0.2,Fs);

% Find minimum after first major peak, to minimum at least 5 seconds later:

% point-to-point gradient
siggrad = diff(acf);

% changes in gradient = zero crossings of siggrad
% p where crossdirs = -1, t where crossdirs = 1
[crosspts, crossdirs] = zerocrossings(siggrad);
first_point = crosspts(1);
counter = 1;

% Find the first turning point in the gradient point, with a minimum of 0.2
% seconds:
while (first_point < 0.2*Fs)
    counter = counter + 1;
    first_point = crosspts(counter);
end

% Find the turning point 5 seconds later:
min_value_next_point = crosspts(1)+5*(Fs);
[~, place] = min(abs((crosspts - min_value_next_point)));
second_point = crosspts(place);

while(crossdirs(place) == -1)
    place = place +1;
    second_point = crosspts(place);
end

untruncated_autocorrelation = acf;
truncated_autocorrelation = acf(first_point:second_point);


if (figures)
    t = (1:length(untruncated_autocorrelation))./Fs;
    t_truncated = (first_point:second_point)./Fs;
    figure('Name', 'Autocorrelations');
    plot(t, untruncated_autocorrelation);
    hold on;
    plot(t_truncated, truncated_autocorrelation,'r');
    xlabel('Time');
    ylabel('Normalised amplitude');
    legend('Untrancated autocorrelation', 'Truncated autocorrelation');
end



