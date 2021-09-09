function [] = display_CS_NCS_final(xss, xsc, fn, signal_n, label_annotated, window, overlap, label_learning, NCS_color, CS_color)
%display_CS_NCS_final: Display the rough signal, the one with the actual labels, the one with the predicted labels and finally the signal without CS.

%% INPUTS AND OUTPUTS
%  -- Inputs --
% xss: Signal without treatment on CS/NCS
% xsc: Signal after treatment en CS
% fn: Sampling frequency
% signal_n: Number of the signal
% label_annotated: Annotated labels of the signal bank
% window: Window used for labelling
% overlap: Overlap used for labelling
% label_learning: Predicted labels
% NCS_color: Color of NCS
% CS_color: Color of CS

%% INITIALISATION
% Signal with CS and NCS
N_xss = length(xss); 
time_axis_xss = (1:N_xss)/fn;

% Signal without CS
N_xsc = length(xsc);
time_axis_xsc = (1:N_xsc)/fn;

% Taking the labels corresponding to the signal
label_annotated=label_annotated(signal_n,:);
label_learning=label_learning(signal_n,:);



%% DISPLAY
figure,

%% TEMPORAL REPRESENTATION OF XSS
subplot(4,1,1);
plot(time_axis_xss, xss);
str1=sprintf('Temporal Representation of Signal %d',signal_n);
title(str1)
xlabel('Time [s]');
ylabel('Amplitude');

%% ANNOTATED CS AND NCS
subplot(4,1,2)
plot(time_axis_xss, xss, 'Color', NCS_color); hold on % The entire signal % ATTENTION COULEUR FAUSSE

% Finding the location of 'CS' and 'NCS'
CS_locs=find(label_annotated==1);
NCS_locs=find(label_annotated==0);

% Start time of the labels (for each window)
time_CS_start=CS_locs*(window-overlap)-1;
time_NCS_start=NCS_locs*(window-overlap)-1;

% Start sample of the labels (for each window)
sample_CS_start=time_CS_start*fn+1;
sample_NCS_start=time_NCS_start*fn+1;
label_duration=window*fn; % Number of samples in a window

% Sections NCS on the signal
for n_section=1:length(NCS_locs)
    [NCS_section,time_axis_section] = label2section(xss, n_section, sample_NCS_start, label_duration, time_axis_xss);
    p1=plot(time_axis_section, NCS_section, 'Color', NCS_color);
end

% Sections CS on the signal
for n_section=1:length(CS_locs)
    [CS_section,time_axis_section] = label2section(xss, n_section, sample_CS_start, label_duration, time_axis_xss);
    p2=plot(time_axis_section, CS_section, 'Color', CS_color);
end


%legend([p1 p2],'NCS', 'CS')
hold off
str2=sprintf('CS and NCS after Annotations on Signal %d',signal_n);
title(str2)
xlabel('Time [s]');
ylabel('Amplitude');

%% CS AND NCS AFTER LEARNING
subplot(4,1,3)
plot(time_axis_xss, xss, 'Color', NCS_color); hold on % The entire signal % ATTENTION COULEUR FAUSSE

% Finding the location of 'CS' and 'NCS'
CS_locs=find(label_learning==1);
NCS_locs=find(label_learning==0);

time_axis_section_NCS=time_axis_xss(NCS_locs);
NCS_section=xss(NCS_locs);
p1=plot(time_axis_section_NCS, NCS_section, 'Color', NCS_color);

time_axis_section_CS=time_axis_xss(CS_locs);
CS_section=xss(CS_locs);
p2=plot(time_axis_section_CS, CS_section, 'Color', CS_color);

% % Start time of the labels (for each window)
% time_CS_start=CS_locs*(window-overlap)-1;
% time_NCS_start=NCS_locs*(window-overlap)-1;
% 
% % Start sample of the labels (for each window)
% sample_CS_start=time_CS_start*fn+1;
% sample_NCS_start=time_NCS_start*fn+1;
% label_duration=window*fn; % Number of samples in a window
% 
% % Sections NCS on the signal
% for n_section=1:length(NCS_locs)
%     [NCS_section,time_axis_section] = label2section(xss, n_section, sample_NCS_start, label_duration, time_axis_xss);
%     p1=plot(time_axis_section, NCS_section, 'Color', NCS_color);
% end
% 
% % Sections CS on the signal
% for n_section=1:length(CS_locs)
%     [CS_section,time_axis_section] = label2section(xss, n_section, sample_CS_start, label_duration, time_axis_xss);
%     p2=plot(time_axis_section, CS_section, 'Color', CS_color);
% end


%legend([p1 p2],'NCS', 'CS')
hold off
str3=sprintf('CS and NCS after Learning on Signal %d',signal_n);
title(str3)
xlabel('Time [s]');
ylabel('Amplitude');


%% TEMPORAL REPRESENTATION OF XSC
subplot(4,1,4);
plot(time_axis_xsc, xsc);
str4=sprintf('Temporal Representation of Signal %d without CS',signal_n);
title(str4)
xlabel('Time [s]');
ylabel('Amplitude');

end

