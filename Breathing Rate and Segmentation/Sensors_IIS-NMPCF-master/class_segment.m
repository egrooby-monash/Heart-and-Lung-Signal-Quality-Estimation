function C = class_segment(Xsabs,Xsang,N,S,fs)
%
% Objetive:  this function implements the wheezing detection algorithm 
%            defined in reference "A constrained tonal semi-supervised 
%            Non-negative Matrix Factorization to classify presence/absence 
%            of wheezing in respiratory sounds". The classification between 
%            non-wheezing and wheezing segments is provided by this
%            function.
%
% Input: 
% - Xsabs:      Magnitude mixture spectrogram
% - Xsang:      Phase mixture spectrogram
% - N:          Hamming window sample length
% - S:          Overlap (between 0 and 1)
% - fs:         Sample rate (Hz)
%
% Output: 
% - C: Indicator to distinguish between non-wheezing (C=0) and wheezing segments (C=1).
%
%--------------------------------------------------------------------------
  

%--------------------------------------------------------------------------
%% Stage I: Estimation of the Spectral Band Of Interest
[fwfmin,fwfmax,bmin,bmax] = stageI(Xsabs,Xsang,N,S,fs);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%% Stage II: Wheezing/Normal breath Sound Separation 
Xw = stageII(fs,fwfmin,fwfmax,N,Xsabs);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%% Stage III: Wheezing presence/absence classification
C = stageIII(Xw,bmin,bmax);
%--------------------------------------------------------------------------
