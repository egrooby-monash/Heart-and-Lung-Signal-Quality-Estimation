function [nb_pks,  f_higherPk, dif_higherPks] = peaks_features_modified(y, f, nb_higherPks_method)
%% Purpose 
%peaks_features: Computes features related to peaks (higher peak, number of
%peaks, their frequencies)
%% INPUT AND OUTPUT
% -- Inputs --
% y: periodogram or spectrogram
% f: frequency
% nb_higherPks_method: number of higher peaks wanted
% tag: Type of periodogram or spectrogram
% t: time (useful for the spectrogram)
% -- Outputs --
% nb_pks: number of peaks
% f_pks: frequency of these peaks
% dif_higherPks: 2 higher peaks frequency differences
%% NUMBER OF PEAKS
[pks,locs] = findpeaks(y);
nb_pks=length(pks);

%% FREQUENCY OF PEAKS (in ascending order im term of PSD)
[pksOrder,order] = sort(pks); % Rank the peaks in ascending order
f_pks=f(locs(order));

%%  HIGHER PEAKS FREQUENCY
nb_higherPks=min(length(pks),nb_higherPks_method);
higherPks=[];
argmax_higherPks=[];
f_higherPks=[];
if nb_higherPks>0
    for i=0:nb_higherPks-1
        higherPks=[higherPks, pksOrder(end-i)]; % Higher peaks
        argmax_higherPks=[argmax_higherPks, order(end-i)];
        f_higherPks=[f_higherPks, f(locs(argmax_higherPks(i+1)))]; % Frequency of peaks
    end
    f_higherPk=f_higherPks(1);
    dif_higherPks=f_higherPks(1)-f_higherPks(end); % 0 if there is only one peak
else
    f_higherPk=0;
    dif_higherPks=0;
end

end
