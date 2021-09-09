function [per_abnormal_rmssd,per_abnormal_zero,per_abnormal_sd1] = get_segmentation_features(assigned_states,PCG)
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946
%% Purpose
% Calculating the percentage of segments that are abnorma
%% Inputs
% assigned_states: assigned segmentations
% PCG: audio signal 
%% Outputs
% Calculating the percentage of segments that are abnormal based rmsdd (root mean square of successive differences), 
% sd1 of poincare plot and zero crossing rate 
% per_abnormal_rmssd: 
% per_abnormal_zero:
% per_abnormal_sd1:


%% Methods
% used to be called getNewFeatures
% find the locations with changed states
indx = find(abs(diff(assigned_states))>0);

% for some recordings, there are state zeros at the beginning of assigned_states
if assigned_states(1)>0
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

indx2 = indx(K:end);
rem = mod(length(indx2),4);
indx2(end-rem+1:end) = [];
% A is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively
A = reshape(indx2,4,length(indx2)/4)';
%% RMSSD divided into the number of samples
RMSSD_sys_norm=zeros(size(A,1)-1,1);
RMSSD_dias_norm=zeros(size(A,1)-1,1);
RMSSD_all_norm=zeros(size(A,1)-1,1);

zero_sys_norm=zeros(size(A,1)-1,1);
zero_dias_norm=zeros(size(A,1)-1,1);
zero_all_norm=zeros(size(A,1)-1,1);

SD1_sys=zeros(size(A,1)-1,1);
SD1_dias=zeros(size(A,1)-1,1);
SD1_all=zeros(size(A,1)-1,1);

for i=1:size(A,1)-1
    %normalization
    PCG(A(i,1):A(i+1,1))=(PCG(A(i,1):A(i+1,1))-mean(PCG(A(i,1):A(i+1,1))))/...
        (max(PCG(A(i,1):A(i+1,1)))-min(PCG(A(i,1):A(i+1,1))));
    
    PCGtemp_sys=PCG(A(i,2):A(i,3));
    nsys=length(PCGtemp_sys);
    PCGtemp_sys_diff=diff(PCGtemp_sys);
    xp=PCGtemp_sys_diff;
    xp(end)=[];
    xm=PCGtemp_sys_diff;
    xm(1)=[];
    % SD1
    SD1_sys(i) = std(xp-xm)/sqrt(2);
    
    PCGtemp_dias=PCG(A(i,4):A(i+1,1));
    ndias=length(PCGtemp_dias);
    PCGtemp_dias_diff=diff(PCGtemp_dias);
    xp=PCGtemp_dias_diff;
    xp(end)=[];
    xm=PCGtemp_dias_diff;
    xm(1)=[];
    %SD1
    SD1_dias(i) = std(xp-xm)/sqrt(2);
    PCGtemp_all=[PCGtemp_sys ; PCGtemp_dias];
    nall=length(PCGtemp_all);
    
    RMSSD_sys_norm(i)=  sqrt(sum(diff(PCGtemp_sys).^2)/(nsys-1));
    RMSSD_dias_norm(i) = sqrt(sum(diff(PCGtemp_dias).^2)/(ndias-1));
    RMSSD_all_norm(i) = sqrt(sum(diff(PCGtemp_all).^2)/(nall-1));
    
    zero_sys_norm(i)=sum( (PCGtemp_sys(1:end-1)>0 & PCGtemp_sys(2:end)<=0)...
        | (PCGtemp_sys(1:end-1)<=0 & PCGtemp_sys(2:end)>0))/nsys;
    zero_dias_norm(i)=sum( (PCGtemp_dias(1:end-1)>0 & PCGtemp_dias(2:end)<=0)...
        | (PCGtemp_dias(1:end-1)<=0 & PCGtemp_dias(2:end)>0))/ndias;
    zero_all_norm(i)=sum( (PCGtemp_all(1:end-1)>0 & PCGtemp_all(2:end)<=0)...
        | (PCGtemp_all(1:end-1)<=0 & PCGtemp_all(2:end)>0))/nall;
    
    
    PCGtemp_all_diff=diff(PCGtemp_all);
    xp=PCGtemp_all_diff;
    xp(end)=[];
    xm=PCGtemp_all_diff;
    xm(1)=[];
    %SD1
    SD1_all(i) = std(xp-xm)/sqrt(2);
end

coeffRMSSD=(RMSSD_sys_norm-RMSSD_dias_norm)./RMSSD_all_norm;
coeffZERO=(zero_sys_norm-zero_dias_norm)./zero_all_norm;
coeffSD1=(SD1_sys-SD1_dias)./SD1_all;
[per_abnormal_rmssd,per_abnormal_zero,per_abnormal_sd1]=classify_abnormal_segments(coeffRMSSD, coeffZERO, coeffSD1);
end