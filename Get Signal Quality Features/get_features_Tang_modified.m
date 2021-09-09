function [Energy_Ratio_Low,Energy_Ratio_High,Energy_Ratio_Mid,d_cfs,...
    Std_enve, Kur_corr, Max_correlation_coef, SampEn, SampEn_axcor,...
    SVD_SQI,ccSQI,Aver_coef, Std_coef,Hr_std]=get_features_Tang_modified(phs,enve,fs)
%% Paper information
% Automated Signal Quality Assessment for Heart Sound Signal by Novel Features and Evaluation in Open Public Datasets
% https://downloads.hindawi.com/journals/bmri/2021/7565398.pdf
% For automatic signal quality assessment for heart sound recording
% Written by Hong Tang, tanghong@dlut.edu.cn
% School of Biomedical Engineering, Dalian University of Technology, China
% Anyone is welcome to use the codes for acdamic purpose.
% Welcome to cite the works done by Hong Tang, https://www.researchgate.net/profile/Hong_Tang10
%  2019-05-19
%% Purpose
%  Function to get 10 features in multiple domains
%% Inputs
% phs, a preprocessinged heart sound recording
% enve, envelope of the heart sound recording
% fs, sampling frequency
%% Oytputs
% output: features, a row vector containing 21 elements


%% get energy ratio of low frequency part and high frequency part
phs=phs(:)';         % reshape  the input recording to a row vector
fre_Low=[24 144];
fre_High=[200 fs/2];
fre_Midd=[144 200];

Energy_Ratio_Low=getEnergyRatio(phs,fre_Low,fs);
Energy_Ratio_High=getEnergyRatio(phs,fre_High,fs);
Energy_Ratio_Mid=getEnergyRatio(phs,fre_Midd,fs);

%% degree of periodicity
% cycle frequency considered
Min_cf=0.3; Max_cf=2.5;  
d_cfs=getDegree_cycle(phs,Min_cf,Max_cf,fs);  % 10

% reshape  to a row vector
enve=enve(:)';     
%%   standard deviation of the envelope
Std_enve=std(enve)/1000;             % 5

%% auto-correlation of the envelope
enve=enve-mean(enve);
axcor_enve_double_side=xcorr(enve,'coeff');
axcor_enve_single_side=axcor_enve_double_side(length(enve):end);

%% kurtosis of the auto-correlation of envelope
Kur_corr=getkurtosis(axcor_enve_double_side);    % 6

%% maximum coefficient of auto-correlation of envelope
Max_correlation_coef=getMaxAxcorCoef(axcor_enve_single_side,fs);  % 7

%% sample entropy of downsampled envelope
m=2; r=0.2;
fsd=30;     % down sampling
down_enve=resample(enve,fsd,fs);
SampEn=getSampEn_fast(down_enve/std(down_enve), m, r);  % 8

%% Sample entropy of the envelope autocorrelation
m=2; r=0.2;  fsd=30;
down_axcor=resample(axcor_enve_single_side,fsd,fs);
down_axcor=down_axcor/std(down_axcor);
SampEn_axcor=getSampEn_fast(down_axcor, m, r);          % 9


%%  ratio of second to first singular values of the SVD of windows of the autocorrelation
SVD_SQI = get_SVD_score_modified(axcor_enve_single_side,fs);  % 17

%% correlation between the autocorrelation signal and a fitted sinusoid
ccSQI = get_ccSQI_modified(axcor_enve_single_side, fs);  % 18


 %% to get overall cycle duration
 Cycle_Dur=getCycleDur_modified(axcor_enve_single_side,fs);
 
 %% average and std of maximum coefficients of adjactive envelope cycles
 [Aver_coef, Std_coef]=getAverCoefStdCoef(enve, Cycle_Dur); % 13  14
 
 %% std of time varying heart rate
 [~,Hr_std]=getStdHeartRate_modified(enve,fs);  % 15
