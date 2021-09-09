function transitCounterNorm =get_zcr_1(PCG_resampled)
% used to be called detectNoisySignals2
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946

%% Inputs
% Resampled PCG signal

%% Outputs
% transitCounterNorm: number of times crossing 0.85 percentile value

%% Method
% Number of times which signal intersected the horizontal line
% Horizontal line determined by 0.85 quantile of values of that signal
% divided by teh signal length
% Horizontal line value
quantSigValue=quantile(PCG_resampled,0.85);
% Number of times intersected
transitPosition=find((PCG_resampled(1:end-1)>quantSigValue & PCG_resampled(2:end)<=quantSigValue) ...
    | (PCG_resampled(1:end-1)<quantSigValue & PCG_resampled(2:end)>=quantSigValue));
transitCounter=length(transitPosition);
% Divided by signal length
% Lower than 0.06 is good quality
transitCounterNorm=transitCounter/length(PCG_resampled);
end 