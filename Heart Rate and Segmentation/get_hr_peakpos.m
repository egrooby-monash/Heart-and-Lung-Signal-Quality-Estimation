function [peak_pos_all,peak_pos_s1,peak_pos_s2]=get_hr_peakpos(qt,signal_length,Fs_seg,Fs)
%% Paper Information
% Automated signal quality assessment of mobile phone-recorded heart sound signals
% https://www.tandfonline.com/doi/pdf/10.1080/03091902.2016.1213902?needAccess=true
%% Purpose
% get S1 and S2 peak positions
%% Inputs
% qt= segmented heart sound into indices of 1-4 indicates s1, systole, s2
% and diastole
% signel_length= length of signal
% Fs_seg= sampling frequency used for heart segmentation
% Fs= desired sampling frequency
%% Outpot
% peak_pos_all= all peak positions
% peak_pos_s1= s1 peak positions 
% peak_pos_2= s2 peak positions

%% Find mid-position of qt segments
%Split into s1 sounds, s2 sounds and FHSounds
%S1 sounds
s1_segments = (qt ==1);
s2_segments = (qt ==3);

end_points_s1 = find(diff(s1_segments));
if(mod(length(end_points_s1),2))
    end_points_s1 = [end_points_s1, signal_length];
end


end_points_s2 = find(diff(s2_segments));
if(mod(length(end_points_s2),2))
    
    end_points_s2 = [end_points_s2, signal_length];
end

mid_points_s2 = zeros(1,length(end_points_s2)/2);
for i =1:2:length(end_points_s2)
    mid_points_s2((i+1)/2) = round((end_points_s2(i)+end_points_s2(i+1))/2);
end


mid_points_s1 = zeros(1,length(end_points_s1)/2);
for i =1:2:length(end_points_s1)
    mid_points_s1((i+1)/2) = round((end_points_s1(i)+end_points_s1(i+1))/2);
end

%% Convert the peak positions from samples at the lower audio_segmentation_Fs to the Fs:
peak_pos_all = round(((sort([mid_points_s1 mid_points_s2]))./Fs_seg).*Fs);
peak_pos_s1 = round(((sort(mid_points_s1))./Fs_seg).*Fs);
peak_pos_s2 = round(((sort(mid_points_s2))./Fs_seg).*Fs);
end

