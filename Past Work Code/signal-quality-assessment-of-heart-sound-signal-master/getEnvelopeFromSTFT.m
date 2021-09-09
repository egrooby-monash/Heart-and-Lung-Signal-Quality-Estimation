function envelope=getEnvelopeFromSTFT(phs,fs)
% get envelope from short time Fourier transform
%

    win=ones(0.03*fs,1);   % sliding window
    noverlap=length(win)-1;   % number of overlapping samples 
    nfft=fs;    % number of bins in FFT

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

