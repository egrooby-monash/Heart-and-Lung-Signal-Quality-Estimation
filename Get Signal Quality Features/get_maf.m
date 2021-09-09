function pxx_smooth=get_maf(pxx)
%% Purpose
% Smooth power spectral density
%% Input
% pxx= power spectral density
%% Output
% Smoothed out power spectral den
%% Moving Average Filter (MAF)
pxx_smooth = smooth(pxx);
end