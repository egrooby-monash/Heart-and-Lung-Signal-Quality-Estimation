function [nb_pks,  f_higherPk, dif_higherPks] = peaks_features(y, f, nb_higherPks_method, tag, t)
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

%%  HIGHER PEAKS TIME

 %%  DISPLAY

% if strcmp('spectrogram', tag)==0
% 
%     % Display the periodogram
%     hold on
%     plot(f_higherPks,higherPks,'or','MarkerEdgeColor',[0 0.6 0], 'MarkerFaceColor',[0 0.6 0], 'LineWidth', 1.5); 
%     plot(f(locs),pks,'or','MarkerEdgeColor',[0 0.6 0], 'LineWidth', 1.5); hold off
%     xlabel('Frequency [Hz]'),ylabel('Power');
% 
%     if strcmp('periodogram_MAF', tag)==1
%         title('Welch Periodogram with Moving Average Filter (MAF)'),
%         legend('Periodogram', 'Smoothed Periodogram', 'Higher Peaks', 'Peaks');
%     elseif strcmp('periodogram_GMM', tag)==1
%         title('Welch Periodogram with Gaussian Mixture Model (GMM)'),
%         legend('Periodogram', 'Gaussian Mixture Model','fi 1','fi 2','fi 3','fi 4',  'Higher Peaks', 'Peaks');
%     end
% end


end

