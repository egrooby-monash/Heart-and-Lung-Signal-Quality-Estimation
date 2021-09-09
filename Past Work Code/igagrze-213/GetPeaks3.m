 
function peacks=GetPeaks2(sigIR)

 
    flag=0;
    tabpeak=zeros(3,1);
    slopecount=0;
    lastBeatTime=0;
    peacks=[];
    window=250;
    sigIRPrevSave=[];
    overlap=220;
 
for i=1:length(sigIR)
 
           tabpeak(1)=tabpeak(2);
           tabpeak(2)=tabpeak(3);
           tabpeak(3)=sigIR(i);

 
            if(tabpeak(2)>tabpeak(1) && tabpeak(2)>tabpeak(3) && flag==0)
 
                flag=1;
 
                startB=i; %dodaæ nr_okna*dlugosc okna -1
                startV=tabpeak(2);

            end

            if(flag==1 && tabpeak(3)<tabpeak(2))

                slopecount=slopecount+1;

            end
 
            if(flag==1 && tabpeak(3)>=tabpeak(2))
    
%                 if( slopecount>=5 && abs(startV-sigIR(i))>0.16)
%                     if( slopecount>=8 && abs(startV-sigIR(i))>0.8)
%                         if( slopecount>=8 && abs(startV-sigIR(i))>0.6 && startB-lastBeatTime>35)
%                             if( slopecount>=90 && abs(startV-sigIR(i))>1.5 && startB-lastBeatTime>200)
                                if( slopecount>=78 && abs(startV-sigIR(i))>1.5 && startB-lastBeatTime>200)
%                 if( slopecount>=8 && abs(startV-sigIR(i))>0.26)
%                     if( slopecount>=7 && abs(startV-sigIR(i))>0.4)
                   IBIsample= startB-lastBeatTime;% +inxMaxSigLocal;
                   peacks=[peacks ; startB];
                   lastBeatTime=startB; % +inxMaxSigLocal;
                   
                end
                
                flag=0;
                slopecount=0;
            end

end
% 
% figure(34)
% plot(sigIR);
% hold on;
% plot(peacks,sigIR(peacks),'.r','markersize',5)
% hold off;

