function E=get_spectral_energy(x,fs)
%% Paper Information
% Wheezing sound separation based on Informed Inter-Segment Non-negative Matrix Partial Co-Factorization
% https://www.mdpi.com/710690
% Automatic Multi-Level In-Exhale Segmentation and Enhanced Generalized S-Transform for wheezing detection
% https://www.sciencedirect.com/science/article/pii/S0169260719305048 
%% Purpose
% get spectral energy envelope representation of lung sound 
%% Inputs
% x= lung sound
% fs= sampling frequency 
%% Output
% E= spectral energy

% TF representation
%12.5ms
N=12.5/1000*fs; 
%75% overlap %changed to 80% overlap due to rounding purposes
S=0.20;
Hop_samples=round(S*N); 
window=hamming(N); 
noverlap=N-Hop_samples; 
nfft=2*N; 
% Magnitude spectrogram X
[Xcomplex,~,~]=sg(x,nfft,fs,window,noverlap); 
Xabs=abs(Xcomplex);

% spectral energy
E=sum(Xabs,1);
E = resample(E, fs, fs/(Hop_samples));
end