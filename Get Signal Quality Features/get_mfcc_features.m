function [mfcc_min_coeffs,mfcc_max_coeffs,mfcc_mean_coeffs,mfcc_median_coeffs,...
    mfcc_mode_coeffs,mfcc_var_coeffs,mfcc_mean_min,mfcc_mean_max,mfcc_mean_skew,mfcc_skew_coeffs]...
    =get_mfcc_features(coeffs_detailed)
%% Paper information
% Improving the quality of point of care diagnostics with real-time machine learning in low literacy LMIC settings
% https://dl.acm.org/doi/pdf/10.1145/3209811.3209815
% Heart sound anomaly and quality detection using ensemble of neural networks without segmentation
% https://ieeexplore.ieee.org/document/7868817
%% Purpose
% get mfcc based features
%% Inputs
% mfcc coefficients
%% Outputs
% summary of mfcc coefficients

%% Method
% Improving the quality of point of care diagnostics with real-time machine learning in low literacy LMIC settings
% https://dl.acm.org/doi/pdf/10.1145/3209811.3209815
mfcc_min_coeffs=min(coeffs_detailed);
mfcc_max_coeffs=max(coeffs_detailed);
mfcc_mean_coeffs=mean(coeffs_detailed);
mfcc_median_coeffs=median(coeffs_detailed);
mfcc_mode_coeffs=mode(coeffs_detailed);
mfcc_var_coeffs=var(coeffs_detailed);

% Heart sound anomaly and quality detection using ensemble of neural networks without segmentation
% https://ieeexplore.ieee.org/document/7868817
mfcc_mean_min=mean(min(coeffs_detailed));
m4 = moment((max(coeffs_detailed)),4,2);
mfcc_mean_max = abs(m4.^(1/4));
m4 = moment((skewness(coeffs_detailed)),4,2);
mfcc_mean_skew = abs(m4.^(1/4));
mfcc_skew_coeffs=skewness(coeffs_detailed);

end