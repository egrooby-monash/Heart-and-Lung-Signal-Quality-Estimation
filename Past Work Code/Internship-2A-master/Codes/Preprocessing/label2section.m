function [xss_section,time_axis_section] = label2section(xss, n_section, start_sample, label_duration, time_axis)
%label2signal: With the placement of the CS/NCS in the label_final matrix returned by LABELLING.m, this function gives the corresponding piece of signal.

%% INPUTS AND OUTPUTS

%  -- Inputs --
% xss: the input signal
% n_section: Section number
% start_sample: Start sample of the labels (for each window)
% label_duration: Number of samples in a window
% time_axis: Time axis of the xss

% -- Outputs --
% section: Segment on the signal
% time_axis_section: Time of the segment


% Beginning and end samples of a section
start_section=start_sample(n_section);
end_section=start_section+label_duration;

% Edge effects
if end_section>length(xss) % For the last section, if the window and overlap or not adjusted to xss length
    end_section=length(xss);
end

% Section on the signal (NCS/CS)
xss_section=xss(start_section:end_section);
time_axis_section=time_axis(start_section:end_section);

end

