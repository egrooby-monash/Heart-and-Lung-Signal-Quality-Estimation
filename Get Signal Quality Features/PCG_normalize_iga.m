function [PCG_normalized]=PCG_normalize_iga(PCG)
% used to be called checkingZero2_modified
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946

%% Inputs
% PCG signal
% Fs: sampling frequency

%% Output
% PCG_resampledNew: PCG signal that has been normalized after being broken
% up into 25 windows

%% Methods

len=length(PCG);
PCG_normalized=[];

%normalisation
windowN=25;
for j=1:windowN
    PCG_resampledtemp=PCG(1+floor(len/windowN)*(j-1):j*floor(len/windowN));
    if( (max(PCG_resampledtemp)-min(PCG_resampledtemp)) ~=0)
        PCG_normalized=[PCG_normalized ;...
            (PCG_resampledtemp-mean(PCG_resampledtemp))/(max(PCG_resampledtemp)-min(PCG_resampledtemp))];
    end
end

%[mdfint,PCG_resampledNew] =qrs_detect2_PCG_modified(PCG_resampledNew,fs);
%peaks=GetPeaks3_modified(mdfint,fs);
%qrs_pos=peaks;
end