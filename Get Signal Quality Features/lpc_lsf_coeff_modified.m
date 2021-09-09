function [output_lpc,  output_lsf] = lpc_lsf_coeff_modified(y)
%% Purpose
% Gives the first 6 coefficients of LPC and LSF
%% INPUT AND OUTPUT
% -- Inputs --
% y: the input signal
% -- Outputs --
% output_mean_lpc: mean of LPC (Linear Predictive Coding) coefficients
% output_mean_lsf: mean of LSF (Line Spectral Frequencies) coefficients

%% INITIALISATION
numberCoeffs = 6;

%% COMPUTATION OF LPC COEFFICIENTS
% Finding 6 lpc coefficients for the input signal
lpc_coeffs = lpc(y,numberCoeffs);

%% COMPUTATION OF LSF COEFFICIENTS
lsf_coeffs = poly2lsf(lpc_coeffs);

%% RESULTS
output_lpc=lpc_coeffs;%(:,2:numberCoeffs);
output_lsf=lsf_coeffs';
end