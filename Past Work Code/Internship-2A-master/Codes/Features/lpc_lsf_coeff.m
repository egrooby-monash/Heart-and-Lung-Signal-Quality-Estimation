function [output_lpc,  output_lsf] = lpc_lsf_coeff(y, fn)
%%Gives the first 6 coefficients of LPC and LSF


%% INPUT AND OUTPUT
% -- Inputs --
% y: the input signal
% -- Outputs --
% output_mean_lpc: mean of LPC (Linear Predictive Coding) coefficients
% output_mean_lsf: mean of LSF (Line Spectral Frequencies) coefficients



%% INITIALISATION
numberCoeffs = 6;

N = length(y);
time_axis = (1:N)/fn;

%% COMPUTATION OF LPC COEFFICIENTS
% Finding 6 lpc coefficients for the input signal
lpc_coeffs = lpc(y,numberCoeffs);

% Estimatiom of the signal from LPC coefficients
est_x = filter([0 -lpc_coeffs(2:6)],1,y);

% % Display
% figure,
% plot(time_axis,y); hold on
% plot(time_axis,est_x,'--'); hold off
% xlabel('Time (s)'); ylabel('Amplitude'); title('First 6 LPCs estimate on Signal 22'); legend('Original signal','LPC estimate');


%% COMPUTATION OF LSF COEFFICIENTS
lsf_coeffs = poly2lsf(lpc_coeffs); 


%% RESULTS
output_lpc=lpc_coeffs(:,2:numberCoeffs);
output_lsf=lsf_coeffs';



