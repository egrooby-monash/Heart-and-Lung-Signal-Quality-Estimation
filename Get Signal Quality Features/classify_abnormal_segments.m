function [per_abnormal_rmssd,per_abnormal_zero,per_abnormal_sd1]=classify_abnormal_segments(coeffRMSSD, coeffZERO, coeffSD1)
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946
%% Purpose
% Calculate percentage of segments that are abnormal
%% Inputs
% coeffRMSSD, coeffZERO, coeffSD1
%% Outputs
% Calculating the percentage of rmsdd, sd1 and zero that are abnormal
% per_abnormal_rmssd: 
% per_abnormal_zero:
% per_abnormal_sd1:

% used to be called newClassifyResults_ALL
%thresholds for 3 selected features
th1=0.8; %rmssd
th2=0.8; %sd1
th4=0.6; %zero

% The percentage of bins where the threshold for
% of the trait is abnormal
%p1=0.8;  %rmssd
%p2=0.7; %sd1
%p4=0.8; %zero
per_abnormal_rmssd=sum(abs(coeffRMSSD)>th1)/length(coeffRMSSD)*100;
per_abnormal_sd1=sum(abs(coeffSD1)>th2)/length(coeffSD1)*100;
per_abnormal_zero=sum(abs(coeffZERO)>th4)/length(coeffZERO)*100;
end




