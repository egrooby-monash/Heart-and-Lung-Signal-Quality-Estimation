function [] = display_NCS_CS_annotations(signal_n,label_final, window, overlap)
%NCS_CS_LABEL: Display the annotated labels CS and NCS of a signal

%% INPUTS AND OUTPUTS
%  -- Inputs --
% signal_n: Number of the signal
% label_final: Annotated labels of the signal bank
% window: Window used for labelling
% overlap: Overlap used for labelling


%% Reading the signal
signal_name=sprintf('%d.mp3',signal_n);
path=pwd;
[x1,Fs]= audioread([path,'\..\Data\Learning_Database\',signal_name]); % read current file

%% Resampling to 4000 Hz
xs1=resample(x1,4000,Fs);
fn=4000;

%% Shorten the signals to 60s
time_sample=60;
xss1=xs1(1:time_sample*fn,1);

%% Parameters
N = length(xss1);
time_axis = (1:N)/fn;

NCS_color=[0 0.6 0];
CS_color=[0.8 0 0];

%% Display
figure,

% -- Temporal representation of the signal
subplot(2,1,1);
plot(time_axis, xss1);
str1=sprintf('Temporal Representation of Signal %d',signal_n);
title(str1)
xlabel('Time [s]');
ylabel('Amplitude');

% -- Temporal representation of the signal with NCS and CS
subplot(2,1,2)
plot(time_axis, xss1, 'Color', NCS_color); hold on % The entire signal % ATTENTION COULEUR FAUSSE

% Finding the location of 'CS' and 'NCS'
CS_locs=find(label_final(signal_n,:)==1);
NCS_locs=find(label_final(signal_n,:)==0);

% Start time of the labels (for each window)
time_CS_start=CS_locs*(window-overlap)-1;
time_NCS_start=NCS_locs*(window-overlap)-1;

% Start sample of the labels (for each window)
sample_CS_start=time_CS_start*fn+1;
sample_NCS_start=time_NCS_start*fn+1;
label_duration=window*fn; % Number of samples in a window

% Sections NCS on the signal
for n_section=1:length(NCS_locs)
    [NCS_section,time_axis_section] = label2section(xss1, n_section, sample_NCS_start, label_duration, time_axis);
    p1=plot(time_axis_section, NCS_section, 'Color', NCS_color);
end

% Sections CS on the signal
for n_section=1:length(CS_locs)
    [CS_section,time_axis_section] = label2section(xss1, n_section, sample_CS_start, label_duration, time_axis);
    p2=plot(time_axis_section, CS_section, 'Color', CS_color);
end


legend([p1 p2],'NCS', 'CS')
hold off
str2=sprintf('CS and NCS after Annotations on Signal %d',signal_n);
title(str2)
xlabel('Time [s]');
ylabel('Amplitude');

end

