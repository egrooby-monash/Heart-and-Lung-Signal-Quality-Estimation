function Ratio=getFreqBandRatio(x, fre,fs)
% get frequency band ratio in specified frequency range
% input, x, a signal
%          fre, frequency range
%           fs, sampling frequency

nfft=round(fs);

Fx=abs(fft(x,nfft));

w=fs*(0:nfft-1)/nfft;

% to find the frequency index matched to frequency range
ind=find(w>=fre(1) & w<=fre(2));

% to avoid inf, eps is used 
Ratio=sum(Fx(ind))/(sum(Fx)+eps);