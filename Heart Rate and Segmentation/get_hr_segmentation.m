function HR = get_hr_segmentation(audio_data, Fs, max_HR,min_HR,options)
%% Purpose
% calculate heart rate and segmentation of heart sound
%% Input
% audio_data= heart sound recording
% Fs= sampling frequency
% min_HR and max_HR= minimum and maximum heart rate
% options.env= envelope
% options.autocorr= use and type of autocorrelation
% options.initial_hr= initial heart rate estimation method
% options.systolic= whether to calculate systolic time interval
% options.seg= use and type of heart sound segmentation
%% Output
% heart rate estimation and heart sound segmentation

HR=table;

%% Preprocessing
Fs_new=1000; 
[audio_1000_f,Fs]=get_hr_preprocessing(audio_data,Fs,Fs_new); 

%% Get envelopes
switch options.env
    case 'none'
        envelope=[];
    case 'hilbert'
        envelope = get_hilbert_envelope(audio_1000_f, Fs);
    case 'homomorphic'
        envelope = get_homomorphic_envelope(audio_1000_f, Fs); 
    case 'psd'
        [envelope,~,~,~] = get_psd_envelope(audio_1000_f, Fs);
    case 'wavelet'
        envelope = get_wavelet_envelope(audio_1000_f, Fs);
    case 'stft'
        envelope=getEnvelopeFromSTFT(audio_1000_f,Fs);
    case 'shannon'
        % Restrict amplitude range to [-1,1]
        %audio_1000_f2=audio_1000_f/max(abs(audio_1000_f));
        % Normalise for zero mean and unit standard deviation
        %audio_1000_f2=normalize(audio_1000_f2);
        envelope  = Shannon_Envelope(audio_1000_f, Fs); 
end


%% Autocorrelation
switch options.autocorr
    case 'none'
        sig_autocorr=[];
    case 'original'
        [sig_autocorr,~]=get_hr_autocorrelation(envelope,Fs); 
    case 'filtered'
        [~,sig_autocorr]=get_hr_autocorrelation(envelope,Fs); 
end

%% Initial HR
switch options.init_hr
    case 'none'
        %HR.initial=[];
    case 'autocorr_peak'
        HR.initial=get_hr_peak_autocorrelation(sig_autocorr,max_HR,min_HR,Fs); 
    case 'autocorr_bestpeak'
        HR.initial=get_hr_bestpeak_autocorrelation(sig_autocorr,max_HR,min_HR,Fs);
    case 'autocorr_findpeaks'
        [HR.initial,~,HR.num_peaks]=get_hr_findpeaks_autocorrelation(sig_autocorr,max_HR,Fs);
    case 'autocorr_freq'
        HR.initial=get_hr_freq(sig_autocorr,max_HR,min_HR,Fs);
    case 'autocorr_cc'
        [~,HR.initial] = get_ccSQI_modified(sig_autocorr,max_HR,min_HR, Fs);
    case 'autocorr_svd'
        [~,HR.initial] = get_SVD_score_modified(sig_autocorr,max_HR,min_HR,Fs);
    case 'envelope_freq'
        HR.initial=get_hr_freq(envelope,max_HR,min_HR,Fs);
    case 'envelope_findpeaks'
        [HR.initial,~,HR.num_peaks]=get_hr_findpeaks(envelope,max_HR,Fs); 
    case 'periodicity'
        %% Get heart rate
        Min_cf = (60/max_HR);
        Max_cf = (60/min_HR);
        [~,~,~,HR.initial]=getDegree_cycle_modified(audio_1000_f,Min_cf,Max_cf,Fs);
end



%% Get systolic time interval
switch options.systolic
    case 'none'
        systolicTimeInterval=[]; 
    otherwise
       systolicTimeInterval=get_systolicTimeInterval(sig_autocorr,HR.initial,max_HR,Fs); 
end

 %% Segmentation
 switch options.seg
     case 'none'
     case 'liang'
        [temp,~,~] = get_Liang_peaks_modified(audio_1000_f,Fs,max_HR);
        HR.seg_s1_s2_peaks={temp};
        HR.seg_hr=30/mean(diff(temp))*Fs;
        HR.seg_numpeaks=length(temp);
     case 'schmidt' 
        % Ensure b_matrix is in correct format:
        [len, wid] = size(options.seg_b_matrix);
        if(wid>len)
            options.seg_b_matrix = options.seg_b_matrix';
        end
        [PCG_Features, ~] = getSchmidtPCGFeatures_modified(audio_1000_f, Fs,options.seg_fs); 
              
         [~, ~, qt] = viterbiDecodePCG_SQI_modified(PCG_Features, options.seg_pi_vector, options.seg_b_matrix, HR.initial, systolicTimeInterval, options.seg_fs);
         HR.seg_states = {expand_qt(qt, options.seg_fs, Fs, length(audio_1000_f))};
         [HR.seg_s1_s2_peaks,HR.seg_s1_peaks,HR.seg_s2_peaks]=get_hr_peakpos(qt,length(qt),options.seg_fs,Fs); 
         HR.seg_hr=30/mean(diff(HR.seg_s1_s2_peaks))*Fs;
         HR.seg_numpeaks=length(HR.seg_s1_s2_peaks); 
         HR.seg_s1_s2_peaks={HR.seg_s1_s2_peaks};
         HR.seg_s1_peaks={HR.seg_s1_peaks};
         HR.seg_s2_peaks={HR.seg_s2_peaks};
     case 'springer'
        [PCG_Features, ~] = getSpringerPCGFeatures_modified(audio_1000_f,Fs,options.seg_fs); 
        
        [~, ~, qt] = viterbiDecodePCG_Springer_modified(PCG_Features, options.seg_pi_vector, options.seg_b_matrix, options.seg_total_obs_dist, HR.initial, systolicTimeInterval, options.seg_fs);
        HR.seg_states = {expand_qt(qt, options.seg_fs, Fs, length(audio_1000_f))};
        [HR.seg_s1_s2_peaks,HR.seg_s1_peaks,HR.seg_s2_peaks]=get_hr_peakpos(qt,length(qt),options.seg_fs,Fs); 
        
        HR.seg_hr=30/mean(diff(HR.seg_s1_s2_peaks))*Fs;
        HR.seg_numpeaks=length(HR.seg_s1_s2_peaks); 
        HR.seg_s1_s2_peaks={HR.seg_s1_s2_peaks};
        HR.seg_s1_peaks={HR.seg_s1_peaks};
        HR.seg_s2_peaks={HR.seg_s2_peaks};
 end
 
end













 


    


