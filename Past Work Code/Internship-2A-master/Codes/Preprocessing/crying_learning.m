function [final_threshold, band, label_final, window_labelling, window_training] = crying_learning(X, fn, CS_color, NCS_color)
%CRYING_LEARNING:  Label the crying section, and learn where are the CS by using the Power Ratio Tool

%% INPUTS AND OUTPUTS
%  -- Inputs --
% names_cell: Name of the samples
% -- Outputs --
% final_threshold: Threshold used for distinguish CS and NCS
% band: Frequency band used to compare the power ratio of CS and NCS
% label_final: Annotated labels of the signals
% window: Window used for labelling (annotations)
% overlap: Overlap used for labelling (annotations)

%% INITIALISATION
% -- Data
observators=3;
samples=35;
end_sample=60; % End of the signal (hypotesis: length of the signal=60s)

% -- Parameters for labelling
window_labelling=1;
overlap_labelling=0;

% -- Parameters for training
window_training=3;
overlap_training=0;

% -- Parameters for the power ratio
pass_band=[0:2000];
band_width=100;

% -- Path
path = pwd;

% -- Initialisation training segments
CS=[]; NCS=[]; 

%% LABELLING
[label_final, coef_KAPPA]=labelling(observators,samples, end_sample, window_labelling, overlap_labelling);
coef_KAPPA_mean=mean(coef_KAPPA);


%% TRAINING

% Initialisation
pxx_NCS=[]; band_NCS=[]; PR_NCS=[]; p25_NCS=[]; p75_NCS=[];
pxx_CS=[]; band_CS=[]; PR_CS=[]; p25_CS=[]; p75_CS=[];

%% -- Reading files and first preprocessing
% For every signal
for signal_n = 1:size(X,1)
    xss=X(signal_n, :);
    
    %% -- Finding pure CS and NCS
    label_final_xss=label_final(signal_n, :);
    error=0; %% Allowed error on pure segment
    [CS_xss, NCS_xss] = CS_NCS_pure_window(xss, fn, signal_n, label_final_xss, window_training, error, window_labelling);
    CS=[CS_xss; CS];
    NCS=[NCS_xss; NCS];
    CS_nb=size(CS, 1);
    NCS_nb=size(NCS, 1);
end

%% FINDING THE BEST FREQUENCY RANGE
%% -- Power ratio
% CS power ratio
[pxx_CS, powerband_CS, PR_CS, f, p25_CS, p75_CS]=power_ratio_band(pass_band, fn, CS, band_width);

% NCS power ratio
[pxx_NCS, powerband_NCS, PR_NCS, f, p25_NCS, p75_NCS]=power_ratio_band(pass_band, fn, NCS, band_width);

%display_power_spectrum( pxx_CS', pxx_NCS', f );

% NCS: average on all signals
pxx_NCS_mean=mean(pxx_NCS(pxx_NCS~=0)); % NCS mean periodogram
band_NCS_mean=mean(powerband_NCS(band_NCS~=0)); % NCS mean periodogram on different frequency bands
PR_NCS_mean=mean(PR_NCS(PR_NCS~=0)); % NCS Power Ratio: normalized band_NCS_mean
p25_NCS_mean=mean(p25_NCS(p25_NCS~=0)); % NCS p25 in frequency
p75_NCS_mean=mean(p75_NCS(p75_NCS~=0)); % NCS p75 in frequency

% CS: average on all signals
pxx_CS_mean=mean(pxx_CS(pxx_CS~=0));
band_CS_mean=mean(powerband_CS(band_CS~=0));
PR_CS_mean=mean(PR_CS(PR_CS~=0));
p25_CS_mean=mean(p25_CS(p25_CS~=0));
p75_CS_mean=mean(p75_CS(p75_CS~=0));

%% OTHER FEATURES (not used now)
% -- SPECTROGRAM
signal_n=15; % Signal number wanted
xss=X(signal_n, :); % Signal wanted
label=label_final(signal_n, :); % Label of the signal
wind_time_spec=0.5; % Window of 1 second
overlap_spec=0.25; % 25% overlap
start_time=0; end_time=15; % Part of the signal wanted
[s, f, t] = spectrogram_CS(xss, label, fn, signal_n, wind_time_spec, overlap_spec, start_time, end_time, window_labelling, overlap_labelling);

% -- NCS&CS FEATURES EXTRACTION
[zrc_CS, output_spectral_features_CS, periodogram_pks_features_CS, output_mean_mfcc_CS, output_lpc_CS, output_lsf_CS, zrc_NCS, output_spectral_features_NCS, periodogram_pks_features_NCS, output_mean_mfcc_NCS, output_lpc_NCS, output_lsf_NCS,] = NCS_CS_features_boxplot(label_final, X, fn);

%% THRESHOLD DETERMINATION

% -- Powerband in the best frequency range
band=[p25_CS_mean, p75_CS_mean];

% For every pure CS section
powerband_CS=bandpower(CS', fn, band);
label_CS=ones(1,CS_nb);

% For every pure NCS section
powerband_NCS=bandpower(NCS', fn, band);
label_NCS=zeros(1,NCS_nb);

% -- ROC
nb_thresholds=500; % Number of thresholds for the ROC
label_annotated=[label_CS, label_NCS]';
powerband=[powerband_CS, powerband_NCS]';
[fpr, tpr, final_threshold] = threshold_ROC( nb_thresholds, label_annotated, powerband); % Compute the ROC


% %% DISPLAY
% 
% % Display annoted labels NCS and CS
% signal_n=22;
% display_NCS_CS_annotations(signal_n,label_final, window_labelling, overlap_labelling)
% 
% %  Display the periodograms of annotated NCS and CS
% display_PR_NCS_CS_interquartiles(f,pxx_NCS, pxx_CS, pxx_NCS_mean, pxx_CS_mean, band_width, pass_band, band_NCS_mean, band_CS_mean, CS_color, NCS_color);

end
