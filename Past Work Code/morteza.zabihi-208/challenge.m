function [classifyResult] = challenge(recordName)
%%
% INPUT:
% recordName      ----> input PCG signal name
%
%
% OUTPUT:
% classifyResult  ----> Classification result(s)
%
%
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (April 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%
%% Parameters--------------------------------------------------------------
fs = 2000;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));

load('ANNcinc.mat')
rng(100);
TF = strcmp('.wav',recordName(end-3:end));
if TF ~=1
    recordName = [recordName '.wav'];
end

%% Feature Extraction------------------------------------------------------,
[x, ~] = audioread(recordName);  % load data
% ---------------------------------------------------------------------
[feature] = feature_extraction(x, hamming);% 23 features
% ---------------------------------------------------------------------
[FEATURE_validation] = [feature]; %#ok<NBRAK>
%% Classification ---------------------------------------------------------
[classifyResult]= classification(ppp, nets, NAN_MEAN_INPUT, FEATURE_validation);