function [per_peak_window_original,per_peak_window_modified,per_peak_window_modified2]= acceptable_window_peaks_modified(PCG_resampled,qrs_pos,fs)
% used to be called determineZero
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946
%% Purpose 
% Calculate percentage of windows with acceptable peaks
%% Inputs
% PCG_resampled: audio signal resampled 
% qrs_pos: peak positions
% fs: sampling frequency
%% Outputs
% percentage of windows with acceptable peaks

%2200ms length moving windows with 25% overlap and checked how many peaks are detected in each window.
%Assigned 1 to each window containing 2-4 peaks and 0 in other cases.
window=2.2*fs;
overlap=0.25;
peacksDensity=[];

% we create the ECG index vector
offset=(1:round(overlap*window):size(PCG_resampled));
% we create a vector [0 1 2 ... window-1] - one window long
id1=(0:window-1)';
% The bsxfun function creates an index table - such that in the n-th column there are subsequent samples from the n-th signal window
idx=bsxfun(@plus, id1, offset);
IDX=[];
for j=1:size(idx,2)
    if(idx(end,j)<length(PCG_resampled))
        IDX=[IDX  idx(:,j)];
    end
end

for i=1:size(IDX,2)
    peacksDensity=[peacksDensity ; sum(ismember(qrs_pos,IDX(:,i)))];
end


peacksDensityBin=peacksDensity>=4 & peacksDensity<=8;
% Criterion of 65% of windows with score equal to 1
per_peak_window_original=sum(peacksDensityBin)/length(peacksDensityBin)*100;

%5 and 95 percentile heart rate Term: 120-185, 17+: 60-115
% 4 to 8 for 2200ms window is equivalent to 54.5455 to 109.0909
% For newborns should be 9-14  122.7273 to 190.9091
peacksDensityBin=peacksDensity>=9 & peacksDensity<=14;
per_peak_window_modified=sum(peacksDensityBin)/length(peacksDensityBin)*100;

%Also consider full possible range of heart rate which is max_HR=220; min_HR=70;
% For newborns should be 5-16 68.1818 to 218.1818
peacksDensityBin=peacksDensity>=5 & peacksDensity<=16;
per_peak_window_modified2=sum(peacksDensityBin)/length(peacksDensityBin)*100;
end
