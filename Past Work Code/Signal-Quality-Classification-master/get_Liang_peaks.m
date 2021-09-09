% function [new_peakpos] = get_Liang_peaks(audio_data,Fs,figures)
%
% Find the beats in a PCG signal using the method developed by Liang et al:
% H. Liang, S. Lukkarinen, and I. Hartimo, Heart sound segmentation algorithm based on heart
% sound envelogram, in Computers in Cardiology, vol. 24, Lund, Sweden, 1997, pp. 105108.
%
% The procedure is:
%
% 1. Extract the Shannon envelope of the PCG signal. This envelope is computed by initially normalising
% the PCG signal, by dividing the waveform by its absolute maximum value, limiting the
% amplitude to between [-1; 1]. Normalise the resulting time series by ensuring zero mean and unit standard deviation.
%
% 2. Locate the peaks in the Shannon envelope waveform, by locating the zero-crossings of the first
% derivative of the waveform, in the positive to negative direction. Exclude those peaks below a
% threshold, set to the 75th percentile value of the waveform.
%
% 3. Find the mean and standard deviation of the time interval between peaks. Set a low-limit and
% high-limit for the interval between beats, based on the mean and standard deviation, setting
% these to the mean +- two standard deviations.
%
% 4. If the interval between adjacent peaks is below the low-limit, there must be an extra, erroneous,
% peak detected. Therefore, select the peak with greater envelope amplitude and discard the other.
%
% 5. If the interval between adjacent peaks exceeds the high-limit, a peak has been missed. Therefore,
% reduce the threshold by one percentage point to find the lost peaks.
%
% 6. Repeat steps 4 to 5 until no peaks lie outside of the low- and high-limits, or until the threshold
% reaches the 20th percentile.
%
% 7. Locate the longest interval between adjacent peaks, marking this as a diastolic region. Find
% the mean diastolic and systolic intervals in both a forward and backward direction from this
% interval. Perform a second pass from the longest identified interval, marking intervals between
% peaks consecutively as either systole or diastole, provided the intervals were within a tolerance of
% the mean systolic and diastolic durations (20% and 40% of systolic and diastolic mean durations,
% respectively). Exclude peaks that violate these tolerances as being artefacts.
%
% Developed by David Springer for implementation in the paper:
% D. Springer et al., "Automated signal quality assessment of mobile
% phone-recorded heart sound signals," JMET, In preparation, 2016
%
%% INPUTS:
% audio_data: the PCG audio data
% Fs: the sampling frequency of the PCG data
% figures: optional boolean variable to dictate the display of figures
%
%% OUTPUTS:
% new_peakpos: the positions of the detected peaks (both S1 and S2) in
% samples
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

function [new_peakpos] = get_Liang_peaks(audio_data,Fs,figures)

if nargin <3,
    figures = 0;
end
percentile_value = 75;

%% Find the Shannon Envelope
envelope  = Shannon_Envelope(audio_data, Fs,figures);


%% Find the peaks (Simple zero-derivative finder)
[peakpos_all] = detect_peaks(envelope);


%% Set the threshold to the 50th percentile
peak_vals = envelope(peakpos_all);
threshold =  prctile(peak_vals,percentile_value);


%% Discard peaks below the threshold
peakpos = peakpos_all;
peakpos((peak_vals<threshold)) = [];


%% Find high- and low-limits
diffs = diff(peakpos);
mean_peak_diff = mean(diffs);
std_peak_diff = std(diffs);

low_limit = mean_peak_diff - 1*std_peak_diff;
high_limit = mean_peak_diff + 1*std_peak_diff;

low_limit = max([0.15*Fs, low_limit]);

% Removing peaks below low limit
while min(diff(peakpos)) < low_limit
    
    % Find position of min interval
    [~, ind] = min(diff(peakpos));
    
    % This interval is bounded by the peak at position ind, and that at
    % position ind+1.
    % So, if the peak at position ind is greater, remove the peak at
    % position ind+1, and vice versa
    if(envelope(peakpos(ind)) > envelope(peakpos(ind+1)))
        peakpos(ind+1) = [];
    else
        peakpos(ind) = [];
    end
end

%% Run the low-limit peak_pos again in order to get correct estimate of low- and high-limit:
diffs = diff(peakpos);
mean_peak_diff = mean(diffs);
std_peak_diff = std(diffs);

low_limit = mean_peak_diff - 2*std_peak_diff;
high_limit = mean_peak_diff + 2*std_peak_diff;
low_limit = max([0.2*Fs, low_limit]);


% Removing peaks below low limit
while min(diff(peakpos)) < low_limit
    
    % Find position of min interval
    [~, ind] = min(diff(peakpos));
    
    % This interval is bounded by the peak at position ind, and that at
    % position ind+1.
    % So, if the peak at position ind is greater, remove the peak at
    % position ind+1, and vice versa
    if(envelope(peakpos(ind)) > envelope(peakpos(ind+1)))
        peakpos(ind+1) = [];
    else
        peakpos(ind) = [];
    end
end


%% Get the number of peaks that lie outside of the high-limit:
sum_outside_max_time =  numel(find(diff(peakpos)>high_limit))>0;

% While there are more than 1 peaks above the max_time limit and the threshold is above the 20th percentile:
%% Decrease the threshold by one percentage point, find the peaks above the threshold, then remove the peaks below the low-limit:
while((sum_outside_max_time) && percentile_value >20)
    
    %Decrease the percentile value, and hence the treshold:
    percentile_value = percentile_value-1;
     
    peak_vals = envelope(peakpos_all);
    threshold =  prctile(peak_vals,percentile_value);
    
    % Remove the peaks below the threshold
    peakpos = peakpos_all;
    peakpos((peak_vals<threshold)) = [];
    
    
    
    % Removing peaks below low limit
    while min(diff(peakpos)) < low_limit
        
        % Find position of min interval
        [~, ind] = min(diff(peakpos));
        
        % This interval is bounded by the peak at position ind, and that at
        % position ind+1.
        % So, if the peak at position ind is greater, remove the peak at
        % position ind+1, and vice versa
        if(envelope(peakpos(ind)) > envelope(peakpos(ind+1)))
            peakpos(ind+1) = [];
        else
            peakpos(ind) = [];
        end
    end
    
    
        
    
    %Find the difference between peaks:
    c = diff(peakpos);
    %Find those differences that are above the max time:
    d = c>high_limit;
    % Then, find the number that are above this max_time limit:
    e = find(d);
    f = numel(e);
    
    %Binary variable, if the number is greater than 5:
    sum_outside_max_time =  f > 0;
end

a = envelope(peakpos)>threshold;
new_peakpos = peakpos(a);



%% Locate the longest interval between adjacent peaks:

[~, index_of_max_diff] = max(diff(peakpos));


%% Find mean systolic and diastolic interval times:
diffs = diff(peakpos);

%% if index_of_max_diff of max interval is even, then diatolic regions are even indices of diff array:
if mod(index_of_max_diff,2) == 0
    diastolic_intervals = diffs(2:2:length(diffs));
    systolic_intervals = diffs(1:2:length(diffs));
    
else
    diastolic_intervals = diffs(1:2:length(diffs));
    systolic_intervals = diffs(2:2:length(diffs));
end

mean_diastole = mean(diastolic_intervals);
mean_systole = mean(systolic_intervals);

sys_tolerance = 0.3;
dias_tolerance = 0.4;

min_diastole = round((1-dias_tolerance)*mean_diastole);
min_systole = round((1-sys_tolerance)*mean_systole);

%% Backward from longest interval duration:

% Find the peaks at the start and end of the interval to the left of the
% max_duration interval
peak_index1 = index_of_max_diff-1;
peak_index2 = index_of_max_diff;

systole = true;

while peak_index1 > 0
    
    % Find the duration between the peaks
    interval_duration = peakpos(peak_index2) - peakpos(peak_index1);
    
    violation = false;
    if(systole)
        if(interval_duration<min_systole)
            violation = true;
        end
    else
        if(interval_duration<min_diastole)
            violation = true;
        end
    end
    
    if(violation)
        % If the second peak is greater than the first, then remove the
        % first
        if(envelope(peakpos(peak_index2))>envelope(peakpos(peak_index1)))
            peakpos(peak_index1) = [];
        else
            peakpos(peak_index2) = [];
        end
        % Dont invert the systole variable, as still remains in systole
    else
        % No violation, so switch to next systole or diastole
        systole = ~systole;
        
    end
    peak_index2 = peak_index1;
    peak_index1 = peak_index1-1;
    
end


%% Forwards from longest interval duration:

peak_index1 = index_of_max_diff+1;
peak_index2 = index_of_max_diff+2;
systole = true;
while peak_index2 <= length(peakpos)
    
    % Find the duration between the peaks:
    interval_duration = peakpos(peak_index2) - peakpos(peak_index1);
    
    violation = false;
    if(systole)
        if(interval_duration<min_systole)
            violation = true;
        end
    else
        if(interval_duration<min_diastole)
            violation = true;
        end
    end
    
    
    
    if(violation)
        % If the second peak is greater than the first, then remove the
        % first
        if(envelope(peakpos(peak_index2))>envelope(peakpos(peak_index1)))
            peakpos(peak_index1) = [];
        else
            peakpos(peak_index2) = [];
        end
        % Dont invert the systole variable, as still remains in systole
    else
        % No violation, so switch to next systole or diastole
        systole = ~systole;
        
    end
    
    peak_index1 = peak_index2;
    peak_index2 = peak_index2+1;
    
end


if(figures)
    figure('Name','Liang peak detection');
    plot(audio_data);
    hold on;
    plot(new_peakpos, audio_data(new_peakpos), 'r*');
end

