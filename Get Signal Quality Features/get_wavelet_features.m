function [Ed] = get_wavelet_features(audio_data)
%% Paper Information
% Improving the quality of point of care diagnostics with real-time machine learning in low literacy LMIC settings
% https://dl.acm.org/doi/pdf/10.1145/3209811.3209815 
%% Purpose
% Get wavelet features

% Wavelet features Using these frequency ranges as reference, the
% DUS recordings were de- composed into 4 levels using the Discrete
% Wavelet multi-resolution analysis (Table 2). The reverse
% biorthogonal wavelet rbio3.9 was selected as the mother wavelet
% since it was able to correctly classify more good and poor quality
% segments than other mother wavelets for DUS recordings made with
% the same transducer used in this study [36, 38].
% As a feature, the percentage of energy content at each decompo- sition level was computed as follows:

%% INPUTS:
% audio_data: the audio data from a PCG recording
%
%% OUTPUTS:
% Ed= 8 feautes reprenting the precentage of energy content at each
% decomposition level

wname='rbio3.9';
N=4;
%Discrete stationary wavelet transform 1-D
% correcting the length of signal
fin=size(audio_data,1)-mod(size(audio_data,1),2^N);
data_e1=audio_data(1:fin);
[SWA,SWD]=swt(data_e1,N,wname);
SWC= real([SWA ; SWD]);
Et=sum(sum(SWC.^2));
Ed=100*sum(SWC'.^2)/Et;
