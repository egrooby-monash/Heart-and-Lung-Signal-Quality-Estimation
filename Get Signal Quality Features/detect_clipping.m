function clipping_per=detect_clipping(audio_data)
%% Paper Information
% Computerized lung sound screening for pediatric auscultation in noisy field environments
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7953509

%% Purpose
%Identified as consecutive time samples with constant maximum-value amplitude, up to a small 3% perturbation tolerance

%% Inputs
% audio_data: recording

%% Output
% clipping_per: percentage of samples with clipping present (%)

%% Method
% Identified as consecutive time samples with constant maximum-value amplitude, up to a small 3% perturbation tolerance
audio_data=abs(audio_data);
high_val=max(audio_data);
clipping_per=(sum(audio_data>0.97*high_val))/length(audio_data)*100;
end