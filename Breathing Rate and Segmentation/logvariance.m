function overall=logvariance(audio_data,Fs)
%% Paper Information
% Automatic breath phase detection using only tracheal sounds
% https://ieeexplore.ieee.org/abstract/document/5627437/ 
%% Purpose
% Signal representation that is easier to detect breathing
%% Inputs
% audio_data= lung sounds
% Fs= samplinf frequency 
%% Output
% overall= log variance

% Log Variance
% 150-800Hz 5th order butterworth filter
audio_data = butterworth_low_pass_filter(audio_data,2,800,Fs);
audio_data = butterworth_high_pass_filter(audio_data,3,150,Fs);
% LV parameters calculated in windows of 25ms (256 samples) with 50% overlap between successive windows. Hanning window used
%25 ms window
window_length=25/1000*Fs; 
%50% overlap
overlap_length=window_length*0.5; 
window=hann(window_length,'periodic');
fin=floor(1+(length(audio_data)-window_length)/(window_length-overlap_length));
overall=zeros(1,fin);
if size(window,2)~=size(audio_data,2)
    window=window';
end
for i=1:fin
    segment=audio_data((i-1)*overlap_length+1:(i-1)*overlap_length+window_length).*window;
    overall(i)=log(var(segment));
end
overall= resample(overall, Fs, Fs/(overlap_length));
% For each subject, values of log variance values in each window were normalized by their maximum values.
%make positive
overall=overall-min(overall); 
overall=overall/max(overall);
end 

