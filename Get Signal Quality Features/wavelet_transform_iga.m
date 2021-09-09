function [PCG_Hi_Hi] = wavelet_transform_iga(PCG,fs)
% originally called falkowyFeature
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946

%% Inputs
% PCG signal
% Fs: sampling frequency

%% Output
% data processing and output:
% A) calculation of the wavelet transform with the nucleus of Daubechies-2

%% Method
PCG = butterworth_high_pass_filter(PCG,2,20,fs);
% the beginning of the wavelet transform
falka = dbwavf('db2');
falkaODW =-( (-1).^(1:length(falka)) ).*falka;
PCG_Lo = conv(PCG,falka);
% cut off the tip
PCG_Lo = PCG_Lo(1:end-length(falka)+1);
% downlample
PCG_Lo = PCG_Lo(1:2:end);
PCG_Hi_Hi = conv(PCG_Lo(1:end-length(falka)+1),falkaODW);
% We get rid of the basic words from the plexus
PCG_Hi_Hi = PCG_Hi_Hi(1:end-length(falka)+1);

PCG_Hi_Hi = interp(PCG_Hi_Hi,2);
end
