% MAIN_JULIE: Main script of the project (preprocessing + spectral analysis)

%% ------ INITIALISATION ------

clear all, close all, clc, dbstop if error;

%% -- CS and NCS color
NCS_color=[0 0.6 0];
CS_color=[0.8 0 0];

%% -- Signal parameters
time_sample=60; % Signal duration
fn=4000; % Sampling frequency

%% -- Path
addpath(genpath('..\..\')); % Access to sample folder
path = pwd; % Current path
path_Learning_Database=[path,'\..\Data\Learning_Database_New\'];
path_Database=[path,'\..\Data\Database\'];
pathExcel = strcat(path, '\'); % Path of the Excel spectral features file
pathExcelPreprocessing = strcat(path, '\'); % Path of the Excel preprocessing file

%% -- Excel file Spectral Features
init = 0; % To generate a new Excel files if necessary
excelFileSpectralFeatures = 'Spectral_Features'; % Name of the Excel file to store features

if ~(exist(pathExcel)) % test to create excel file or no
    disp('creation Excel Spectral Features folder')
    mkdir(pathExcel);
end

excelTemp = strcat([pathExcel excelFileSpectralFeatures], '.xls'); % add the .xls to have complete name

% Add the headers in the Excel file
if (init == 0)
    xlswrite([pathExcel excelFileSpectralFeatures], [{'file'}, {'ZCR'}, {'meanPSD'},{'stdPSD'},{'medPSD'},{'bw'},{'p25'},{'p75'},{'IQR'},{'TP'},{'p100_200'},{'p200_400'},{'p400_800'},{'SL'},{'R2'},{'nb_pks_MAF'}, {'f_higherPk_MAF'}, {'dif_higherPks_MAF'},{'nb_pks_GMM'}, {'f_higherPk_GMM'}, {'dif_higherPks_GMM'}, {'fi.a1'}, {'fi.a2'}, {'fi.a3'}, {'fi.a4'}, {'fi.b1'}, {'fi.b2'}, {'fi.b3'}, {'fi.b4'}, {'fi.c1'}, {'fi.c2'}, {'fi.c3'}, {'fi.c4'}, {'MFCC1'}, {'MFCC2'}, {'MFCC3'}, {'MFCC4'}, {'MFCC5'}, {'MFCC6'}], 'Features 1', 'A1'); % longest segment
    xlswrite([pathExcel excelFileSpectralFeatures], [{'file'}, {'ZCR'}], 'Temporal Features', 'A1'); % Sheet 1
    xlswrite([pathExcel excelFileSpectralFeatures], [{'file'}, {'meanPSD'},{'stdPSD'},{'medPSD'},{'bw'},{'p25'},{'p75'},{'IQR'},{'TP'},{'p100_200'},{'p200_400'},{'p400_600'}, {'p600_800'}, {'p800_1000'}, {'p1000_1200'},{'SL'},{'R2'}], 'Spectral Features 1', 'A1'); % Sheet 2
    xlswrite([pathExcel excelFileSpectralFeatures], [{'file'}, {'nb_pks_MAF'}, {'f_higherPk_MAF'}, {'dif_higherPks_MAF'},{'nb_pks_GMM'}, {'f_higherPk_GMM'}, {'dif_higherPks_GMM'}, {'fi.a1'}, {'fi.a2'}, {'fi.a3'}, {'fi.a4'}, {'fi.b1'}, {'fi.b2'}, {'fi.b3'}, {'fi.b4'}, {'fi.c1'}, {'fi.c2'}, {'fi.c3'}, {'fi.c4'}], 'Spectral Features 2', 'A1'); % Sheet 3
    xlswrite([pathExcel excelFileSpectralFeatures], [{'file'}, {'MFCC1'}, {'MFCC2'}, {'MFCC3'}, {'MFCC4'}, {'MFCC5'}, {'MFCC6'}, {'MFCC7'},{'MFCC8'},{'MFCC9'},{'MFCC10'},{'MFCC11'},{'MFCC12'},{'MFCC13'},{'MFCC14'},{'LPC2'}, {'LPC3'}, {'LPC4'}, {'LPC5'}, {'LPC6'}, {'LSF1'}, {'LSF2'}, {'LSF3'}, {'LSF4'}, {'LSF5'}, {'LSF6'} ], 'Coefficients', 'A1'); % Sheet 4
    init = 1;
end

% %% -- Excel file Preprocessing
init_learning=0;
excelFileSpectralFeaturesPreprocessing = 'CS_Features'; % Name of the Excel file to store features

if ~(exist(pathExcelPreprocessing)) % test to create excel file or no
    disp('Creation Excel Preprocessing folder')
    mkdir(pathExcelPreprocessing);
end

excelTempPreprocessing = strcat([pathExcelPreprocessing excelFileSpectralFeaturesPreprocessing], '.xls'); % add the .xls to have complete name

% Add the headers in the Excel file
if (init_learning == 0)
    xlswrite([pathExcelPreprocessing excelFileSpectralFeaturesPreprocessing], [{'Threshold'},  {'p25'}, {'p75'}, {'Window_label'}, {'Overlap_label'}], 'Learning CS Features', 'A1');
end

%% READ THE SAMPLES
[X_learning, length_signals_learning, names_cell_learning] = read_samples(path_Learning_Database, time_sample, fn);
[X, length_signals, names_cell] = read_samples(path_Database, time_sample, fn);

%% PREPROCESSING

%% -- Removing crying sections (CS)

% -- Learning where are the CS (if not already done)
if (init_learning == 0) % Need to be done one time (data stored on an Excel file)
    [threshold,  band, label_annotated, window_annotated, window_training]= crying_learning(X_learning, fn, CS_color, NCS_color);
    xlswrite([pathExcelPreprocessing excelFileSpectralFeaturesPreprocessing], [threshold ; band(1); band(end); window_annotated; window_training]', 'Learning CS Features', 'A2');
    xlswrite([pathExcelPreprocessing excelFileSpectralFeaturesPreprocessing], [label_annotated], 'Annotated Labels', 'A1');
    init_learning=1;
end

% -- Removing the CS
overlap_training=floor(window_training/3);
% Reading data from the Excel file
outputs_ExcelProcessing=xlsread([pathExcelPreprocessing excelFileSpectralFeaturesPreprocessing],'Learning CS Features','A2:E2');
threshold=outputs_ExcelProcessing(1); band(1)=outputs_ExcelProcessing(2); band(2)=outputs_ExcelProcessing(3); window_annotated=outputs_ExcelProcessing(4); window_training=outputs_ExcelProcessing(5);
label_annotated=xlsread([pathExcelPreprocessing excelFileSpectralFeaturesPreprocessing], 'Annotated Labels');

% Removing the data
[X_ncs, label_training, length_labels_training]=crying_removing(path_Database,time_sample, fn, threshold, band, window_training, overlap_training);


%% -- Display NCS and CS
% signal_n=22; % Put a sample that is in the Learning_Database (between 1 and 37)
% xss=X_learning(signal_n,:);
% xsc=X_ncs(signal_n,:);
% overlap_label=0;
% display_CS_NCS_final(xss, xsc, fn, signal_n, label_annotated, window_annotated, overlap_label, label_training, NCS_color, CS_color);


% For every signals
for signal_n=1:size(X_ncs, 1)
    xss=X(signal_n, 1:length_signals(signal_n));
    xsc=X_ncs(signal_n, :);
    
    % If the signal after CS removal is too short it will not be taken into account (ie all the features =0)
    if xsc==zeros(1, length(xsc))
        str=sprintf('Signal %d with too much cry: unusable', signal_n);
        disp(str)
        output_temporal_features=0;
        output_spectral_features(signal_n,:)=zeros(1, 16);
        periodogram_pks_features(signal_n,:)=zeros(1, 18);
        output_mean_mfcc=zeros(1, 14);
        output_lpc_lsf=zeros(1, 11);
        
        
    else
        str=sprintf('Features extraction on signal %d', signal_n);
        disp(str)
        
        %% -- Filtering BP 100-1200Hz
        y_xss = filterbp(xss,fn);
        y_xsc = filterbp(xsc,fn);
        
        
        %% SPECTRAL FEATURES
        
        %% -- Computation of features
        output_temporal_features = temporal_features(y_xsc,fn); % Temporal features
        [output_spectral_features(signal_n,:),periodogram_pks_features(signal_n,:),pxx(signal_n,:),f(signal_n,:),foct(signal_n,:),spower(signal_n,:),I(signal_n,:),S(signal_n,:)] = spectral_features(y_xsc,fn); % See Fae's comment
        output_mean_mfcc = mfcc_coeffs(y_xss, fn, label_training, length_labels_training, signal_n); % MFCCs coefficient
        [output_lpc, output_lsf] = lpc_lsf_coeff(y_xss, fn); output_lpc_lsf=[output_lpc, output_lsf]; % LPC and LFC coefficient
        
    end
        %% -- Write on Excel file all the features
        signal_name=sprintf('%d.mp3', signal_n);
        
        % Sheet 1
        xlswrite([pathExcel excelFileSpectralFeatures], [signal_n;output_temporal_features]', 'Temporal Features', ['A',num2str(signal_n+1)]);
        xlswrite([pathExcel excelFileSpectralFeatures],{signal_name}, 'Temporal Features',['A',num2str(signal_n+1)]);
        
        % Sheet 2
        xlswrite([pathExcel excelFileSpectralFeatures], [signal_n;output_spectral_features(signal_n,:)']', 'Spectral Features 1', ['A',num2str(signal_n+1)]);
        xlswrite([pathExcel excelFileSpectralFeatures],{signal_name}, 'Spectral Features 1',['A',num2str(signal_n+1)]);
        
        % Sheet 3
        xlswrite([pathExcel excelFileSpectralFeatures], [signal_n;periodogram_pks_features(signal_n,:)']', 'Spectral Features 2', ['A',num2str(signal_n+1)]);
        xlswrite([pathExcel excelFileSpectralFeatures],{signal_name}, 'Spectral Features 2',['A',num2str(signal_n+1)]);
        
        % Sheet 4
        xlswrite([pathExcel excelFileSpectralFeatures], [signal_n;output_mean_mfcc'; output_lpc_lsf']', 'Coefficients', ['A',num2str(signal_n+1)]);
        xlswrite([pathExcel excelFileSpectralFeatures],{signal_name}, 'Coefficients',['A',num2str(signal_n+1)]);
        
end


%% ****** DISPLAY ******

% %% -- Display NCS and CS
% % CS and NCS color
% NCS_color=[0 0.6 0];
% CS_color=[0.8 0 0];
% 
% % Display xss, annotated labels, learnt labels and xsc
% display_CS_NCS_final(xss, xsc, fn, signal_n, label_annotated, window_annotated, window_annotated, label_learning_xss, NCS_color, CS_color);
% 
% 
% %% -- FFT Representation
% 
% % Median with inter-quartile range
% figure(),
% plot(mean(f(find(f(:,2) ~= 0),:)) , median(pxx(find(f(:,2) ~= 0),:))); % average fft
% hold on
% plot(mean(f(find(f(:,2) ~= 0),:)) , prctile(pxx(find(f(:,2) ~= 0),:),25), 'LineStyle', '--', 'Color', 'r'); % std
% plot(mean(f(find(f(:,2) ~= 0),:)) , prctile(pxx(find(f(:,2) ~= 0),:),75), 'LineStyle', '--', 'Color', 'r'); % std
% xlabel('Frequency (in Hz)');
% ylabel('Power Spectrum');
% title('Average Power Spectrum (All groups)');
% legend('Average power spectrum', 'Interquartile range');
% hold off
% 
% % Mean plot
% figure(),
% plot(mean(f(find(f(:,2) ~= 0),:)) , mean(pxx(find(f(:,2) ~= 0),:)));
% xlabel('Frequency (in Hz)');
% ylabel('Power Spectrum');
% title('Average Power Spectrum (all)');
% legend('Average Power Spectrum');
