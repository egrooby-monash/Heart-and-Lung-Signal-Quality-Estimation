function [spectrum_slope2,intercept,r_square2]=get_regression_line(pxx,f)
%% Paper Information
% Developing a reference of normal lung sounds in healthy Peruvian children
% https://link.springer.com/content/pdf/10.1007/s00408-014-9608-3.pdf
%% Purpose
% Intercept and slope of linear regression line of power spectrum in db/octave 
%% Inputs
% pxx= power spectral density
% f= frequencies
%% Output
% spectrum_slope2= slope of linear regression line
% intercept= intercept of linear regression line
% r_square2= correlation with liner regression line

%% Slope of the regression line (SL) in db/octave
%  The mean frequency of a power spectrum
meanPSD=meanfreq(pxx,f); 
% For octave we need to convert the frequency like this (taking the base as mean frequency)
foct=log2(f/meanPSD); 
spower=10*log10(pxx/pxx(end));
% To fit a linear regression line:
mdl = fitlm(foct(foct>0),spower(foct>0));
I=mdl.Coefficients{1,1};% Intercept
S=mdl.Coefficients{2,1};% slope
%limOct=log2(1000/meanPSD);

intercept=I;
spectrum_slope2 =S;
r_square2=mdl.Rsquared.Adjusted;
end
