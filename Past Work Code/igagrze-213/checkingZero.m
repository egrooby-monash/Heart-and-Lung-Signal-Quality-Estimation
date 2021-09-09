function ifzero=checkingZero(PCG)

      len=length(PCG);
      PCG_resampledNew=[];
      
      windowN=50;
      for j=1:windowN
 
          PCG_resampledtemp=PCG(1+floor(len/windowN)*(j-1):j*floor(len/windowN));
          if( (max(PCG_resampledtemp)-min(PCG_resampledtemp)) ~=0)
          PCG_resampledNew=[PCG_resampledNew ; (PCG_resampledtemp-mean(PCG_resampledtemp))/(max(PCG_resampledtemp)-min(PCG_resampledtemp))];
          end
          
      end
      
      [mdfint] =qrs_detect2_PCG(PCG_resampledNew);
      
      mdfintPoor=mdfint(1:10:end);
      peacks=GetPeaks2(mdfintPoor);
%       [qrs_pos, bpfPCG, mdfint] =qrs_detect2_PCG(PCG_resampledNew);
      qrs_pos=peacks*10;
      
      ifzero=determineZero(mdfint,qrs_pos);