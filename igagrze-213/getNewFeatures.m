function [ features2] = getNewFeatures(assigned_states,PCG)


%% We just assume that the assigned_states cover at least 2 whole heart beat cycle
indx = find(abs(diff(assigned_states))>0); % find the locations with changed states
% PCGfiltered=movingMean(PCG,6);

% figure(222)
% hold on;
% plot(PCGfiltered-0.1, 'r-');
% plot(PCG,'b-');
% hold off;
% pause

if assigned_states(1)>0   % for some recordings, there are state zeros at the beginning of assigned_states
    switch assigned_states(1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=4;
    end
else
    switch assigned_states(indx(1)+1)
        case 4
            K=1;
        case 3
            K=2;
        case 2
            K=3;
        case 1
            K=0;
    end
    K=K+1;
end

indx2                = indx(K:end);
rem                  = mod(length(indx2),4);
indx2(end-rem+1:end) = [];
A                    = reshape(indx2,4,length(indx2)/4)'; % A is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively

%% RMSSD podzielony na liczbe probek

    RMSSD_sys_norm=zeros(size(A,1)-1,1);
    RMSSD_dias_norm=zeros(size(A,1)-1,1);
    RMSSD_all_norm=zeros(size(A,1)-1,1);
    
    zero_sys_norm=zeros(size(A,1)-1,1);
    zero_dias_norm=zeros(size(A,1)-1,1);
    zero_all_norm=zeros(size(A,1)-1,1);
    
%     assymetry_sys_norm=zeros(size(A,1)-1,1);
%     assymetry_dias_norm=zeros(size(A,1)-1,1);
%     assymetry_all_norm=zeros(size(A,1)-1,1);
%     
    SD1_sys=zeros(size(A,1)-1,1);
    SD1_dias=zeros(size(A,1)-1,1);
    SD1_all=zeros(size(A,1)-1,1);
    
%     SD2_sys=zeros(size(A,1)-1,1);
%     SD2_dias=zeros(size(A,1)-1,1);
%     SD2_all=zeros(size(A,1)-1,1);
%     
%     entropy_sys=zeros(size(A,1)-1,1);
%     entropy_dias=zeros(size(A,1)-1,1);
%     entropy_all=zeros(size(A,1)-1,1
%     
%     len_sys=zeros(size(A,1)-1,1);
%     len_dias=zeros(size(A,1)-1,1);
%     len_s1=zeros(size(A,1)-1,1);
%     len_s2=zeros(size(A,1)-1,1);
%     len_all=zeros(size(A,1)-1,1);
% 
%         IntS1  = A(:,2)-A(:,1);            % mean value of S1 intervals
%         
%         IntS2  = A(:,4)-A(:,3);            % mean value of S2 intervals
%         
%         IntSys = A(:,3)-A(:,2);            % mean value of systole intervals
%         
%         IntDia = A(2:end,1)-A(1:end-1,4);  % mean value of diastole intervals
% %         
%         clf;
%         figure(23)
%         plot(sort(IntS1)); hold on;
%         plot(sort(IntS2)); 
%         plot(sort(IntSys));
%         plot(sort(IntDia));
%         title(num2str(rescurr));
%         ylabel([100 600]);
%         legend('S1','S2','Sys','Dias')
%         hold off;
    
    for i=1:size(A,1)-1
        
        %normalizacja
        PCG(A(i,1):A(i+1,1))=(PCG(A(i,1):A(i+1,1))-mean(PCG(A(i,1):A(i+1,1))))/(max(PCG(A(i,1):A(i+1,1)))-min(PCG(A(i,1):A(i+1,1))));

        PCGtemp_sys=PCG(A(i,2):A(i,3));
        nsys=length(PCGtemp_sys);
        PCGtemp_sys_diff=diff(PCGtemp_sys);
        xp=PCGtemp_sys_diff;
        xp(end)=[];
        xm=PCGtemp_sys_diff;
        xm(1)=[];
        %SD1
        SD1_sys(i) = std(xp-xm)/sqrt(2);
        %SD2
%         SD2_sys(i) = std(xp+xm)/sqrt(2);
%         figure(2)
%         plot(xp,xm,'b.');
        
        PCGtemp_dias=PCG(A(i,4):A(i+1,1));
        ndias=length(PCGtemp_dias);
        PCGtemp_dias_diff=diff(PCGtemp_dias);
        xp=PCGtemp_dias_diff;
        xp(end)=[];
        xm=PCGtemp_dias_diff;
        xm(1)=[];
        %SD1
        SD1_dias(i) = std(xp-xm)/sqrt(2);
        %SD2
%         SD2_dias(i) = std(xp+xm)/sqrt(2);        
%                figure(3)
%         plot(xp,xm,'b.');
        PCGtemp_all=[PCGtemp_sys ; PCGtemp_dias];
        nall=length(PCGtemp_all);

        RMSSD_sys_norm(i)=  sqrt(sum(diff(PCGtemp_sys).^2)/(nsys-1));
        RMSSD_dias_norm(i) = sqrt(sum(diff(PCGtemp_dias).^2)/(ndias-1)); 
        RMSSD_all_norm(i) = sqrt(sum(diff(PCGtemp_all).^2)/(nall-1)); 

%         zero_sys_norm(i)=sum( PCGtemp_sys(1:end-1) );
        zero_sys_norm(i)=sum( (PCGtemp_sys(1:end-1)>0 & PCGtemp_sys(2:end)<=0) | (PCGtemp_sys(1:end-1)<=0 & PCGtemp_sys(2:end)>0))/nsys;
        zero_dias_norm(i)=sum( (PCGtemp_dias(1:end-1)>0 & PCGtemp_dias(2:end)<=0) | (PCGtemp_dias(1:end-1)<=0 & PCGtemp_dias(2:end)>0))/ndias;
        zero_all_norm(i)=sum( (PCGtemp_all(1:end-1)>0 & PCGtemp_all(2:end)<=0) | (PCGtemp_all(1:end-1)<=0 & PCGtemp_all(2:end)>0))/nall;
        
        
        PCGtemp_all_diff=diff(PCGtemp_all);
        xp=PCGtemp_all_diff;
        xp(end)=[];
        xm=PCGtemp_all_diff;
        xm(1)=[];
        %SD1
        SD1_all(i) = std(xp-xm)/sqrt(2);
        
        
%         assymetry_sys_norm(i)=sum(PCGtemp_sys>0)/sum(PCGtemp_sys<=0);
%         assymetry_dias_norm(i)=sum(PCGtemp_dias>0)/sum(PCGtemp_dias<=0);
%         
%         p = hist(PCGtemp_sys);
%         p(p==0)=[];
%         entropy_sys(i) = -sum(p.*log2(p))/nsys;
%         p = hist(PCGtemp_dias);
%         p(p==0)=[];
%         entropy_dias(i) = -sum(p.*log2(p))/ndias;
%         p = hist([PCGtemp_dias ; PCGtemp_sys] );
%         p(p==0)=[];
%         entropy_all(i) = -sum(p.*log2(p))/(ndias+nsys);
        
%         len_sys(i)=nsys;
%         len_dias(i)=ndias;
%         len_all(i)=nsys+ndias;
        
    end
    
%     coeffRMSSD=(RMSSD_sys_norm-RMSSD_dias_norm)./RMSSD_sys_norm;
%     coeffZERO=(zero_sys_norm-zero_dias_norm)./zero_sys_norm;
%     coeffASS=(assymetry_sys_norm-assymetry_dias_norm)./assymetry_sys_norm;
%     coeffSD1=(SD1_sys-SD1_dias)./SD1_sys;
%     coeffSD2=(SD2_sys-SD2_dias)./SD2_sys;
%     coeffENT=(entropy_sys-entropy_dias)./entropy_sys;
%     
    coeffRMSSD=(RMSSD_sys_norm-RMSSD_dias_norm)./RMSSD_all_norm;
    coeffZERO=(zero_sys_norm-zero_dias_norm)./zero_all_norm;
%     coeffASS=(assymetry_sys_norm-assymetry_dias_norm)./assymetry_sys_norm;
    coeffSD1=(SD1_sys-SD1_dias)./SD1_all;
%     coeffSD2=(SD2_sys-SD2_dias)./SD2_sys;
%     coeffENT=(entropy_sys-entropy_dias)./entropy_sys;
%     coeffLEN=(len_sys-len_dias)./len_sys;
    
%     features=[RMSSD_sys_norm RMSSD_dias_norm zero_sys_norm zero_dias_norm assymetry_sys_norm assymetry_dias_norm SD1_sys SD1_dias SD2_sys SD2_dias entropy_sys entropy_dias entropy_all];
    features2=[ coeffRMSSD coeffZERO coeffSD1];