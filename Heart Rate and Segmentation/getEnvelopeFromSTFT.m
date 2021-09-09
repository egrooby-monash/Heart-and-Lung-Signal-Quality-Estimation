function envelope=getEnvelopeFromSTFT(phs,fs)
%% Paper Information
% Automated Signal Quality Assessment for Heart Sound Signal by Novel Features and Evaluation in Open Public Datasets
% https://downloads.hindawi.com/journals/bmri/2021/7565398.pdf

%% Purpose
% get envelope from short time Fourier transform

%% Inputs
% phs: The audio data from the PCG recording
% Fs: the sampling frequency of the audio recording

%% Output
% stft envelope


% sliding window
win=ones(0.03*fs,1); 
% number of overlapping samples
noverlap=length(win)-1;   
% number of bins in FFT
nfft=fs;    

% short time Fourier transform
[s,~,~]=spectrogram(phs,win,noverlap,nfft,fs);

% get smoothed magnitude by average
Ins_fre_raw=sum(abs(s))/nfft;

fc=20;    % cutt-off frequency, Hz
[b,a]=butter(3,2*fc/fs);  % butterworth filter

% low pass filter
Ins_fre=filtfilt(b,a,Ins_fre_raw);

% remove spike
envelope=remove_spike(Ins_fre);
envelope = resample(envelope', length(phs), length(envelope));
end

