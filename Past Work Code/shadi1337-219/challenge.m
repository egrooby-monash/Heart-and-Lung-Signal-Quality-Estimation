 

function [classifyResult]= challenge(recordName)
 
  load('Springer_B_matrix.mat');
 load('Springer_pi_vector.mat');
load('Springer_total_obs_distribution.mat');
[data, Fs] = wavread([recordName, '.wav']);
  
audio_data2 =butterworth_high_pass_filter(data,2,700,Fs);
 sigma=std(audio_data2)
 if 4*sigma >= 0.17
    classifyResult=0;
 else
%% Load data and resample data
springer_options   = default_Springer_HSMM_options;
 [PCG, Fs1] = audioread([recordName  '.wav']);  % load data
%  [PCG, Fs1, nbits1] = wavread(['a0001.wav']);  % load data
PCG_resampled      = resample(PCG,springer_options.audio_Fs,Fs1); % resample to springer_options.audio_Fs (1000 Hz)

%% Running runSpringerSegmentationAlgorithm.m to obtain the assigned_states
[assigned_states,denoised_signal] = runSpringerSegmentationAlgorithm2(PCG_resampled , springer_options.audio_Fs, Springer_B_matrix, Springer_pi_vector, Springer_total_obs_distribution, false); % obtain the locations for S1, systole, s2 and diastole
 [signal_s1,signal_s2, signal_systole,signal_diastole]=seperate_states_2(assigned_states,denoised_signal,false);

 [features,A,a]  = extractFeaturesFromHsIntervals2(assigned_states,PCG_resampled,signal_systole,signal_diastole,signal_s1,signal_s2);

%% extracting  11 wtentropy features
%article: christer ahlstrom 

[entropy_matrix]=mean_beat_wt_entropy(denoised_signal,a);

 %% extracting 9 wt features 
%article:christer ahlstrom 
 [sum_matrix_mean]=absolute_sum(denoised_signal,a);
 
%% extracting 9 shannon featueres 
 [shannon_matrix]=shannon_en(denoised_signal,a);

 
 %% calculating mfcc features
%  [MFCCs_s1  MFCCs_s2 MFCCs_systole MFCCs_diastole ]=calculating_mfcc(signal_s1 ,signal_s2 ,signal_systole, signal_diastole,A)
 [mean_mfcc,mean_mfcc_systole ,mean_mfcc_diastole]=calculating_mfcc(signal_s1 ,signal_s2 ,signal_systole, signal_diastole,a);
 feature_taki_mfcc=max( mean_mfcc_systole(4) ,mean_mfcc_diastole(4) );
 
  %[mfcc_s1,mfcc_s2,mfcc_sys,mfcc_dis]=seperate_mfcc(mean_mfcc);

%% Running extractFeaturesFromHsIntervals.m to obtain the features for normal/abnormal heart sound classificaiton

%[mean_entropy_systole,std_entropy_systole,skewness_entropy_systole,kurtosis_entropy_systole,mean_entropy_diastole,std_entropy_diastole,kurtosis_entropy_diastole,skewness_entropy_diastole,mean_power_sys,std_power_sys,kurtosis_power_sys,skewness_power_sys,mean_power_dias,std_power_dias,kurtosis_power_dias,skewness_power_dias]=power_entropy(a,signal_systole,signal_diastole)
power_entropy_mean=power_entropy2(a,signal_systole,signal_diastole);

all_features=[entropy_matrix,feature_taki_mfcc,mean_mfcc(:,1)',mean_mfcc(:,2)',mean_mfcc(:,3)',mean_mfcc(:,4)',power_entropy_mean',shannon_matrix,sum_matrix_mean];
load('w_hame.mat');
load('net_5134_epoch_99.mat')
load('net_R_hame_100.mat')
load('net_r_150.mat')
Y=all_features*w_hame;
 y1=Y(:,1);
 
 if   y1>=0.014
    
     classifyResult=-1;
 else
ye=net_r_150(all_features');
 classifyResult1=converter(ye');
 se=net_R_hame_100(all_features');
 classifyResult2=converter(se');
 pe=net_5134_epoch_99(all_features');
 classifyResult3=converter(pe');
 if classifyResult1==classifyResult2== classifyResult3
     
 classifyResult=classifyResult2;
 else 
     we=(ye+se)/2;
     ze=(we+pe)/2;
     
   classifyResult= converter(ze');
 end
 end
 end
 end



 
