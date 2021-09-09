function [ifzero]=detectNoisySignals2(PCG_resampled, qrs_pos)



    quantSigValue=quantile(PCG_resampled,0.85);
    transitPosition=find((PCG_resampled(1:end-1)>quantSigValue & PCG_resampled(2:end)<=quantSigValue) ...
        | (PCG_resampled(1:end-1)<quantSigValue & PCG_resampled(2:end)>=quantSigValue));
    
    transitCounter=length( transitPosition );
    transitCounterNorm=transitCounter/length(PCG_resampled);
    
    RMSSDall=sqrt(sum(diff(PCG_resampled).^2)/(length(PCG_resampled)-1));
    
    if(transitCounterNorm>0.06 && RMSSDall>=0.026)
%             if( RMSSDall>=0.026)
        ifzero=1;
         reducedTransitCounter=[];
    else

        beatsPerSecond=(length(PCG_resampled)/1000)/length(qrs_pos);


        if( beatsPerSecond>1.1 )


            ifzero = determineZero(PCG_resampled,qrs_pos)
            reducedTransitCounter=[];
        else    






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
    %     meanPeakValue1=mean(qrs_val);




        transitPosition=find((PCG_resampled(1:end-1)>meanPeakValue & PCG_resampled(2:end)<=meanPeakValue) ...
            | (PCG_resampled(1:end-1)<meanPeakValue & PCG_resampled(2:end)>=meanPeakValue));

        transitCounter=length( transitPosition );

    %     transitPositionIntervals=diff(transitPosition);
    %     quantilePeakIntervals=transitPositionIntervals(transitPositionIntervals>quantile(transitPositionIntervals,w));

    %         reducedTransitCounter=transitCounter-2*length( qrs_pos ); %wersja z innym qrsdet
            reducedTransitCounter=transitCounter-length( qrs_pos );
            if(reducedTransitCounter>=18)
                ifzero=1;
            else
                ifzero=0;
            end

        end
        
    end
  