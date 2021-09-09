function  [BR,BR_2,locs,num_peaks]=get_br_findpeaks_envelope(envelope,max_BR,Fs)
%% Purpose
% calculate breathing rate
%% Input
% signal_autocorrelation= autocorrelation signal
% audio_data= lung sound
% Fs= sampling frequency
% max_BR=  maximum breathing rate range
%% Output
% BR,BR_2= breathing rate
% loc= location of peaks
% num_peaks= number of peaks detected

max_max_BR=max_BR+20;
%y=envelope-mean(envelope);
%[~, locs,p] = findpeaks(y,'MinPeakDistance',(60/max_max_BR)*Fs);
[~, locs] = findpeaks(envelope,'MinPeakDistance' ,Fs/(max_max_BR/60),'MinPeakHeight',max(envelope)/30,'MinPeakProminence', 0.03);
%c=-1/(sqrt(2)*erfcinv(3/2));
%scaledMAD=c*median(abs(p-median(p)));
%lowthres=median(p)-2*scaledMAD;
%num_peaks=sum(p>lowthres);
%locs=locs(p>lowthres);
%p=p(p>lowthres);
num_peaks=length(locs); 
BR=length(locs)*Fs/length(envelope)*60;
BR_2=60*Fs/mean(diff(locs));

end