function [ CS, NCS ] = CS_NCS_pure_window(xss, fn, signal_n, label_final_xss, window_training, error, window_labelling)
%CS_NCS_pure_window: Search pure window of CS and NCS, and return them.

%% INPUTS AND OUTPUTS
%  -- Inputs --
% xss: input signal
% signal_n: Signal number (ID)
% fn: Sampling frequency
% label_final: Annotated labels (1=CS; 0=NCS)
% window_training: Window used for training
% overlap_training: Overlap used for training
% window_labelling: Window used for labelling
% -- Outputs --
% CS_pure: Pure crying segments
% NCS_pure: Pure non-crying segments
% epsilon: permissible error on segments non entirely pure
% CS_window: CS with 'epsilon' of NCS at worse
% NCS_window: NCS with 'epsilon' of CS at worse

%% INIIALISATION
% -- Signal parameters
N = length(xss);
time_axis = (1:N)/fn;

% -- Segment parameters
window_duration=window_training/window_labelling; % Number of sample in a window
start_segment=1; % First sample of the segment
segment_sample=start_segment:start_segment+window_duration-1; % Segment of interest
segment_label=label_final_xss(segment_sample);

% -- Initialisation of counters
c_CS_pure=0; c_NCS_pure=0; % Counter for CS and NCS pure respectively
c_CS_epsi=0; c_NCS_epsi=0; % Counter for CS and NCS not entirely pure respectively

% -- Initialisation of matrix (in case not assigned)
CS_pure=[]; NCS_pure=[]; CS_epsi=[]; NCS_epsi=[];

% -- Color
NCS_color=[0 0.6 0];
CS_color=[0.8 0 0];
NCS_epsi_color=[0 0.1 0];
CS_epsi_color=[0.4 0 0];

% figure,
% p0=plot(time_axis, xss, 'Color', 'black');
% hold on

% -- For each segment in the signal labelled
while segment_sample(end)<length(label_final_xss)-window_duration
    
    purity_threshold=round(1-error, 2);
    purity_CS=round(sum(segment_label==1)/length(segment_label), 2);
    purity_NCS=round(sum(segment_label==0)/length(segment_label), 2); 
    
    
    %% PURE SEGMENT
    % -- CS
    if sum(segment_label)==window_duration % Only 1 in the segment => Pure CS
        c_CS_pure=c_CS_pure+1; % Counter
        [CS_pure_segment, time_axis_CS_pure] = label2signal(xss, fn, segment_sample, window_training, window_labelling); % Find the signal corresponding to this segment
        CS_pure(c_CS_pure, :)=CS_pure_segment; % Store the pure segment in a matrix
        start_segment=segment_sample(end) +1; % Update the beginning of a new segment
        %p1=plot(time_axis_CS_pure, CS_pure_segment, 'Color', CS_color);
        
        % -- NCS
    elseif sum(segment_label)==0 % Only 0 in the window => Pure NCS
        c_NCS_pure=c_NCS_pure+1; % Counter
        [NCS_pure_segment, time_axis_NCS_pure] = label2signal(xss, fn, segment_sample, window_training, window_labelling); % Find the signal corresponding to this segment
        NCS_pure(c_NCS_pure, :)=NCS_pure_segment; % Store the pure segment in a matrix
        start_segment=segment_sample(end) +1; % Update the beginning of a new segment
        %p2=plot(time_axis_NCS_pure, NCS_pure_segment, 'Color', NCS_color);
        
        
    %% MAINLY PURE SEGMENT

    % -- Mainly CS
    elseif purity_CS >= purity_threshold % Mainly pure CS (maximum epsilon error acceptable)
        c_CS_epsi=c_CS_epsi+1; % Counter
        [CS_epsi_segment, time_axis_CS_epsi] = label2signal(xss, fn, segment_sample, window_training, window_labelling); % Find the signal corresponding to this segment
        CS_epsi(c_CS_epsi, :)=CS_epsi_segment; % Store the pure segment in a matrix
        start_segment=segment_sample(end) +1; % Update the beginning of a new segment
        %p3=plot(time_axis_CS_epsi, CS_epsi_segment, 'Color', CS_epsi_color);
        
        % -- Mainly NCS
    elseif purity_NCS >= purity_threshold % Mainly pure NCS (maximum epsilon error acceptable)
        c_NCS_epsi=c_NCS_epsi+1; % Counter
        [NCS_epsi_segment, time_axis_NCS_epsi] = label2signal(xss, fn, segment_sample, window_training, window_labelling); % Find the signal corresponding to this segment
        NCS_epsi(c_NCS_epsi, :)=NCS_epsi_segment; % Store the pure segment in a matrix
        start_segment=segment_sample(end) +1; % Update the beginning of a new segment
        %p4=plot(time_axis_NCS_epsi, NCS_epsi_segment, 'Color', NCS_epsi_color);
      
      %% NON-PURE SEGMENT
    else
        j=0;
        while segment_label(end-j)==1
            j=j+1;
        end 
        start_segment=segment_sample(end)-j+1; % Update the beginning of a new segment
    end
    
    %% UPDATE
    segment_sample=start_segment:start_segment+window_duration -1;
    segment_label=label_final_xss(segment_sample);
    
end
% hold off;
% legend([p0,p1, p2, p3, p4], 'Non-pure','Pure CS', 'Pure NCS', 'Mainly CS', 'Mainly NCS'); 
% str=sprintf('Representation of the purity level on %ds window (Signal %d.mp3)', window_training, signal_n);
% title(str);

CS=[CS_pure; CS_epsi]; 
NCS=[NCS_pure; NCS_epsi]; 
end

