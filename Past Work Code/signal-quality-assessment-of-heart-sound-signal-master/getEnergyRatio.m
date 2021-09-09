function Ratio=getEnergyRatio(x, fre,fs)
% get energy ratio in specified frequency range
% input, x, a signal
%          fre, frequency range
%           fs,sampling frequency

nfft=round(fs);
[px,w]=pwelch(x,[],[],nfft,fs);

% to find the frequency index matched to frequency range
ind=find(w>=fre(1) & w<=fre(2));

% to avoid inf, eps is used 
Ratio=sum(px(ind))/(sum(px)+eps);





