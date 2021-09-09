function [zrc_CS, output_spectral_features_CS, periodogram_pks_features_CS, output_mean_mfcc_CS, output_lpc_CS, output_lsf_CS, zrc_NCS, output_spectral_features_NCS, periodogram_pks_features_NCS, output_mean_mfcc_NCS, output_lpc_NCS, output_lsf_NCS] = NCS_CS_features_boxplot(label_final, X, Fs)
%NCS_CS_features_boxplot: Extract some features of CS and NCS, return them and do their boxplots.

%% INPUTS AND OUTPUTS
%  -- Outputs --
% zrc_CS: Zero crossing rate of CS
% output_spectral_features_CS: Spectral features of CS
% periodogram_pks_features_CS: Peaks features of the CS spectrogram
% output_mean_mfcc_CS: MFCCs means of CS
% output_lpc_CS: LPCs of CS
% output_lsf_CS: LSFs of CS
% zrc_NCS: Zero crossing rate of CS
% output_spectral_features_NCS: Spectral features of CS
% periodogram_pks_features_NCS: Peaks features of the CS spectrogram
% output_mean_mfcc_NCS: MFCCs means of CS
% output_lpc_NCS: LPCs of CS
% output_lsf_NCS: LSFs of CS


% -- Initialisation for feature storage
zrc_CS=[]; output_spectral_features_CS=[]; periodogram_pks_features_CS=[]; output_mean_mfcc_CS=[]; output_lpc_CS=[]; output_lsf_CS=[];
zrc_NCS=[]; output_spectral_features_NCS=[]; periodogram_pks_features_NCS=[]; output_mean_mfcc_NCS=[]; output_lpc_NCS=[]; output_lsf_NCS=[];

window=1; 
overlap=0;

%% FEATURES EXTRACTION

% -- For each recording
for i = 1:size(X, 1)
    x=X(i,:);
    
    %% -- Resampling to 4000 Hz
    xs=resample(x,4000,Fs);
    fn=4000;
    
    %% -- Shorten to 60s
    time_sample=60;
    xss=xs(1,1:time_sample*fn);
    
    % -- Variables
    N = length(xss);
    time_axis = (1:N)/fn;
    
    
    %% -- Finding CS on the signal
    flag_section=1; % CS
    locs=find(label_final(i,:)==flag_section); % Locations of CS
    
    if isempty(locs)==0 % There are CS on the signal
        
        % -- Start time of the labels (for each window)
        start_time=locs*(window-window*overlap)-1;
        
        % -- Start sample of the labels (for each window)
        start_sample=start_time*fn+1;
        label_duration=window*fn; % Number of samples in a window
        
        for n_section=1:length(locs)
            tempName=sprintf('%d.mp3', i);
            [xss_section,time_axis_section] = label2section(xss, n_section, start_sample, label_duration, time_axis);
            
            %% -- Features extraction
            zrc = temporal_features(xss_section,fn, tempName); % Temporal features
            [output_spectral_features, periodogram_pks_features, pxx, f, foct, spower, I, S] = spectral_features(xss_section,fn); % See Fae's comment
           % output_mean_mfcc = mfcc_coeffs(xss_section, fn); % MFCCs coefficient
            [output_lpc, output_lsf] = lpc_lsf_coeff(xss_section, fn); % LPC and LFC coefficient
            
            %% -- Storage of features
            % A new section = a new line
            zrc_CS=[zrc; zrc_CS];
            output_spectral_features_CS=[output_spectral_features'; output_spectral_features_CS];
            periodogram_pks_features_CS=[periodogram_pks_features'; periodogram_pks_features_CS];
           % output_mean_mfcc_CS=[output_mean_mfcc; output_mean_mfcc_CS];
            output_lpc_CS=[output_lpc; output_lpc_CS];
            output_lsf_CS=[output_lsf; output_lsf_CS];
        end
    end
    
    % -- Spectral features
    meanPSD_CS=output_spectral_features_CS(:,1);
    stdPSD_CS=output_spectral_features_CS(:,2);
    medPSD_CS=output_spectral_features_CS(:,3);
    bw_CS=output_spectral_features_CS(:,4);
    p25_CS=output_spectral_features_CS(:,5);
    p75_CS=output_spectral_features_CS(:,6);
    IQR_CS=output_spectral_features_CS(:,7);
    TP_CS=output_spectral_features_CS(:,8);
    p100_200_CS=output_spectral_features_CS(:,9);
    p200_400_CS=output_spectral_features_CS(:,10);
    p400_600_CS=output_spectral_features_CS(:,11);
    p600_800_CS=output_spectral_features_CS(:,12);
    p800_1000_CS=output_spectral_features_CS(:,13);
    p1000_1200_CS=output_spectral_features_CS(:,14);
    spectrum_slope2_CS=output_spectral_features_CS(:,15);
    r_square2_CS=output_spectral_features_CS(:,16);
    
%     % -- MFCC
%     mfcc1_CS=output_mean_mfcc_CS(:,1);
%     mfcc2_CS=output_mean_mfcc_CS(:,2);
%     mfcc3_CS=output_mean_mfcc_CS(:,3);
%     mfcc4_CS=output_mean_mfcc_CS(:,4);
%     mfcc5_CS=output_mean_mfcc_CS(:,5);
%     mfcc6_CS=output_mean_mfcc_CS(:,6);
    
    % -- LPC
    lpc1_CS=output_lpc_CS(:,1);
    lpc2_CS=output_lpc_CS(:,2);
    lpc3_CS=output_lpc_CS(:,3);
    lpc4_CS=output_lpc_CS(:,4);
    lpc5_CS=output_lpc_CS(:,5);
    
    %% -- Finding NCS on the signal
    flag_section=0; % NCS
    locs=find(label_final(i,:)==flag_section); % Locations of NCS
    
    if isempty(locs)==0 % There are NCS on the signal
        
        % -- Start time of the labels (for each window)
        start_time=locs*(window-window*overlap)-1;
        
        % -- Start sample of the labels (for each window)
        start_sample=start_time*fn+1;
        label_duration=window*fn; % Number of samples in a window
        
        for n_section=1:length(locs)
            [xss_section,time_axis_section] = label2section(xss, n_section, start_sample, label_duration, time_axis);
            
            %% -- Features extraction
            zrc = temporal_features(xss_section,fn, tempName); % Temporal features
            [output_spectral_features, periodogram_pks_features, pxx, f, foct, spower, I, S] = spectral_features(xss_section,fn); % See Fae's comment
          %  output_mean_mfcc = mfcc_coeffs(xss_section, fn); % MFCCs coefficient
            [output_lpc, output_lsf] = lpc_lsf_coeff(xss_section, fn); % LPC and LFC coefficient
            
            %% -- Storage of features
            % A new section = a new line
            zrc_NCS=[zrc; zrc_NCS];
            output_spectral_features_NCS=[output_spectral_features'; output_spectral_features_NCS];
            periodogram_pks_features_NCS=[periodogram_pks_features'; periodogram_pks_features_NCS];
           % output_mean_mfcc_NCS=[output_mean_mfcc; output_mean_mfcc_NCS];
            output_lpc_NCS=[output_lpc; output_lpc_NCS];
            output_lsf_NCS=[output_lsf; output_lsf_NCS];
        end
    end
end

% -- Spectral features
meanPSD_NCS=output_spectral_features_NCS(:,1);
stdPSD_NCS=output_spectral_features_NCS(:,2);
medPSD_NCS=output_spectral_features_NCS(:,3);
bw_NCS=output_spectral_features_NCS(:,4);
p25_NCS=output_spectral_features_NCS(:,5);
p75_NCS=output_spectral_features_NCS(:,6);
IQR_NCS=output_spectral_features_NCS(:,7);
TP_NCS=output_spectral_features_NCS(:,8);
p100_200_NCS=output_spectral_features_NCS(:,9);
p200_400_NCS=output_spectral_features_NCS(:,10);
p400_600_NCS=output_spectral_features_NCS(:,11);
p600_800_NCS=output_spectral_features_NCS(:,12);
p800_1000_NCS=output_spectral_features_NCS(:,13);
p1000_1200_NCS=output_spectral_features_NCS(:,14);
spectrum_slope2_NCS=output_spectral_features_NCS(:,15);
r_square2_NCS=output_spectral_features_NCS(:,16);

% % -- MFCC
% mfcc1_NCS=output_mean_mfcc_NCS(:,1);
% mfcc2_NCS=output_mean_mfcc_NCS(:,2);
% mfcc3_NCS=output_mean_mfcc_NCS(:,3);
% mfcc4_NCS=output_mean_mfcc_NCS(:,4);
% mfcc5_NCS=output_mean_mfcc_NCS(:,5);
% mfcc6_NCS=output_mean_mfcc_NCS(:,6);

% -- LPC
lpc1_NCS=output_lpc_NCS(:,1);
lpc2_NCS=output_lpc_NCS(:,2);
lpc3_NCS=output_lpc_NCS(:,3);
lpc4_NCS=output_lpc_NCS(:,4);
lpc5_NCS=output_lpc_NCS(:,5);

%% DISPLAY

%% Parameters of subplot
% -- Spectral features
h_sp=2;
w_sp=7;

% -- MFCC
h_mfcc=2;
w_mfcc=3;

%% Rearrangement of vectors for boxplot

% -- Spectral features
meanPSD=[meanPSD_CS;meanPSD_NCS];
stdPSD=[stdPSD_CS;stdPSD_NCS];
medPSD=[medPSD_CS;medPSD_NCS];
bw=[bw_CS;bw_NCS];
p25=[p25_CS;p25_NCS];
p75=[p75_CS;p75_NCS];
IQR=[IQR_CS;IQR_NCS];
TP=[TP_CS;TP_NCS];
p100_200=[p100_200_CS;p100_200_NCS];
p200_400=[p200_400_CS;p200_400_NCS];
p400_600=[p400_600_CS;p400_600_NCS];
p600_800=[p600_800_CS;p600_800_NCS];
p800_1000=[p800_1000_CS;p800_1000_NCS];
p1000_1200=[p1000_1200_CS;p1000_1200_NCS];
spectrum_slope2=[spectrum_slope2_CS;spectrum_slope2_NCS];
r_square2=[r_square2_CS;r_square2_NCS];

meanPSD_label=[repmat(' meanPSD_CS', length(meanPSD_CS),1); repmat('meanPSD_NCS', length(meanPSD_NCS),1)];
stdPSD_label=[repmat(' stdPSD_CS', length(stdPSD_CS),1); repmat('stdPSD_NCS', length(stdPSD_NCS),1)];
medPSD_label=[repmat(' medPSD_CS', length(medPSD_CS),1); repmat('medPSD_NCS', length(medPSD_NCS),1)];
bw_label=[repmat(' bw_CS', length(bw_CS),1); repmat('bw_NCS', length(bw_NCS),1)];
p25_label=[repmat('p25_CS', length(p25_CS),1); repmat('p25NCS', length(p25_NCS),1)];
p75_label=[repmat(' p75_CS', length(p75_CS),1); repmat('p75_NCS', length(p75_NCS),1)];
IQR_label=[repmat(' IQR_CS', length(IQR_CS),1); repmat('IQR_NCS', length(IQR_NCS),1)];
TP_label=[repmat(' TP_CS', length(TP_CS),1); repmat('TP_NCS', length(TP_NCS),1)];
p100_200_label=[repmat(' p100_200_CS', length(p100_200_CS),1); repmat('p100_200_NCS', length(p100_200_NCS),1)];
p200_400_label=[repmat(' p200_400_CS', length(p200_400_CS),1); repmat('p200_400_NCS', length(p200_400_NCS),1)];
p400_600_label=[repmat(' p400_600_CS', length(p400_600_CS),1); repmat('p400_600_NCS', length(p400_600_NCS),1)];
p600_800_label=[repmat(' p600_800_CS', length(p600_800_CS),1); repmat('p600_800_NCS', length(p600_800_NCS),1)];
p800_1000_label=[repmat(' p800_1000_CS', length(p800_1000_CS),1); repmat('p800_1000_NCS', length(p800_1000_NCS),1)];
p1000_1200_label=[repmat(' p1000_1200_CS', length(p1000_1200_CS),1); repmat('p1000_1200_NCS', length(p1000_1200_NCS),1)];
spectrum_slope2_label=[repmat(' spectrum_slope2_CS', length(spectrum_slope2_CS),1); repmat('spectrum_slope2_NCS', length(spectrum_slope2_NCS),1)];
r_square2_label=[repmat(' r_square2_CS', length(r_square2_CS),1); repmat('r_square2_NCS', length(r_square2_NCS),1)];


% % -- MFCC
% mfcc1=[mfcc1_CS;mfcc1_NCS];
% mfcc2=[mfcc2_CS;mfcc2_NCS];
% mfcc3=[mfcc3_CS;mfcc3_NCS];
% mfcc4=[mfcc4_CS;mfcc4_NCS];
% mfcc5=[mfcc5_CS;mfcc5_NCS];
% mfcc6=[mfcc6_CS;mfcc6_NCS];
% 
% mfcc1_label=[repmat(' mfcc1_CS', length(mfcc1_CS),1); repmat('mfcc1_NCS', length(mfcc1_NCS),1)];
% mfcc2_label=[repmat(' mfcc2_CS', length(mfcc2_CS),1); repmat('mfcc2_NCS', length(mfcc2_NCS),1)];
% mfcc3_label=[repmat(' mfcc3_CS', length(mfcc3_CS),1); repmat('mfcc3_NCS', length(mfcc3_NCS),1)];
% mfcc4_label=[repmat(' mfcc4_CS', length(mfcc4_CS),1); repmat('mfcc4_NCS', length(mfcc4_NCS),1)];
% mfcc5_label=[repmat(' mfcc5_CS', length(mfcc5_CS),1); repmat('mfcc5_NCS', length(mfcc5_NCS),1)];
% mfcc6_label=[repmat(' mfcc6_CS', length(mfcc6_CS),1); repmat('mfcc6_NCS', length(mfcc6_NCS),1)];

% -- LPC
lpc1=[lpc1_CS;lpc1_NCS];
lpc2=[lpc2_CS;lpc2_NCS];
lpc3=[lpc3_CS;lpc3_NCS];
lpc4=[lpc4_CS;lpc4_NCS];
lpc5=[lpc5_CS;lpc5_NCS];

lpc1_label=[repmat(' lpc1_CS', length(lpc1_CS),1); repmat('lpc1_NCS', length(lpc1_NCS),1)];
lpc2_label=[repmat(' lpc2_CS', length(lpc2_CS),1); repmat('lpc2_NCS', length(lpc2_NCS),1)];
lpc3_label=[repmat(' lpc3_CS', length(lpc3_CS),1); repmat('lpc3_NCS', length(lpc3_NCS),1)];
lpc4_label=[repmat(' lpc4_CS', length(lpc4_CS),1); repmat('lpc4_NCS', length(lpc4_NCS),1)];
lpc5_label=[repmat(' lpc5_CS', length(lpc5_CS),1); repmat('lpc5_NCS', length(lpc5_NCS),1)];


%% Boxplot
% -- Spectral features
h_sp=2;
w_sp=2;

figure,
subplot(h_sp, w_sp,1); boxplot(meanPSD, meanPSD_label,'Labels',{'meanPSD_CS', 'meanPSD_NCS'}); title('meanPSD');
subplot(h_sp, w_sp,2); boxplot(stdPSD, stdPSD_label,'Labels',{'stdPSD_CS', 'stdPSD_NCS'}); title('stdPSD');
subplot(h_sp, w_sp,3); boxplot(medPSD, medPSD_label,'Labels',{'medPSD_CS', 'meanPSD_NCS'}); title('medPSD');
subplot(h_sp, w_sp,4); boxplot(bw,bw_label,'Labels',{'bw_CS', 'bw_NCS'}); title('bw');
suptitle('Basic Features on Power Spectrum');

figure,
subplot(h_sp, w_sp,1); boxplot( p25,  p25_label,'Labels',{'p25_CS', 'p25_NCS'});title('p25');
subplot(h_sp, w_sp,2); boxplot(p75, p75_label,'Labels',{'p75_CS', 'p75_NCS'});title('p75');
subplot(h_sp, w_sp,3); boxplot(IQR, IQR_label,'Labels',{'IQR_CS', 'IQR_NCS'});title('IQR');
suptitle('Features on Deviation');

h_sp=2;
w_sp=4;
figure,
subplot(h_sp, w_sp,1); boxplot(TP, TP_label,'Labels',{'TP_CS', 'TP_NCS'});title('TP');
subplot(h_sp, w_sp,2); boxplot(p100_200, p100_200_label,'Labels',{'p100_200_CS', 'p100_200_NCS'});title('p100\_200');
subplot(h_sp, w_sp,3); boxplot(p200_400, p200_400_label,'Labels',{'p200_400_CS', 'p200_400_NCS'});title('p200\_400');
subplot(h_sp, w_sp,4); boxplot(p400_600, p400_600_label,'Labels',{'p400_600_CS', 'p400_600_NCS'});title('p400\_600');
subplot(h_sp, w_sp,5); boxplot(p600_800, p600_800_label,'Labels',{'p600_800_CS', 'p600_800_NCS'});title('p600\_800');
subplot(h_sp, w_sp,6); boxplot(p800_1000, p800_1000_label,'Labels',{'p800_1000_CS', 'p800_1000_NCS'});title('p800\_1000');
subplot(h_sp, w_sp,7); boxplot(p1000_1200, p1000_1200_label,'Labels',{'p1000_1200_CS', 'p1000_1200_NCS'});title('p1000_1200');
suptitle('Features on Band Power');

h_sp=1;
w_sp=2;
figure,
subplot(h_sp, w_sp,1); boxplot(spectrum_slope2, spectrum_slope2_label,'Labels',{'slope_CS', 'slope_NCS'});title('spectrum\_slope2');
subplot(h_sp, w_sp,2); boxplot(r_square2, r_square2_label,'Labels',{'r_square2_CS', 'r_square2_NCS'});title('r\_square2');
suptitle('Features on Spectrum Slope');

% % -- MFCC
% figure,
h=h_mfcc;
w=w_mfcc;
% subplot(h, w,1); boxplot(mfcc1, mfcc1_label,'Labels',{'mfcc1_label_CS', 'mfcc1_label_NCS'}); title('MFCC 1');
% subplot(h, w,2); boxplot(mfcc2, mfcc2_label,'Labels',{'mfcc2_label_CS', 'mfcc2_label_NCS'}); title('MFCC 2');
% subplot(h, w,3); boxplot(mfcc3, mfcc3_label,'Labels',{'mfcc3_label_CS', 'mfcc3_label_NCS'}); title('MFCC 3');
% subplot(h, w,4); boxplot(mfcc4, mfcc4_label,'Labels',{'mfcc4_label_CS', 'mfcc4_label_NCS'}); title('MFCC 4');
% subplot(h, w,5); boxplot(mfcc5, mfcc5_label,'Labels',{'mfcc5_label_CS', 'mfcc5_label_NCS'}); title('MFCC 5');
% subplot(h, w,6); boxplot(mfcc6, mfcc6_label,'Labels',{'mfcc6_label_CS', 'mfcc6_label_NCS'}); title('MFCC 6');
% suptitle('Boxplots of MFCCs for NCS and CS');

% -- LPC
figure,
subplot(h, w,1); boxplot(lpc1, lpc1_label,'Labels',{'lpc1_label_CS', 'lpc1_label_NCS'}); title('LPC 1');
subplot(h, w,2); boxplot(lpc2, lpc2_label,'Labels',{'lpc2_label_CS', 'lpc2_label_NCS'}); title('LPC 2');
subplot(h, w,3); boxplot(lpc3, lpc3_label,'Labels',{'lpc3_label_CS', 'lpc3_label_NCS'}); title('LPC 3');
subplot(h, w,4); boxplot(lpc4, lpc4_label,'Labels',{'lpc4_label_CS', 'lpc4_label_NCS'}); title('LPC 4');
subplot(h, w,5); boxplot(lpc5, lpc5_label,'Labels',{'lpc5_label_CS', 'lpc5_label_NCS'}); title('LPC 5');
suptitle('Boxplots of LPCs for NCS and CS');

end

