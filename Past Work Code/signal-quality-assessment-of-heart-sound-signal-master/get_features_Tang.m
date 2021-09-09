function features=get_features_Tang(phs,enve,fs)
%  Function to get 10 features in multiple domains
% For automatic signal quality assessment for heart sound recording
% Written by Hong Tang, tanghong@dlut.edu.cn
% School of Biomedical Engineering, Dalian University of Technology, China
% Anyone is welcome to use the codes for acdamic purpose.
% Welcome to cite the works done by Hong Tang, https://www.researchgate.net/profile/Hong_Tang10
%  2019-05-19
% input: phs, a preprocessinged heart sound recording 
%           enve, envelope of the heart sound recording
%            fs, sampling frequency
% output: features, a row vector containing 21 elements


phs=phs(:)';         % reshape  the input recording to a row vector
enve=enve(:)';     % reshape  to a row vector

%% features from the heart sound signal
% get kurtosis of heart sound signal, 1
Kur_hs=getkurtosis(phs);

%% get energy ratio of low frequency part and high frequency part
fre_Low=[24 144];
fre_High=[200 fs/2];
fre_Midd=[144 200];

Energy_Ratio_Low=getEnergyRatio(phs,fre_Low,fs);      % 2
Energy_Ratio_High=getEnergyRatio(phs,fre_High,fs);    % 3
Energy_Ratio_Midd=getEnergyRatio(phs,fre_Midd,fs);    % 4

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
 
 %% degree of periodicity 
 Min_cf=0.3; Max_cf=2.5;  % cycle frequency considered
d_cfs=getDegree_cycle(phs,Min_cf,Max_cf,fs);  % 10
 
%% return features

features=[Kur_hs             Energy_Ratio_Low      Energy_Ratio_High       Energy_Ratio_Midd  ... 
               Std_enve          Kur_corr                     Max_correlation_coef     ...
               SampEn           SampEn_axcor           d_cfs ];
           
 
