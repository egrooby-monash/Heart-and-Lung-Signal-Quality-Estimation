function [RMSSD1, RMSSD2, RMSSSYS, RMSSDIAS]  = RMSSD( PCG,PCGfiltered,  A )

    RMSSD_sys_norm=[];
    RMSSD_dias_norm=[];
%     RMSSD_all_norm=zeros(size(A,1)-1,1);
    RMSSD_s1_norm=[];
    RMSSD_s2_norm=[];
%     
    
    for i=1:size(A,1)-1
        
        %normalizacja
         
        PCG(A(i,1):A(i+1,1))=(PCG(A(i,1):A(i+1,1))-mean(PCG(A(i,1):A(i+1,1))))/(max(PCG(A(i,1):A(i+1,1)))-min(PCG(A(i,1):A(i+1,1))));

        PCGtemp_sys=PCG(A(i,2):A(i,3));
        nsys=length(PCGtemp_sys);
        
        PCGtemp_dias=PCG(A(i,4):A(i+1,1));
        ndias=length(PCGtemp_dias);
        
        PCGtemp_s1=PCG(A(i,1):A(i,2));
        ns1=length(PCGtemp_s1);
        
        PCGtemp_s2=PCG(A(i,3):A(i,4));
        ns2=length(PCGtemp_s2);

        %SD2
%         SD2_dias(i) = std(xp+xm)/sqrt(2);        
%                figure(3)
%         plot(xp,xm,'b.');
        PCGtemp_all=[PCGtemp_sys ; PCGtemp_dias];
        nall=length(PCGtemp_all);
RMSSD_all_norm = sqrt(sum(diff(PCGtemp_all).^2)/(nall-1));
if(RMSSD_all_norm>0)
        RMSSD_sys_norm=[RMSSD_sys_norm ;   sqrt(sum(diff(PCGtemp_sys).^2)/(nsys-1))/RMSSD_all_norm];
        RMSSD_dias_norm = [RMSSD_dias_norm ; sqrt(sum(diff(PCGtemp_dias).^2)/(ndias-1))/RMSSD_all_norm];
        RMSSD_s1_norm=  [RMSSD_s1_norm ; sqrt(sum(diff(PCGtemp_sys).^2)/(nsys-1))/RMSSD_all_norm];
        RMSSD_s2_norm = [RMSSD_s2_norm ; sqrt(sum(diff(PCGtemp_dias).^2)/(ndias-1))/RMSSD_all_norm];
end


        
     

    end
    
    RMSSD1=mean(RMSSD_s1_norm);
    RMSSD2=mean(RMSSD_s2_norm);
    RMSSSYS=mean(RMSSD_sys_norm);
    RMSSDIAS=mean(RMSSD_dias_norm);

% S1=(A(:,2)-A(:,1));            % length S1
% S2=(A(:,4)-A(:,3));            % length S2
% 
% sumPowS1=sum(S1.*S1);
% findRMSSD1=sqrt(sumPowS1\(length(A)-1)); %RMSSD for S1
% 
% sumPowS2=sum(S2.*S2);
% findRMSSD2=sqrt(sumPowS2\(length(A)-1)); %RMSSD for S2

% S1=PCG(A(:,2)-A(:,1));            % length S1
% S2=PCG(A(:,4)-A(:,3));            % length S2
% S1=PCG(A(:,1):A(:,2));            % length S1
% S2=PCG(A(:,3):A(:,4));            % length S2
% SYS=PCGfiltered(A(:,2):A(:,3));            % length S1
% 
% DIAS=PCGfiltered(A(2:end,1)-A(1:end-1,4));            % length S2
% 
% ALL=PCGfiltered(A(2:end,1)-A(1:end-1,1));
% 
% sumPowS1=sum(diff(ALL).^2);
% RMSSDALL=sqrt(1/(A(2:end,1)-A(1:end-1,4))*sumPowS1);
% 
% sumPowS1=sum(diff(S1).^2);
% RMSSD1=sqrt(1/(A(:,2)-A(:,1))*sumPowS1);
% RMSSD1=mean(RMSSD1./RMSSDALL);
% 
% sumPowS2=sum(diff(S2).^2);
% RMSSD2=sqrt(1/(A(:,4)-A(:,3))*sumPowS2);
% RMSSD2=mean(RMSSD2./RMSSDALL);
% 
% sumPowSYS=sum(diff(SYS).^2);
% RMSSSYS=sqrt(1/(A(:,3)-A(:,1))*sumPowSYS);
% RMSSSYS=mean(RMSSSYS./RMSSDALL);
% 
% sumPowDIAS=sum(diff(DIAS).^2);
% RMSSDIAS=sqrt(1/(A(2:end,1)-A(1:end-1,4))*sumPowDIAS);
% RMSSDIAS=mean(RMSSDIAS./RMSSDALL);
% end
% 
