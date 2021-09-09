function [per_peak_window_original,per_peak_window_modified,per_peak_window_modified2]= acceptable_window_peaks_lung(PCG_resampled,qrs_pos,fs)
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
window=4*fs;
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

%5 and 95 percentile resspiratory rate Term: 25-60
% 1 and 99 percentile 25-66
peacksDensityBin=peacksDensity>=1 & peacksDensity<=4;
per_peak_window_original=sum(peacksDensityBin)/length(peacksDensityBin)*100;

% Full range 15-80
peacksDensityBin=peacksDensity>=1 & peacksDensity<=5;
per_peak_window_modified=sum(peacksDensityBin)/length(peacksDensityBin)*100;

peacksDensityBin=peacksDensity>=2 & peacksDensity<=4;
per_peak_window_modified2=sum(peacksDensityBin)/length(peacksDensityBin)*100;
end
