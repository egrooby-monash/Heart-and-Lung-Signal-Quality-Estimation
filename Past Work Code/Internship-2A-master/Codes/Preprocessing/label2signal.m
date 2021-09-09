function [xss_section,time_axis_section] = label2signal(xss, fn, segment_sample, window_training, window_labelling)
%label2signal: This function gives the corresponding piece of signal(time/amplitude) corresponding to a certain position in the matrix final_label

%% INPUTS AND OUTPUTS

%  -- Inputs --
% xss: The input signal
% segment_sample: The segment described as number representing its location on final_label_xss vector
% window_training: Window used for the training
% window_labelling: Window used for labelling

% -- Outputs --
% xss_section: Amplitude of the signal in this time section
% time_axis_section: Time of the segment

%% INIIALISATION
% -- Signal parameters
N = length(xss);
time_axis = (1:N)/fn;

%% Beginning and end samples of a section
start_section=segment_sample(1)*window_labelling*fn; % Convert the segment in the vetoc label_final into a section in the vector xss
section_duration=window_training*fn;
end_section=start_section+section_duration;

% Section on the signal (NCS/CS)
xss_section=xss(start_section:end_section);
time_axis_section=time_axis(start_section:end_section);

end

