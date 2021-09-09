function [fitresult, gof] = createFit3(f, power)
%CREATEFIT(F,POWER)
%  Create a fit.
%%producing linear regression line fit to logarithmic scale psd
%needs to be called by spectral_features function
%  Data for 'untitled fit 1' fit:
%      X Input : f
%      Y Output: power
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%

gof = 1;
%% Fit: 'untitled fit 1'.
[X, y] = prepareCurveData( f, power );

P = [p1;p2];
modelfun = @(x,P) p1*log10(x) + p2;
p1 = 1;
p2 = 0;

modelstr = 'y ~ p1*log10(x) + p2';

mdl = fitnlm(X,y,modelfun,[p1;p2]);

disp(mdl);


% Plot fit with data.
% figure( 'Name', 'Average Spectrum Slope (Group 4)');
% disp(fitresult);
% % h = plot( log(fitresult), xData, log(yData) );
% legend( h, 'Power vs. Frequency', 'Linear Regression', 'Location', 'NorthEast' );
% title('Average Spectrum Slope (Group 4)');
% % Label axes
% xlabel('Frequency (in Hz)');
% ylabel('Power (dB/Hz)');
% grid on