function [max_pow,max_freq,ratio_max] = get_dominant_frequency_features(psdx,f)
%% Paper Information
% Automatic signal quality index determination of radar-recorded heart sound signals using ensemble classification
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8731709  
%% Purpose
% Get dominant frequency features
%% INPUTS:
% psdx=power spectral density
% f= frequency in Hz
%% OUTPUTS:
% max_freq= Frequency at maximum power
% max_pow= Maximum power
% ratio_max= Ratio of maximum power with total power

%% Method
[max_pow,loc]=max(psdx);
max_freq=f(loc);
ratio_max=max_pow/sum(psdx);
        
