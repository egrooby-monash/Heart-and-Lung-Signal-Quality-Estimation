function [seg_qual,seg_qual_avg,seg_qual_inv,seg_qual_inv_avg]= get_segmentation_quality(assigned_states,signal_s1,signal_s2,Fs)
%% Paper information
% Heart sounds quality analysis for automatic cardiac biometry applications
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5386481
%% Inputs
% The assigned segmentations and the separated s1 and s2 sounds
% Fs: sampling frequency

%% Purpose
% To assess the segmenatation quality 

%% Outputs
% Segmentation quality 

%% Methods
% We just assume that the assigned_states cover at least 2 whole heart beat cycle
indx = find(abs(diff(assigned_states))>0); % find the locations with changed states

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
% a is N*4 matrix, the 4 columns save the beginnings of S1, systole, S2 and diastole in the same heart cycle respectively
A  = reshape(indx2,4,length(indx2)/4)';

for i=1:size(A,1)-1
    A(i,5)=A(i+1,1);
end
%% S1
if Fs==1000
    NumCoeffs=4;
else
    NumCoeffs=12;
end
seperate_s1= zeros(size(A,1),(NumCoeffs+1)*14); 
 
for i=1:size(A,1)
    temp=signal_s1(A(i,1):A(i,2))';
    coeffs_detailed = mfcc(temp,Fs,'WindowLength',round(0.025*Fs),...
    'OverlapLength',round(0.015*Fs),'NumCoeffs',NumCoeffs);
    coeffs_detail=resample(coeffs_detailed,14,size(coeffs_detailed,1));
    seperate_s1(i,:) = reshape(coeffs_detail,[1 size(coeffs_detail,1)*size(coeffs_detail,2)]);
end
%% S2
seperate_s2= zeros(size(A,1),(NumCoeffs+1)*14); 
for i=1:size(A,1)
    temp=signal_s2(A(i,3):A(i,4))';
    coeffs_detailed = mfcc(temp,Fs,'WindowLength',round(0.025*Fs),...
    'OverlapLength',round(0.015*Fs),'NumCoeffs',NumCoeffs);
    coeffs_detail=resample(coeffs_detailed,14,size(coeffs_detailed,1));
    seperate_s2(i,:) = reshape(coeffs_detail,[1 size(coeffs_detail,1)*size(coeffs_detail,2)]); 
end

ds1=0;
for i=1:size(A,1)
    for j=i:size(A,1)
        differnce=seperate_s1(i,:)-seperate_s1(j,:);
        ds1=ds1+norm(differnce);
    end
end

ds2=0;
for i=1:size(A,1)
    for j=i:size(A,1)
        differnce=seperate_s2(i,:)-seperate_s2(j,:);
        ds2=ds2+norm(differnce);
    end
end

seg_qual=1/(ds1+ds2);
seg_qual_avg=size(A,1)/(ds1+ds2);
seg_qual_inv=ds1+ds2;
seg_qual_inv_avg=seg_qual/size(A,1);
end