function [meanPSD,stdPSD,medPSD,bw,p25,p75,IQR,p000_100,p100_200,...
    p200_400,p400_600,p600_800,p800_1000,p1000_1200,p1200_1400,...
    p1400_1600,p1600_1800,p1800_2000,TP]=get_spectrum_parameters(pxx,f)
%% Purpose
% Get spectral parameters
%% Input
% pxx,f= power spectral density and associated frequency
%% Outputs
% Spectral parameters

%% Spectrum parameters
% -- Some statistical spectral parameters
meanPSD=meanfreq(pxx,f); %  The mean frequency of a power spectrum
stdPSD=sqrt(sum(pxx.*((f-meanPSD).^2))/sum(pxx));%  The std of a power spectrum
medPSD=medfreq(pxx,f); %  The median frequency of a power spectrum
[bw,~,~,~] = powerbw(pxx,f); % 3db bandwidth of power spectrum
p25=percentilefreq(pxx,f,25); % 25 percentile (1st quartile) of spectral power
p75=percentilefreq(pxx,f,75); % 75 percentile (3rd quartile) of spectral power
IQR=p75-p25; % Interquartile range of spectrum

% -- Power ratios of various frequency (Hz) bands
TP=bandpower(pxx,f,[f(1) f(end)],'psd');% total power for 100-1000Hz
p000_100 = bandpower(pxx,f,[f(1) 100],'psd')/TP;
p100_200 = bandpower(pxx,f,[100 200],'psd')/TP;
p200_400 = bandpower(pxx,f,[200 400],'psd')/TP;
p400_600 = bandpower(pxx,f,[400 600],'psd')/TP;
p600_800 = bandpower(pxx,f,[600 800],'psd')/TP;
p800_1000 = bandpower(pxx,f,[800 1000],'psd')/TP;
if f(end)>1000
    p1000_1200 = bandpower(pxx,f,[1000 1200],'psd')/TP;
    p1200_1400 = bandpower(pxx,f,[1200 1400],'psd')/TP;
    p1400_1600 = bandpower(pxx,f,[1400 1600],'psd')/TP;
    p1600_1800 = bandpower(pxx,f,[1600 1800],'psd')/TP;
    p1800_2000 = bandpower(pxx,f,[1800 f(end)],'psd')/TP;
else
    p1000_1200 = 0;
    p1200_1400 = 0;
    p1400_1600 = 0;
    p1600_1800 = 0;
    p1800_2000 = 0;
end
end