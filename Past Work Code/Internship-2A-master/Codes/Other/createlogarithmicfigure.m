function createlogarithmicfigure(X1, Y1)
%CREATEFIGURE(X1, Y1)
%  X1:  vector of x data
%  Y1:  vector of y data
% psd spectrum plot fit to logarithmic scale 
%needs to be called by the spectral_features function


% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create semilogx
semilogy(X1,Y1);

box(axes1,'on');
axis(axes1,'tight');
% Set the remaining axes properties
set(axes1,'XMinorTick','on','XScale','log', 'YScale','log');
xlabel('Frequency (Hz)'),ylabel('PSD (dB/Hz)'), title('Periodogram Welch');
