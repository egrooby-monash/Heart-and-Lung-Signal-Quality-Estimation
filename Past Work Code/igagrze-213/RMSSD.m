function [RMSSD1, RMSSD2, RMSSSYS, RMSSDIAS]  = RMSSD( PCG,PCGfiltered,  A )

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
S1=PCG(A(:,1):A(:,2));            % length S1
S2=PCG(A(:,3):A(:,4));            % length S2
SYS=PCGfiltered(A(:,2):A(:,3));            % length S1

DIAS=PCGfiltered(A(2:end,1)-A(1:end-1,4));            % length S2

sumPowS1=sum(diff(S1).^2);
RMSSD1=sqrt(1/(A(:,2)-A(:,1))*sumPowS1);
RMSSD1=mean(RMSSD1);

sumPowS2=sum(diff(S2).^2);
RMSSD2=sqrt(1/(A(:,4)-A(:,3))*sumPowS2);
RMSSD2=mean(RMSSD2);

sumPowSYS=sum(diff(SYS).^2);
RMSSSYS=sqrt(1/(A(:,3)-A(:,1))*sumPowSYS);
RMSSSYS=mean(RMSSSYS);

sumPowDIAS=sum(diff(DIAS).^2);
RMSSDIAS=sqrt(1/(A(2:end,1)-A(1:end-1,4))*sumPowDIAS);
RMSSDIAS=mean(RMSSDIAS);
end

