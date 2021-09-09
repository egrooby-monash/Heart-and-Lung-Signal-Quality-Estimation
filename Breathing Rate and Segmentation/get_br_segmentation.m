function BR = get_br_segmentation(audio_data, Fs, max_BR,min_BR,options)
%% Purpose
% Calculate breathing rate
%% Inputs
% audio_data= lung sound
% Fs= sampling frequency
% min_BR and max_BR= minimum and maximum breathing rate range
% options.env= envelope of signal
% options.autocorr= how to calculate autocorrelation
% options.init_hr= options to calculate breathing rate
%% Output
% BR= table with breathing rate estimates

BR=table;

%% Preprocessing
Fs_new=2000; 
[audio_2000_f,Fs]=get_br_preprocessing(audio_data,Fs,Fs_new); 

%% Get envelopes
switch options.env
    case 'none'
        envelope=[];
    case 'hilbert'
        envelope = get_hilbert_envelope(audio_2000_f, Fs);
    case 'psd1'
        [envelope,Fs]=power_spectrum(audio_2000_f,300,450,Fs); 
    case 'psd2'
        [envelope,Fs]=power_spectrum(audio_2000_f,150,450,Fs); 
    case 'psd3'
        [envelope,Fs]=power_spectrum(audio_2000_f,150,300,Fs); 
    case 'homomorphic'
        envelope = get_homomorphic_envelope(audio_2000_f, Fs); 
    case 'variance_fractal_dimension'
        envelope=variance_fractal_dimension(audio_2000_f,Fs);
    case 'logvariance'
        envelope=logvariance(audio_2000_f,Fs); 
    case 'spectral_energy1'
         envelope=get_spectral_energy(audio_2000_f,Fs); 
    case 'spectral_energy2'
        envelope=get_spectral_entropy2(audio_2000_f,Fs); 
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
        BR.initial=[];
    case 'envelope_minimum'
        [BR.initial,BR.initial_1,BR.initial_2,...
            BR.num_peaks,BR.num_peaks_1,BR.num_peaks_2,...
            BR.locs,BR.locs_1,BR.locs_2]=get_br_minimums(envelope,max_BR,Fs); 
        BR.locs={BR.locs};
        BR.locs_1={BR.locs_1};
        BR.locs_2={BR.locs_2};
    case 'autocorr_peak'
        BR.initial=get_hr_peak_autocorrelation(sig_autocorr,max_BR,min_BR,Fs); 
    case 'autocorr_bestpeak'
        BR.initial=get_hr_bestpeak_autocorrelation(sig_autocorr,max_BR,min_BR,Fs);
    case 'autocorr_findpeaks'
        [BR.initial,~]=get_hr_findpeaks_autocorrelation(sig_autocorr,max_BR,Fs);
    case 'autocorr_firstoutlierpeak'
        BR.initial=get_br_firstoutlierpeak_autocorrelation(sig_autocorr,max_BR,min_BR,Fs);
    case 'autocorr_bestpeak_expanded'
         BR.initial=get_br_bestpeak_expanded_autocorrelation(sig_autocorr,max_BR,min_BR,Fs); 
    case 'autocorr_earlypeak'
        BR.initial=get_br_earlypeak_autocorrelation(sig_autocorr,max_BR,min_BR,Fs); 
    case 'autocorr_firstpeak'
         BR.initial=get_br_firstpeak_autocorrelation(sig_autocorr,max_BR,min_BR,Fs); 
    case 'autocorr_freq'
        BR.initial=get_hr_freq(sig_autocorr,max_BR,min_BR,Fs);
    case 'autocorr_cc'
        [~,BR.initial] = get_ccSQI_modified(sig_autocorr,max_BR,min_BR, Fs);
    case 'autocorr_svd'
        [~,BR.initial] = get_SVD_score_modified(sig_autocorr,max_BR,min_BR,Fs);
    case 'envelope_freq'
        BR.initial=get_hr_freq(envelope,max_BR,min_BR,Fs);
    case 'envelope_findpeaks'
        [BR.initial,locs,BR.num_peaks]=get_hr_findpeaks(envelope,max_BR,Fs); 
        BR.locs={locs};
    case 'envelope_findpeaks_br'
         [BR.initial,BR.initial_2,locs,BR.num_peaks]=get_br_findpeaks_envelope(envelope,max_BR,Fs); 
         BR.locs={locs};
    case 'periodicity'
        %% Get breathing rate
        Min_cf = (60/max_BR);
        Max_cf = (60/min_BR);
        [~,~,~,BR.initial]=getDegree_cycle_modified(audio_2000_f,Min_cf,Max_cf,Fs);
end

 %% Segmentation
 switch options.seg
     case 'none'
 end
 
end












