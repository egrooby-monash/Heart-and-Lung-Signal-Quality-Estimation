function [ qrs_pos,   PCG_resampledNew]=checkingZero2(PCG)

      len=length(PCG);
      PCG_resampledNew=[];
      
      %normalisation
      windowN=25;
      for j=1:windowN
 
          PCG_resampledtemp=PCG(1+floor(len/windowN)*(j-1):j*floor(len/windowN));
          if( (max(PCG_resampledtemp)-min(PCG_resampledtemp)) ~=0)
          PCG_resampledNew=[PCG_resampledNew ; (PCG_resampledtemp-mean(PCG_resampledtemp))/(max(PCG_resampledtemp)-min(PCG_resampledtemp))];
          end
          
      end
%       PCG_resampledNew=PCG;
      
      [mdfint,PCG_resampledNew] =qrs_detect2_PCG(PCG_resampledNew);
%       [qrs_pos,sign,en_thres,mdfint]=qrs_detect2_base(PCG_resampledNew,0.6);
      
      mdfintPoor=mdfint(1:10:end);
%       peacks=GetPeaks2(mdfintPoor);
% mdfint=mdfint-movingMean(mdfint,12);
      peacks=GetPeaks3(mdfint);
%       [qrs_pos, bpfPCG, mdfint] =qrs_detect2_PCG(PCG_resampledNew);
%       qrs_pos=peacks*10;
qrs_pos=peacks;
      ifzero=0;
%       ifzero=determineZero(mdfint,qrs_pos, windowi, overlapi, thdowni, thupi);