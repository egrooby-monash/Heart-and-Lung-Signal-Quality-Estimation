function [X_ncs_final, label_training, length_labels] = crying_removing(folder_path, time_sample, fn, threshold, band, window_training, overlap_training)
%CRYING_REMOVING:  Remove the crying sections thanks to a threshold on powerband

%% INPUTS AND OUTPUTS
%  -- Inputs --
% X: Matrix with signals
% fn: Sampling frequency
% threshold: Power band threshold found to distinguish CS from NCS
% band: Frequency band of interest for doing the power ratio and distinguish CS from NCS
% window_training: Window used for training
% window_annotated: Window used for annotated
% -- Outputs --
% X_ncs_final: Matrix with non-crying signals
% label_training: Label found by training (useful in display_CS_NCS_final.m, figure 3)

%% INITIALISATION
window=window_training*fn;
overlap=overlap_training*fn;

%% READING FILES IN THE DATABASE

%% -- Samples' names initialisation
dinfo = dir(folder_path);
names_cell1 = {dinfo.name};

% Choose a valid file name
j=0;
for i=1:size(names_cell1,2)
    if length(names_cell1{i})>2
        j=j+1;
        names_cell{j}=names_cell1{i};
    end
end
lengthTot=j;

%% -- Initialisation storage matrix
X_ncs=zeros(lengthTot, time_sample*fn);

%% -- Reading
for i=1:lengthTot
    
    % Name of the sample
    tempName=names_cell{i};
       % tempName='106.mp3';
    disp('READ - Database');
    disp(tempName);
   
    
    % Get the number of the recording by removing the '.mp3'
    strMP3 = sprintf('%s',tempName);
    ind=strfind(strMP3,'.');
    signal_n = str2num(strMP3(1:ind-1));
    
    % Reading the sample
    sample_path=sprintf('%s\\%s', folder_path, tempName);
    [x,Fs]= audioread(sample_path); % read current file
    
    % Resampling to 4000 Hz
    xs=resample(x,fn,Fs);
    
    % Shorten the signals to 60s if longer
    if length(xs)>time_sample*fn
        xss=xs(1:time_sample*fn,1);
    else 
        xss=xs;
    end
    N=length(xss);
    NN(signal_n)=N/fn;
    
    %% SECTIONS
    % Initialisation
    pos=1;
    section_set=[];
    labels=[];
    
    % All sections except the last one (overlap between sections)
    while pos<=(N-window+1)
        section=xss(pos:pos+window-1);
        pos=pos+window-overlap;
        section_set=[section_set, section];
    end
    
    % Last section
    last_section=xss(pos:end); % Can have a different size
    
    %% LABEL THANKS TO POWERBAND
    label_section=bandpower(section_set, fn, band)>threshold; % For all sections except the last one
    label_section_last=bandpower(last_section, fn, band)>threshold; % Last section
    
    
    %% LABELS CORESPONDING TO SIGNAL LENGTH (overlap taken into account)   
    % -- First section
    first_section=xss(1:window-overlap);
    labels(1:length(first_section))=repelem(label_section(1),length(first_section));
    pos=length(first_section)+1;
    
    % -- Other windows
    for i=2:length(label_section)
        l1=label_section(i-1);
        l2=label_section(i);
        
        % Overlap with priority to NCS
        if (l1==0 || l2==0) % 0=priority NCS, 1=priority CS
            labels(pos: pos+overlap-1)=zeros(1,overlap); % 0: NCS
        else
            labels(pos: pos+overlap-1)=ones(1,overlap); % 1: CS
        end
        pos=pos+overlap;
        
        % Window without overlap
        labels(pos:pos+window-2*overlap-1)=repelem(l2,window-2*overlap);
        pos=pos+window-2*overlap;
    end
    
    % -- Last window
    
    % Last overlap
    if (label_section(end)==0 || label_section_last==0)
        labels(pos: pos+overlap-1)=zeros(1,overlap);
    else
        labels(pos: pos+overlap-1)=ones(1,overlap);
    end
    pos=pos+overlap;
    
    % Last section without overlap
    if length(last_section)~=1 % If length=1, it means that there is only overlap (already taken into account)
        labels(pos: pos+length(last_section)-overlap-1) = repelem(label_section_last, length(last_section)-overlap);
    end
    
    
    %% CS REMOVING
    NCS=1-labels;
    xsc=xss((xss.*NCS')~=0); % Signal without CS
    
    
    %% STORAGE
    % Signals without CSs
    X_ncs(signal_n, 1:length(xsc))=xsc; % If CSs were removed, X_ncs contains 0.
    
    % Labels used in display_CS_NCS_final
    length_labels(signal_n)=length(labels); 
    if length(labels)<time_sample*fn
        labels=[labels, ones(1,time_sample*fn-length(labels))*2]; % 2 padding
    end
    label_training(signal_n, :)=labels;
    
    %% LENGTH
    length_xsc(signal_n)=length(xsc);
end


%% SHORTEN SAMPLES WITH MAX(MINIMUM LENGTH;10s)
length_acceptable=10*fn;

% Statistical study on lengths
length_xsc_time=length_xsc*60/length(xss);
mean_length=mean(length_xsc_time);
median_length=median(length_xsc_time);
p25_length=prctile(length_xsc_time,25);
p75_length=prctile(length_xsc_time,75);

% Find the minimum length
min_length=min(length_xsc);
if min_length<length_acceptable
    X_ncs(length_xsc<length_acceptable, :)=zeros(sum(length_xsc<length_acceptable), size(X_ncs,2));
    min_length=min(length_xsc(length_xsc>=length_acceptable));
end

part1=floor(min_length/2);
part2=min_length-part1;

% Shorten for each signal
X_ncs_final=zeros(lengthTot, min_length);
for signal_n=1:size(X_ncs,1)
    if length_xsc(signal_n)>=length_acceptable
        xsc1=X_ncs(signal_n, 1:length_xsc(signal_n)); % Signal with only NCS
        if length(xsc1)>min_length
            mid=floor(length(xsc1)/2);
            xsc_shorten=xsc1(mid-part1:mid+part2-1);
        else
            xsc_shorten=xsc1;
        end
    else
        xsc_shorten=zeros(1, min_length);
    end
    X_ncs_final(signal_n, :)=xsc_shorten;
end

% Display
length_time=length_xsc./fn;
figure,
hax=axes;
x_axe=get(hax,'XLim');
plot(1:length(length_time), length_time, '*'); hold on
%plot(1:length(length_time),ones(1,length(length_time))*10 , '--', 'Color', 'r');
line([1,length(length_time)],[length_acceptable/fn,length_acceptable/fn], 'Color',[0.8 0 0], 'LineWidth', 2);
hold off
title('Duration of Samples after Cry Removal (CS priority)')
xlabel('Samples')
ylabel('Duration [s]')

end
