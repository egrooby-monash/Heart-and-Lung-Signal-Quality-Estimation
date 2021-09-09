function [BR,BR_1,BR_2,num_peaks,num_peaks_1,num_peaks_2,locs,locs_1,locs_2]=get_br_minimums(envelope,max_BR,fs)
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


[TF,P] = islocalmin(envelope,'MinSeparation',(30/max_max_BR)*fs); 
window=fs*1;
TF_new=zeros(size(TF));
for i=1:length(envelope)-window+1
    seg=envelope(i:i+window-1);
    TF_seg=TF(i:i+window-1);
    seg_max=max(seg);
    seg_min=min(seg);
    thres=0.5*(seg_max-seg_min);
    TF_seg(TF_seg)=seg(TF_seg)<thres;
    TF_new(i:i+window-1)=TF_seg;
end
num_peaks=sum(TF);
num_peaks_1=sum(TF_new);
locs=find(TF);
locs_1=find(TF_new);
BR=30/(mean(diff(find(TF)))/fs);
BR_1=30/(mean(diff(find(TF_new)))/fs);

p=P(TF);
c=-1/(sqrt(2)*erfcinv(3/2));
scaledMAD=c*median(abs(p-median(p)));
lowthres=median(p)-2*scaledMAD;
num_peaks_2=sum(p>lowthres); 

TF_new=TF;
TF_new(TF)=P(TF)>lowthres;
BR_2=30/(mean(diff(find(TF_new)))/fs);
locs_2=find(TF_new);
end
