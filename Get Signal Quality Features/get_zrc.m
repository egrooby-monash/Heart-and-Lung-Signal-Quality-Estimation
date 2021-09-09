function [ZCR] = get_zrc(x)
%% Purpose
% zero crossing rate
%% INPUT AND OUTPUT
% -- INPUTS
% x 'audio signal'
% fn 'sampling frequency

% -- OUTPUTS =  temporal features including
% ZRC: Zero Crossing Rate

%% ZERO CROSSING RATE
ZCR=sum(abs(diff(sign(x))/2))/length(x);
end
