function peaks=get_peaks_iga_original(sigIR,fs)
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
% peaks: detected peaks original  

flag=0;
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
        if( slopecount>=0.078*fs && abs(startV-sigIR(i))>1.5 && startB-lastBeatTime>0.2*fs)
            peaks=[peaks ; startB];
            lastBeatTime=startB; % +inxMaxSigLocal;
        end
        flag=0;
        slopecount=0;
    end
end
end
