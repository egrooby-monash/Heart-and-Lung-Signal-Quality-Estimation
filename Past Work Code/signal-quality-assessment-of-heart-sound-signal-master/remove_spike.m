function dspike_signal=remove_spike(input_signal)
% remove spikes
% to replace the samples which are greater than three times of absolute
% average, but the number of samples replaced is limited to 1% the total
% samples
% written by Hong Tang, 2019-04-02

% scale is set to 3
R=3;
dspike_signal=input_signal;

abs_signal=abs(input_signal);
sort_abs=sort(abs_signal,'descend');

% the average of the first 10% amplitude is taken as threshold
TH=mean(sort_abs(1:floor(length(input_signal)*0.1))); 
% to find the time position of samples which are greater than three times
% TH
ind_spike=find(abs_signal>R*TH);

if (~isempty(ind_spike))
    L_one_percent=round(length(input_signal)*0.01);  % not more than 1% samples will be replaced
    if length(ind_spike)>L_one_percent
        [~,ampi]=sort(abs_signal(ind_spike),'descend');
        dspike_signal(ind_spike(ampi(1:L_one_percent)))=sign(input_signal(ind_spike(ampi(1:L_one_percent))))*R*TH;
    end
        dspike_signal(ind_spike)=sign(input_signal(ind_spike))*R*TH;
end
