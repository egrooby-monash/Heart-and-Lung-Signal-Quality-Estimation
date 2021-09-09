function [psdx,f] = get_power(audio_data)
%% Paper Information
% Automatic signal quality index determination of radar-recorded heart sound signals using ensemble classification
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8731709  
%% Purpose
% Get power spectrum
%% INPUTS:
% audio_data: the audio data from a PCG recording
%% OUTPUTS:
% psdx=power spectral density
% f= frequency in Hz

NFFT=1028;
N = length(audio_data);
f = Fs*(0:(NFFT/2))/NFFT; 
xdft = fft(audio_data,NFFT);
xdft = xdft(1:N/2+1);
psdx = (1/N) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
        
