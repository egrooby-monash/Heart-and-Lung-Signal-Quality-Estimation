function [Hn] = get_spectral_entropy(S)
%% Paper Information
% Automatic signal quality index determination of radar-recorded heart sound signals using ensemble classification
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8731709  

%% INPUTS:
% audio_data: the audio data from a PCG recording
%
%% OUTPUTS:
% Hn= normalised Shannon entropy
%% Method
%NFFT=1028;
%spec=fft(audio_data,NFFT);
%S=abs(spec(1:NFFT/2+1)).^2;
N=length(S);
p=S/sum(S);
Hn=-(sum(p.*log(p)))/log2(N);