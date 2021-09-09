function  [mdfint2, PCG] =qrs_detect2_PCG(PCG,varargin) 

    THRES = 0.45; %%% nie zmienialam progu z PCG - mozna probowac
    fs = 1000; %%% zakladam, ze juz jest zrobiony resampling do 1000
    
    switch nargin
        case 1
        case 2
            THRES=varargin{1};
        case 3
            THRES=varargin{1};
            fs=varargin{2};
        otherwise
            error('qrs_detect: wrong number of input arguments \n');
    end


    [a,b] = size(PCG);
    if(a>b); NB_SAMP=a; elseif(b>a); NB_SAMP=b; PCG=PCG'; end;
    tm = 1/fs:1/fs:ceil(NB_SAMP/fs);

    % == constants
    MED_SMOOTH_NB_COEFF = round(fs/100);
    INT_NB_COEFF = round(28*fs/256); % length is 7 for fs=256Hz
    SEARCH_BACK = 1; % perform search back (FIXME: should be in function param)
    MAX_FORCE = []; 
    NB_SAMP = length(PCG); % number of input samples


%     bpfPCG = filterek(PCG,fs,30,50)';
    PCG = butterworth_low_pass_filter(PCG,2,80,1000, false);
    PCG = butterworth_high_pass_filter(PCG,2,30,1000);
%     PCG = schmidt_spike_removal(PCG,1000);
    bpfPCG=PCG';
%     stateofH='normal';
%     recordName='c0004.wav'
%     audiowrite([  'wavPost/' stateofH '_beznorm' '_' recordName ],bpfPCG,1000)
% bpfPCG = filterek(PCG,fs,50,80)'
    bpfPCGNew=[];
    len=length(bpfPCG);
      windowN=40;
      for j=1:windowN
 
          bpfPCGNewtemp=bpfPCG(1+floor(len/windowN)*(j-1):j*floor(len/windowN));
          bpfPCGNew=[bpfPCGNew  (bpfPCGNewtemp-mean(bpfPCGNewtemp))/(max(bpfPCGNewtemp)-min(bpfPCGNewtemp))];
%           bpfPCGNew=[bpfPCGNew  (bpfPCGNewtemp-mean(bpfPCGNewtemp))/(std(bpfPCGNewtemp))];
      end
 
%       bpfPCGNew=bpfPCG;
      
      bpfPCG=bpfPCGNew;
        % == P&T operations
%         dffPCG = diff(bpfPCG');  % (4) differentiate (one datum shorter)
        sqrPCG = bpfPCG'.*bpfPCG'; % (5) square PCG
%         sqrPCG = abs(bpfPCG'); % (5) square PCG
        intPCG = filter(ones(1,INT_NB_COEFF),1,sqrPCG); % (6) integrate
        mdfint = medfilt1(intPCG,MED_SMOOTH_NB_COEFF);  % (7) smooth
        delay  = ceil(INT_NB_COEFF/2);
        mdfint = circshift(mdfint,-delay); % remove filter delay for scanning back through PCG

%   mdfint=movingAvgForwBack(mdfint, 28);
        % == P&T threshold
%         if NB_SAMP/fs>90; xs=sort(mdfint(fs:fs*90)); else xs = sort(mdfint(fs:end)); end;
% 
%         if isempty(MAX_FORCE)
%             if NB_SAMP/fs>10
%                 ind_xs = ceil(94/100*length(xs));
%                 en_thres = xs(ind_xs); % if more than ten seconds of PCG then 98% CI
%             else
%                 ind_xs = ceil(99/100*length(xs));
%                 en_thres = xs(ind_xs); % else 99% CI
%             end
%         else
%             en_thres = MAX_FORCE;
%         end

        
        % build an array of segments to look into
%         poss_reg = mdfint>(THRES*en_thres);


       % P&T QRS detection & search back
%                 if SEARCH_BACK
%                     indAboveThreshold = find(poss_reg); % ind of samples above threshold
%                     RRv = diff(tm(indAboveThreshold));  % compute RRv
% %                     RRv_prctile = prctile(RRv,25);
%                     indMissedBeat = find(RRv>0.01); % missed a peak?
%                     % find interval onto which a beat might have been missed
%                     indStart = indAboveThreshold(indMissedBeat);
%                     indEnd = indAboveThreshold(indMissedBeat+1);
%         
%                     for i=1:length(indStart)
%                         % look for a peak on this interval by lowering the energy threshold
%                         poss_reg(indStart(i):indEnd(i)) = mdfint(indStart(i):indEnd(i))>(0.5*THRES*en_thres);
%                     end
%                 end

        % find indices into boudaries of each segment
%         left  = find(diff([0 poss_reg'])==1);  % remember to zero pad at start
%         right = find(diff([poss_reg' 0])==-1); % remember to zero pad at end


        % loop through all possibilities
%         compt=1;
%         NB_PEAKS = length(left);
%         maxval = zeros(1,NB_PEAKS);
%         maxloc = zeros(1,NB_PEAKS);
%         for i=1:NB_PEAKS
% 
%             [maxval(compt), maxloc(compt)] = max(PCG(left(i):right(i)));
%             maxloc(compt) = maxloc(compt)-1+left(i); % add offset of present location
%             compt=compt+1;
% 
%         end
% 
%         qrs_pos = maxloc; % datapoints QRS positions
        
        mdfint2=mdfint;
         mdfint2=movingAvgForwBack(mdfint, 40);
%                windowN=50;
%       for j=1:windowN
%  
%           PCG_resampledtemp=PCG_resampled(1+floor(len/windowN)*(j-1):j*floor(len/windowN));
%           if( (max(PCG_resampledtemp)-min(PCG_resampledtemp)) ~=0)
%           PCG_resampledNew=[PCG_resampledNew ; (PCG_resampledtemp-mean(PCG_resampledtemp))/(max(PCG_resampledtemp)-min(PCG_resampledtemp))];
%           end
%           
%       end
         
%          mdfint2=(mdfint2-mean(mdfint2))/(max(mdfint2)-min(mdfint2));
         
%          mdfint=mdfint2;
         
         
%          qrs_pos2=[];
%          for k=10:length(mdfint2)-10
%              
% %              if(mdfint2(k-1)<mdfint2(k) && mdfint2(k+1)<mdfint2(k)) 
%              if(sum(mdfint2(k-9:k-1)<mdfint2(k))==9 && sum(mdfint2(k+1:k+9)<mdfint2(k))==9) % && sum(diff(mdfint2(k-9:k-1)))>0.0025 )     
%                  qrs_pos2=[qrs_pos2 ; k];
%                  
%              end
%                  
%          end
%         
%             qrs_pos2(mdfint2(qrs_pos2)<0)=[];
%           qrs_pos = qrs_pos2; % datapoints QRS positions
        
        
        
        
        
        
        
    end



