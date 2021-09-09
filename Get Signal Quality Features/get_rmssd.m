function RMSSDall=get_rmssd(PCG_resampled)
%% Paper Information
% PCG classification using a neural network approach
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7868946
%% Purpose
% Root mean square of successive differences
%% Inputs
% Resampled PCG signal
%% Outputs
% RMSSDall: root mean square of successive differences

%% Method
% Root mean square of successive differences
% Lower than 0.026 is good quality
RMSSDall=sqrt(sum(diff(PCG_resampled).^2)/(length(PCG_resampled)-1));
end 
