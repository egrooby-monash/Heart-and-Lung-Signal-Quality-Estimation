function peaks=get_peaks_iga_modified(sigIR,fs,max_HR)
% used to be called GetPeaks3_modified
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946
%% Purpose
% get heart peaks
%% Inputs
% sigIR: signal envelope
% fs: sampling frequency
%% Output
% peaks: detected S1 and S2 peaks

flag=0;
max_maxHR=max_HR+20; 
meanS1=0.122;
meanS2=0.094;
stdS1S2=0.022;
minimum_slopecount=(min(meanS1,meanS2)-stdS1S2)/2;
tabpeak=zeros(3,1);
slopecount=0;
lastBeatTime=0;
peaks=[];
for i=1:length(sigIR)
    tabpeak(1)=tabpeak(2);
    tabpeak(2)=tabpeak(3);
    tabpeak(3)=sigIR(i);
    if(tabpeak(2)>tabpeak(1) && tabpeak(2)>tabpeak(3) && flag==0)
        flag=1;
        % add window_num * window length -1
        startB=i; 
        startV=tabpeak(2);
    end
    if(flag==1 && tabpeak(3)<tabpeak(2))
        slopecount=slopecount+1;
    end
    
    if(flag==1 && tabpeak(3)>=tabpeak(2))
        if( slopecount>=minimum_slopecount*fs && startB-lastBeatTime>(30/(max_maxHR))*fs)
            peaks=[peaks ; startB];
            lastBeatTime=startB; % +inxMaxSigLocal;
        end
        flag=0;
        slopecount=0;
    end
end