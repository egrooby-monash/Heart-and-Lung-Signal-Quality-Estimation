function [wav_log, Shannon_a5,Tsallis_a5,Renyi_a5,Shannon_d5,Tsallis_d5,Renyi_d5,Shannon_d4,Tsallis_d4,Renyi_d4]=get_wavelet_features_zabihi(x)
%% Paper informaiton
% Heart sound anomaly and quality detection using ensemble of neural networks without segmentation
% https://ieeexplore.ieee.org/document/7868817

%% INPUT:
% x: Raw data
% 
%% OUTPUT:
% Shannon, Renyi and Tsallis entropy of a5, d5 and d4 wavelet decompositions
% wav_log: log variance of d3 wavelet decomposition

%% Other information
% Contact:
% Morteza Zabihi (morteza.zabihi@gmail.com) && Ali Bahrami Rad(abahramir@yahoo.com)
% Black Swan Team (July 2016)
% This code is released under the MIT License (MIT) (http://opensource.org/licenses/MIT)
%% Wavelet transform based feature
level = 5;
[c,l] = wavedec(x,level,'db4');

a5 = appcoef(c,l,'db4');
d5 = detcoef(c,l,level);
d4 = detcoef(c,l,level-1);
d3 = detcoef(c,l,level-2);

wav_log = log2(var(d3)); 
[Shannon_a5,Tsallis_a5,Renyi_a5]=get_prob_entropy(a5);
[Shannon_d5,Tsallis_d5,Renyi_d5]=get_prob_entropy(d5);
[Shannon_d4,Tsallis_d4,Renyi_d4]=get_prob_entropy(d4); 
end