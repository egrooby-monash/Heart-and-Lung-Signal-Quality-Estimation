function [ powerband_x ] = powerband_segment( band, fn, x, labels_x, window, overlap)
%powerband_segment: Take a signal and return the powerband of all sections

%% INPUTS AND OUTPUTS
%  -- Inputs --
% band: ban din which the power will be taken
% fn: sampling frequency
% x: input signal
% labels_x: labels of the signal
% window: window taken for labelling
% overlap: overlap taken for labelling
% -- Outputs --
% powerband_x: matrix of the powerband of each NCS&CS in the signal [tag_section, powerband]

%% INITIALISATION

% -- Variables
N = length(x);
time_axis = (1:N)/fn;


%% LOCATION OF CS & NCS
% -- Finding the location of 'CS' or 'NCS'
locs_CS=find(labels_x==1); % Locations of CS
locs_NCS=find(labels_x==0); % Locations of NCS

% -- Start time of the labels (for each window)
start_time_NCS=locs_NCS*(window-window*overlap)-1;

% -- Start sample of the labels (for each window)
start_sample_NCS=start_time_NCS*fn+1;
label_duration=window*fn; % Number of samples in a window

if isempty(locs_CS)==0 % There is CS on the signal
    
    % -- Start time of the labels (for each window)
    start_time_CS=locs_CS*(window-window*overlap)-1;
    
    % -- Start sample of the labels (for each window)
    start_sample_CS=start_time_CS*fn+1;
    
end

%% POWERBAND

% -- Powerband NCS
for i=1:length(locs_NCS)
    section_n=locs_NCS(i); % Section number
    section=x(start_sample_NCS(i):start_sample_NCS(i)+label_duration);
    time_section=time_axis(start_sample_NCS(i):start_sample_NCS(i)+label_duration);
    p_NCS=bandpower(section, fn, band); % Power band
    powerband_x(section_n,:)=[0, p_NCS]; % Matrix shape: [tag_section_NCS, p_NCS]
end

% -- Powerband CS
if isempty(locs_CS)==0 % There is CS on the signal
    for j=1:length(locs_CS)
        section_n=locs_CS(j); % Section number
        section=x(start_sample_CS(j):start_sample_CS(j)+label_duration);
        time_section=time_axis(start_sample_CS(j):start_sample_CS(j)+label_duration);
        p_CS=bandpower(section, fn, band);
        powerband_x(section_n, :)=[1, p_CS]; % Matrix shape: [tag_section_CS, p_CS]
    end
end

end

