function power_freq_centroid=get_power_freq_centroid(Pxx,F)
%% Paper information
%Heart sound anomaly and quality detection using ensemble of neural networks without segmentation
%https://ieeexplore.ieee.org/document/7868817
%% Purpose
% calculate centroid of power spectral density
%% Input
% Pxx: power spectral density
% F: frequencies
%% Output
% power_freq_centroid: psd frequency centroid
%% Method
power_freq_centroid = (sum(F.*(Pxx.^2)))/(sum(Pxx.^2));
end