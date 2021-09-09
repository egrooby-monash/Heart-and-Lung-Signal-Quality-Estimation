function [heart_per1,heart_per2]=get_heart_contamination(audio_data,Fs)
%% Paper Information
% Computerized lung sound screening for pediatric auscultation in noisy field environments
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7953509

%% Purpose
% Calculate percentage heart contamination

%% Inputs
% audio_data: recording
% Fs: sampling frequency

%% Output
% heart_per1: percentage heart contamination with threshold 0.2
% heart_per2: percentage heart contamination with threshold 0.1


%% Method- Heart sound detection
% downsample to 1000Hz 
audio_1000 = resample(audio_data,1000,Fs);
Fs=1000;

% Bandpass 50-250Hz 4th order butterworth
audio_1000_f = butterworth_low_pass_filter(audio_1000,2,250,Fs);
audio_1000_f = butterworth_high_pass_filter(audio_1000_f,2,50,Fs);

% Static wavelet transform was obtained at depth 3, using Symlet
% decomposition filters
% SWTj(s(t)} be the wavelet decomposition
N=3;
fin=size(audio_1000_f,1)-mod(size(audio_1000_f,1),2^N);
audio_1000_f=audio_1000_f(1:fin);
[A,~] = swt(audio_1000_f,N,'sym2');
% Aj(t) be the obtained normalized approximation coefficient
A1=A(1,:)/max(abs(A(1,:)));
A2=A(2,:)/max(abs(A(2,:)));
A3=A(3,:)/max(abs(A(3,:)));
% Pi:j(t) is the multiple prodct of all J approximation coefficients
% defined below
P=A1.*A2.*A3; 
% Pi:j>0.2 was considered
heart_per1=sum(abs(P)>0.2)/length(P)*100;
heart_per2=sum(abs(P)>0.1)/length(P)*100;
end