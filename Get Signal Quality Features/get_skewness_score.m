function [skew] = get_skewness_score(audio_data)
%% Paper Information
% Automatic signal quality index determination of radar-recorded heart sound signals using ensemble classification
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8731709  

%% INPUTS:
% audio_data: the audio data from a PCG recording
%
%% OUTPUTS:
% skew: third central moment divided by the cub of its standard deviation
% Indicates asymmetry of the probability distribution
skew = skewness(audio_data);
end