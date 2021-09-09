% function [shannon_envelope]  = Shannon_Envelope(input_signal, sampling_frequency, figures)
% This function finds the envelope of a signal, using the method of
% Shannon's envelope from:
%
% Choi et al, Comparison of envelope extraction algorithms for cardiac sound
% signal segmentation, Expert Systems with Applications, 2008
%
% Ricke et al, Automatic segmentation of heart sound signals using hidden
% markov models, Computers in Cardiology, 2005
%
% Liang et al, Heart sound segmentation algorithm based on heart sound
% envelogram, Computers in Cardiology, 1997
%
% Implemented in:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% Inputs:
% input_signal is the original signal
% samplingFrequency is the signal's sampling frequency
% figures - optional boolean variable to display a figure of both the original and
% normalised signal
%
%% Outputs:
% shannon_envelope is the envelope of the original signal
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

function shannon_envelope  = Shannon_Envelope(input_signal, sampling_frequency, figures)

if nargin <3,
    figures = 0;
end

%remove zeros from signal, as log operation has mathematical singularity at zero.
%Replace with the next smallest, non-zero value.
input_signal(input_signal == 0) = min(abs(input_signal((input_signal~=0))));


%Normalisation of the signal to between -1 and 1. This is due to the fact
%that the Shannon Energy is only defined over this region:
input_signal = input_signal./max(abs(input_signal));

shannon_envelope = zeros(size(input_signal));


start_point = 1;

%Step size and window size taken from Liang, 1997
step_size = round(sampling_frequency/100); %0.01s step size
end_point = round(step_size*2); %resulting in 0.02 second window

while(end_point < length(input_signal))
    
    square_signal = input_signal(start_point:end_point).^2;
    Es = (sum(square_signal.*log(square_signal)))*(-1/(step_size*2));
    shannon_envelope(start_point:end_point) = shannon_envelope(start_point:end_point)+Es;
    
    start_point = start_point+step_size;
    end_point = end_point + step_size;
end
shannon_envelope = shannon_envelope./2;

% Normalise the envelope:
shannon_envelope = (shannon_envelope - mean(shannon_envelope))/std(shannon_envelope);

if(figures)
    figure('Name', 'Shannon envelope for Liang peak detector');
    
    plot(normalise_signal(input_signal));
    hold on;
    plot(normalise_signal(shannon_envelope),'r');
    legend('Audio', 'Shannon envelope');
end