function reducedTransitCounter=get_zcr_2(PCG_resampled, qrs_pos)
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946

%% Inputs
% Resampled PCG signal
% peak positions

%% Outputs
% reducedTransitCounter: number of times crossing 0.58 percentile value of
% peak

%% Method
% Value of the 0.58 percentile of signal and the number of detected peaks
% was extracted from the whole number of intersections
%find maximum peak value near the peack detected point
qrs_val=zeros(length(qrs_pos),1);
inxToReject=[];

for i=1:length(qrs_val)
    if(qrs_pos(i)+120<length(PCG_resampled) &&  qrs_pos(i)-120>0)
        [peakValue,peakValueInx]=max(PCG_resampled(qrs_pos(i)-120:qrs_pos(i)+120));
        qrs_val(i)=peakValue;
        inxToReject=[inxToReject  qrs_pos(i)-120+peakValueInx-100:qrs_pos(i)-120+peakValueInx+100];
    end
end
meanPeakValue=quantile(qrs_val,0.58);
inxToReject(inxToReject>length(PCG_resampled) | inxToReject<=0)=[];
PCG_resampled(inxToReject)=[];
transitPosition=find((PCG_resampled(1:end-1)>meanPeakValue & PCG_resampled(2:end)<=meanPeakValue) ...
    | (PCG_resampled(1:end-1)<meanPeakValue & PCG_resampled(2:end)>=meanPeakValue));

transitCounter=length( transitPosition );
% Lower than 18 is good quality
reducedTransitCounter=transitCounter-length( qrs_pos );
end