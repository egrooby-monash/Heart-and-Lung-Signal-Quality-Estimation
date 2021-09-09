function [output_mean_mfcc] = mfcc_coeffs(y, fn, label_training, length_labels_training, signal_n)
%%Gives the mean mfcc coefficients of the first 6 mfcc coefficients


%% INPUT AND OUTPUT
% any input audio signal
% can be filtered or raw

% input = x 'audio signal'
% Fs 'sampling frequency
% output =  mean mfcc coefficients of the first 6 mfcc coefficients


%% INITIALISATION
% Number of MFCC coefficients wanted
numberCoeffs = 14;

% Default values in mfcc function
window=round(fn*0.03);
overlap=round(fn*0.02);

%% COMPUTATION OF MFCC COEFFICIENTS
% Finding 6 MFCC coefficients for the input signal
coeffs = mfcc(y',fn, 'NumCoeffs', numberCoeffs);

%% REMOVE THE COEEFICIENT CORRESPONDING TO CSs
labels_withPadding=label_training(signal_n, :);
length_label=length_labels_training(signal_n); 
labels=labels_withPadding(1:length_label);
label_frame_mean=zeros(1, length(coeffs));

start_frame=1;
end_frame=start_frame+window-1;
for i=1:length(coeffs)
    start_frame=end_frame-overlap; 
    end_frame=start_frame+window-1; 
    label_frame=labels(start_frame:end_frame);
    label_frame_mean(i)=mean(label_frame)>0.5; % 1 if most of CS, 0 if most of NCS 
end 
NCS=1-label_frame_mean;

for j=1:size(coeffs,2)
    mfcc_ncs(:,j)=coeffs(coeffs(:, j).*NCS'~=0,j);
end

%% RESULT
% Output of the average first 6 MFCC (coeff 1-2-3-4-5-6) 
 output_mean_mfcc = mean(mfcc_ncs(:,1:numberCoeffs));