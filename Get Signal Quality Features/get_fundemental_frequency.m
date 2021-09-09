function [overall_f0,min_f0,max_f0,mean_f0,median_f0,mode_f0,var_f0,cry_f0] = get_fundemental_frequency(audio_data,Fs)
%% Paper Information
% Improving the quality of point of care diagnostics with real-time machine learning in low literacy LMIC settings
% https://dl.acm.org/doi/pdf/10.1145/3209811.3209815
%% Purpose
% Get fundamental frequency features

%% INPUTS:
% audio_data: the audio data from a PCG recording
%
%% OUTPUTS:
% fundamental frequency features

%% Method
%25ms window Estimate fundamental frequency hamming window and a sliding window
%of 10 ms (15 ms overlap), which are the most common window?s
%length for speech recognition [13]. For each frame, the F 0 was
%estimated by taking the inverse of the quefrency within 50 and
%1000 Hz with the highest peak. After the F 0 was estimated for
%each possible window of the segment, all the values were
%distributed in a histogram, calculating the number of bins from
%the average provided by Sturgis? [40] and Rice?s [16] rules. The F
%0 of a segment was defined as the center of the histogram bin with
%the highest absolute frequency.
f0 = pitch(audio_data,Fs,'WindowLength',round(0.025*Fs),...
    'OverlapLength',round(0.015*Fs),'Range',[50 1000],'Method','CEP');

min_f0=min(f0);
max_f0=max(f0);
mean_f0=mean(f0);
median_f0=median(f0);
mode_f0=mode(f0);
var_f0=var(f0);

[N,edges] = histcounts(f0);
[~,loc]=max(N);
overall_f0=mean(edges(loc:loc+1));

% Cry detection
% Computerized lung sound screening for pediatric auscultation in noisy field environments
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7953509
% Frames with an extracted pitch lower than 250 Hz were immediately rejected.
cry_f0=sum(f0<250)/length(f0);
end
