function ifzero = determineZero(PCG_resampled,qrs_pos)

% window=4050;
% overlap=0.5;
% peacksDensity=[];
% thdown=9;
% thup=20;

window=2200;
overlap=0.25;
peacksDensity=[];
thdown=2;
thup=4;

      offset=(1:round(overlap*window):size(PCG_resampled)); %tworzymy wektor indeksow ECG
      id1=[0:window-1]'; %tworzymy wektor [0 1 2 ... window-1] - o dlugosci jednego okna 
      idx=bsxfun(@plus, id1, offset); %dzieki funkcji bsxfun powstaje tablica indeksow -  taka, ¿e w n-tej kolumnie znajduja sie kolejne probki z n-tego okna sygnalu
%       wielkatablica=mdfint(idx); %pobieramy wartosci dla indeksow sygnalu z tablicy
%       if(sum(idx(:,end))>length(mdfint)>0) idx=idx(:,1:end-1); end
        IDX=[];
        for j=1:size(idx,2)
            if(idx(end,j)<length(PCG_resampled)) IDX=[IDX  idx(:,j)]; end
        end

      for i=1:size(IDX,2)
         
          peacksDensity=[peacksDensity ; sum(ismember(qrs_pos,IDX(:,i)))];
          
      end
     
      
      peacksDensityBin=peacksDensity>=thdown & peacksDensity<=thup;
%        [peacksDensity peacksDensityBin]
%       if(size(peacksDensityBin,1)>3)
%       offset=(1:size(peacksDensityBin)-2); %tworzymy wektor indeksow ECG
%       id1=[0:3-1]'; %tworzymy wektor [0 1 2 ... window-1] - o dlugosci jednego okna 
%       idx=bsxfun(@plus, id1, offset); %dzieki funkcji bsxfun powstaje tablica indeksow -  taka, ¿e w n-tej kolumnie znajduja sie kolejne probki z n-tego okna sygnalu
%       
%       
%           if(sum(sum(peacksDensityBin(idx))==3)==0) 
%               ifzero=1; 
%           else
%               ifzero=0;
%           end
%       
%       else
%           idx=[1:size(peacksDensityBin)];
%           if(sum(peacksDensityBin(idx))==0) 
%               ifzero=1; 
%           else
%               ifzero=0;
%           end
%           
%           
%       end
%       
        if(sum(peacksDensityBin)/length(peacksDensityBin)<=0.65)
            ifzero=1;
        else
            ifzero=0;
        end
% 
%        if(size(peacksDensityBin,1)>4)
%       offset=(1:size(peacksDensityBin)-3); %tworzymy wektor indeksow ECG
%       id1=[0:4-1]'; %tworzymy wektor [0 1 2 ... window-1] - o dlugosci jednego okna 
%       idx=bsxfun(@plus, id1, offset); %dzieki funkcji bsxfun powstaje tablica indeksow -  taka, ¿e w n-tej kolumnie znajduja sie kolejne probki z n-tego okna sygnalu
%       
%       
%           if(sum(sum(peacksDensityBin(idx))==4)==0) 
%               ifzero=1; 
%           else
%               ifzero=0;
%           end
%       
%       else
%           idx=[1:size(peacksDensityBin)];
%           if(sum(peacksDensityBin(idx))==0) 
%               ifzero=1; 
%           else
%               ifzero=0;
%           end
%           
%           
%       end
      

      
       


